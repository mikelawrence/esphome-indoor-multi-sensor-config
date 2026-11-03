

#!/bin/bash
set -uo pipefail

fix_mode=0
if [[ ${1:-} == "--fix" ]]; then
  fix_mode=1
elif (($#)); then
  echo "Usage: $0 [--fix]" >&2
  exit 2
fi
script_start=${EPOCHREALTIME/./}

mkdir -p test/.esphome
# Only the latest run is kept, like the build logs
validation_log="test/.esphome/validate-$(date +%Y-%m-%d).log"
rm -f test/.esphome/validate-*.log
: > "$validation_log"
command_log=$(mktemp)
warning_files=$(mktemp)
trap 'rm -f "$command_log" "$warning_files"' EXIT

run_logged() {
  label=$1
  shift
  printf '\n===== %s =====\n' "$label" >> "$validation_log"
  "$@" > "$command_log" 2>&1 &
  local pid=$!
  if ((interactive)); then
    while kill -0 "$pid" 2>/dev/null; do
      draw_table
      sleep 0.5
    done
  fi
  wait "$pid"
  status=$?
  cat "$command_log" >> "$validation_log"
  return "$status"
}

prepare_fail() {
  draw_table
  echo "$1 See $validation_log" >&2
  exit 1
}

validation_failed=0
check_index=0

# Prune build/VCS trees while walking: yamllint walks them (thousands of files on the
# slow Docker bind mount) even though .gitignore excludes them from linting.
mapfile -t yaml_files < <(
  find . \( -name .git -o -name .esphome -o -name node_modules \) -prune -o \
    -type f \( -name '*.yaml' -o -name '*.yml' -o -name '.yamllint' \) -print | sort
)
mapfile -t cpp_files < <(
  find components -type f \( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' -o -name '*.tcc' \) -print
)
mapfile -t python_files < <(find components -type f -name '*.py' -print | sort)
mapfile -t convention_files < <(
  find components test \( -name .esphome -o -name .git -o -name node_modules \) -prune -o -type f \( \
    -iname '*.c' -o -iname '*.cfg' -o -iname '*.conf' -o -iname '*.cpp' -o -iname '*.css' \
    -o -iname '*.h' -o -iname '*.html' -o -iname '*.ini' -o -iname '*.js' -o -iname '*.json' \
    -o -iname '*.md' -o -iname '*.py' -o -iname '*.ps1' -o -iname '*.proto' -o -iname '*.sh' \
    -o -iname '*.tcc' -o -iname '*.toml' -o -iname '*.txt' -o -iname '*.yaml' -o -iname '*.yml' \
    -o -name '.clang-format' -o -name '.clang-tidy' -o -name '.editorconfig' -o -name '.flake8' \
    -o -name '.gitattributes' -o -name '.gitignore' -o -name '.yamllint' -o -name 'LICENSE' \
  \) -print | sort
)
all_checked_files=$(printf '%s\n' \
  "${yaml_files[@]}" "${cpp_files[@]}" "${python_files[@]}" "${convention_files[@]}" |
  sed '/^$/d' | sort -u)
checked_file_count=$(printf '%s\n' "$all_checked_files" | sed '/^$/d' | wc -l)

declare -A group_checks=([YAML]=0 [C/C++]=0 [Python]=0 [Conventions]=0)
declare -A group_failures=([YAML]=0 [C/C++]=0 [Python]=0 [Conventions]=0)
declare -A group_warnings=([YAML]=0 [C/C++]=0 [Python]=0 [Conventions]=0)
declare -A group_files=(
  [YAML]=${#yaml_files[@]}
  [C/C++]="${#cpp_files[@]}"
  [Python]=${#python_files[@]}
  [Conventions]=${#convention_files[@]}
)

format_ms() {
  printf '%d.%ds' $(($1 / 1000)) $((($1 % 1000) / 100))
}

now_ms() {
  local now=${EPOCHREALTIME/./}
  echo $((now / 1000))
}

# One fixed status row redrawn in place on a terminal; piped output only gets the final table
interactive=0
use_color=0
if [[ -t 1 ]]; then
  interactive=1
  if [[ -z ${NO_COLOR:-} ]]; then
    use_color=1
  fi
fi

check_total=3
if ((${#yaml_files[@]})); then
  check_total=$((check_total + 1))
fi
if ((${#cpp_files[@]})); then
  check_total=$((check_total + 1))
fi
if ((${#python_files[@]})); then
  check_total=$((check_total + 3))
fi

table_lines=0
table_start=$(now_ms)
table_end=""
warn_steps=0
fail_steps=0
current_name="Starting"
current_group="-"
current_files="-"
current_result="Running"

paint() {
  if ((use_color)) && [[ -n $2 ]]; then
    printf '\033[%sm%s\033[0m' "$2" "$1"
  else
    printf '%s' "$1"
  fi
}

table_widths=(7 22 11 5 7 5 5 8)

table_border() {
  local out=$1 i cells
  for i in "${!table_widths[@]}"; do
    printf -v cells '%*s' $((table_widths[i] + 2)) ''
    out+=${cells// /─}
    if ((i < ${#table_widths[@]} - 1)); then
      out+=$2
    fi
  done
  paint "$out$3" 90
}

# Arguments are text/color pairs, one per column
table_row() {
  local out i=0 text
  out=$(paint "│" 90)
  while (($#)); do
    printf -v text ' %-*.*s ' "${table_widths[i]}" "${table_widths[i]}" "$1"
    out+=$(paint "$text" "$2")$(paint "│" 90)
    shift 2
    i=$((i + 1))
  done
  printf '%s' "$out"
}

draw_table() {
  local final=${1:-}
  if ((!interactive)) && [[ $final != final ]]; then
    return
  fi

  local elapsed
  if [[ -n $table_end ]]; then
    elapsed=$((table_end - table_start))
  else
    elapsed=$(($(now_ms) - table_start))
  fi
  local step_color=33 result_color=33
  case $current_result in
    Pass | Success) step_color=32 result_color=32 ;;
    Warning) step_color=33 result_color=33 ;;
    Err) step_color=31 result_color=31 ;;
  esac
  local step_text="$check_index/$check_total"
  if ((check_index == 0)); then
    step_text=Prep
  fi
  local warn_color=90 fail_color=90
  if ((warn_steps > 0)); then warn_color=33; fi
  if ((fail_steps > 0)); then fail_color=31; fi

  local lines=()
  lines+=("$(paint "Validating ESPHome Component" "1;36")")
  lines+=("$(table_border ┌ ┬ ┐)")
  lines+=("$(table_row Step 1\;36 Check 1\;36 Group 1\;36 Files 1\;36 Time 1\;36 Warn 1\;36 Err 1\;36 Result 1\;36)")
  lines+=("$(table_border ├ ┼ ┤)")
  lines+=("$(table_row "$step_text" "1" "$current_name" "$step_color" "$current_group" "" \
    "$current_files" "" "$(format_ms "$elapsed")" "" "$warn_steps" "$warn_color" \
    "$fail_steps" "$fail_color" "$current_result" "$result_color")")
  lines+=("$(table_border └ ┴ ┘)")

  if [[ $final == final ]]; then
    local verdict=SUCCESS verdict_color="1;32"
    if ((fail_steps > 0)); then
      verdict=ERROR
      verdict_color="1;31"
    fi
    lines+=("$(paint "$verdict" "$verdict_color")  $(paint "$warn_steps warnings" "$warn_color"), $(paint "$fail_steps errors" "$fail_color"), $check_total checks in $(format_ms "$elapsed")")
  fi

  if ((interactive)); then
    if ((table_lines > 0)); then
      printf '\033[%dA' "$table_lines"
    fi
    local line
    for line in "${lines[@]}"; do
      printf '\r%s\033[K\n' "$line"
    done
    table_lines=${#lines[@]}
  else
    printf '%s\n' "${lines[@]}"
  fi
}

snapshot_files() {
  python -c '
import hashlib
import os
import sys

for root in sys.argv[1:]:
    for directory, dirnames, filenames in os.walk(root):
        dirnames[:] = [name for name in dirnames if name not in {".esphome", ".git", "node_modules"}]
        for filename in filenames:
            path = os.path.join(directory, filename)
            with open(path, "rb") as source:
                digest = hashlib.sha256(source.read()).hexdigest()
            print(f"{path}\t{digest}")
' components test | sort
}

# Preparation runs under a "Prep" step so the table shows activity before the first check
current_group=Prepare
prepare_phase() {
  current_name=$1
  current_result=Running
  draw_table
}
prepare_failed() {
  current_result=Err
  fail_steps=$((fail_steps + 1))
  prepare_fail "$1"
}

prepare_phase "Install tools"
if ! run_logged "Install validation tools" \
  python -m pip install --disable-pip-version-check --cache-dir /root/.cache/pip \
  -r .devcontainer/requirements-validation.txt; then
  prepare_failed "Could not install the pinned validation tools."
fi

prepare_phase "Snapshot files"
files_before_fixes=$(snapshot_files)
if ((fix_mode)); then
  if ((${#cpp_files[@]})); then
    prepare_phase "Fix clang-format"
    if ! run_logged "Auto-fix: clang-format" clang-format -i "${cpp_files[@]}"; then
      prepare_failed "clang-format auto-fix failed."
    fi
  fi

  prepare_phase "Fix Ruff"
  if ! run_logged "Auto-fix: Ruff format" ruff format components; then
    prepare_failed "Ruff formatting failed."
  fi
  if ! run_logged "Auto-fix: Ruff lint" ruff check --fix components; then
    prepare_failed "Ruff lint fixes failed."
  fi

  if ((${#python_files[@]})); then
    prepare_phase "Fix pyupgrade"
    if ! run_logged "Auto-fix: pyupgrade" pyupgrade --py310-plus "${python_files[@]}"; then
      prepare_failed "pyupgrade failed."
    fi
  fi

  prepare_phase "Fix conventions"
  if ! run_logged "Auto-fix: component conventions" \
    python .devcontainer/check_component_conventions.py --fix; then
    prepare_failed "Component convention auto-fix failed."
  fi
fi

files_after_fixes=$(snapshot_files)
modified_files=$(comm -3 \
  <(printf '%s\n' "$files_before_fixes" | sort) \
  <(printf '%s\n' "$files_after_fixes" | sort) |
  sed 's/^\t//' | cut -f1 | sort -u | wc -l)

run_check() {
  group=$1
  name=$2
  file_count=$3
  shift
  shift
  shift

  check_index=$((check_index + 1))
  group_checks[$group]=$((group_checks[$group] + 1))
  log_file="$command_log"
  current_name=$name
  current_group=$group
  current_files=$file_count
  current_result=Running
  draw_table
  printf '\n===== %s =====\n' "$name" >> "$validation_log"
  "$@" > "$log_file" 2>&1 &
  check_pid=$!
  if ((interactive)); then
    while kill -0 "$check_pid" 2>/dev/null; do
      draw_table
      sleep 0.5
    done
  fi
  wait "$check_pid"
  status=$?
  cat "$log_file" >> "$validation_log"

  warning_pattern='\[warning\]|\bwarning\b|\[W[0-9]{4}|:[[:space:]]*W[0-9]{4}'
  warning_count=$(grep -Eic "$warning_pattern" "$log_file" || true)
  if ((warning_count > 0)); then
    group_warnings[$group]=$((group_warnings[$group] + 1))
    grep -Ei "$warning_pattern" "$log_file" |
      sed -nE 's#^([^:]+):[0-9]+(:[0-9]+)?:.*#\1#p' >> "$warning_files" || true
  fi

  if ((status == 0)); then
    if ((warning_count > 0)); then
      current_result=Warning
      warn_steps=$((warn_steps + 1))
    else
      current_result=Pass
    fi
  else
    current_result=Err
    fail_steps=$((fail_steps + 1))
    group_failures[$group]=$((group_failures[$group] + 1))
    validation_failed=1
  fi
  draw_table
}

if ((${#yaml_files[@]})); then
  run_check YAML yamllint "${#yaml_files[@]}" yamllint --strict "${yaml_files[@]}"
fi
if ((${#cpp_files[@]})); then
  run_check "C/C++" clang-format "${#cpp_files[@]}" clang-format --dry-run -Werror "${cpp_files[@]}"
fi
run_check Python "Ruff format" "${#python_files[@]}" ruff format --check components
run_check Python "Ruff lint" "${#python_files[@]}" ruff check components

if ((${#python_files[@]})); then
  run_check Python flake8 "${#python_files[@]}" flake8 "${python_files[@]}"
  run_check Python pylint "${#python_files[@]}" pylint -f parseable --persistent=n "${python_files[@]}"

  check_pyupgrade() {
    temp_dir=$(mktemp -d)
    result=0
    for file in "${python_files[@]}"; do
      mkdir -p "$temp_dir/$(dirname "$file")"
      cp -- "$file" "$temp_dir/$file"
      if ! pyupgrade --py310-plus "$temp_dir/$file"; then
        echo "$file: pyupgrade failed" >&2
        result=1
      elif ! cmp -s "$file" "$temp_dir/$file"; then
        echo "$file: pyupgrade changes are required" >&2
        result=1
      fi
    done
    rm -rf -- "$temp_dir"
    return "$result"
  }
  run_check Python pyupgrade "${#python_files[@]}" check_pyupgrade
fi

run_check Conventions "component conventions" "${#convention_files[@]}" \
  python .devcontainer/check_component_conventions.py

table_end=$(now_ms)
current_name=Finished
current_group="-"
current_files="-"
if ((fail_steps > 0)); then
  current_result=Err
else
  current_result=Success
fi
draw_table final
warning_file_count=$(sort -u "$warning_files" | sed '/^$/d' | wc -l)

printf '\nValidation summary\n'
for group in YAML "C/C++" Python Conventions; do
  if ((${group_checks[$group]} == 0)); then
    continue
  fi
  if ((${group_failures[$group]} > 0)); then
    result=ERR
  elif ((${group_warnings[$group]} > 0)); then
    result=WARN
  else
    result=PASS
  fi
  printf '  %-11s %s (%d files)\n' "$group" "$result" "${group_files[$group]}"
done
printf '  Files checked: %d unique; modified: %d; files with warnings: %d\n' \
  "$checked_file_count" "$modified_files" "$warning_file_count"
printf 'Log saved to %s\n' "$validation_log"

if ((validation_failed)); then
  if ((fix_mode)); then
    echo "Some findings cannot be automatically fixed; review the errors above." >&2
  else
    echo "One or more component validation checks failed." >&2
  fi
  exit 1
fi

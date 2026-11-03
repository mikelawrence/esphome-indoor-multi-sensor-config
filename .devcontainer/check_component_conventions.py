#!/usr/bin/env python3

import argparse
import os
import subprocess
import sys
from pathlib import Path

TEXT_EXTENSIONS = {
    ".c",
    ".cfg",
    ".conf",
    ".cpp",
    ".css",
    ".h",
    ".html",
    ".ini",
    ".js",
    ".json",
    ".md",
    ".py",
    ".ps1",
    ".proto",
    ".sh",
    ".tcc",
    ".toml",
    ".txt",
    ".yaml",
    ".yml",
}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--fix",
        action="store_true",
        help="Normalize line endings, tabs, trailing whitespace, and final newlines.",
    )
    args = parser.parse_args()

    result = subprocess.run(
        ["git", "ls-files", "-co", "--exclude-standard", "-z"],
        check=True,
        stdout=subprocess.PIPE,
    )
    errors: list[str] = []

    for raw_path in result.stdout.split(b"\0"):
        if not raw_path:
            continue

        path = Path(os.fsdecode(raw_path))
        if not path.parts or path.parts[0] not in {"components", "test"}:
            continue
        if path.suffix.lower() not in TEXT_EXTENSIONS and path.name not in {
            ".clang-format",
            ".clang-tidy",
            ".editorconfig",
            ".flake8",
            ".gitattributes",
            ".gitignore",
            ".yamllint",
            "LICENSE",
        }:
            continue
        if not path.is_file():
            continue

        try:
            content = path.read_bytes().decode("utf-8")
        except UnicodeDecodeError:
            errors.append(f"{path}: file is not valid UTF-8")
            continue

        fixed_lines = []
        for line_number, line in enumerate(content.splitlines(), start=1):
            if "\t" in line and not args.fix:
                errors.append(f"{path}:{line_number}: replace tabs with spaces")
            if line.rstrip(" \t") != line and not args.fix:
                errors.append(f"{path}:{line_number}: remove trailing whitespace")
            fixed_lines.append(line.replace("\t", "  ").rstrip(" \t"))

        fixed_content = "\n".join(fixed_lines)
        if content and not fixed_content.endswith("\n"):
            fixed_content += "\n"
        if args.fix:
            if fixed_content != content:
                path.write_text(fixed_content, encoding="utf-8", newline="\n")
            continue

        if "\r" in content:
            errors.append(f"{path}: use LF line endings")
        if content and not content.endswith("\n"):
            errors.append(f"{path}: add a final newline")

    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1

    print("Component conventions checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

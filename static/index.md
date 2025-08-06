# ESPHome Indoor Multi-Sensor

You need to make two choices before programming the ESPHome Indoor Multi-Sensor. 

First is the Sensor package. You can either choose Package A, the Sensirion SEN6X sensor package which is an all-in-one sensor package. Or you can choose Package B which is a lower cost discrete sensor set that is missing particulate matter sensors. 

Next up is what type of radar sensor you plan on including. There are 4 options here, Hi Link LD2410 (My favorite), DFRobot C4001 (SEN0609 and SEN0610), Hi-Link LD2450 Multi-Target Multi-Zone (MTMZ) and the Hi-Link LD2450 Single-Target Single-Zone (STSZ). 

Each of these these builds include all supported sensors: pressure, light, sound level, power/energy monitor and speaker. If there are sensors you wish to not include, take control of the sensor and start configuring.

If you are really new to ESPHome I would recommend searching on Youtube for getting started videos.

## Installation

Use the buttons below to install pre-built firmware directly to your device via USB.

| Sensor Pkg | Radar LD2410 | Radar C4001 | Radar LD2450-MTMZ | Radar LD2450-STSZ |
|---|---|---|---|---|
| Pkg A | <esp-web-install-button manifest="firmware/sensor-pkg-a-ld2410.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-a-c4001.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-a-ld2450-mtmz.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-a-ld2450-stsz.manifest.json"></esp-web-install-button> |
| Pkg B | <esp-web-install-button manifest="firmware/sensor-pkg-b-ld2410.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-b-c4001.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-b-ld2450-mtmz.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-b-ld2450-stsz.manifest.json"></esp-web-install-button> |

<script type="module" src="https://unpkg.com/esp-web-tools@10/dist/web/install-button.js?module"></script> 

## Configuration

When you take control there are two sections you need to configure. In the ```substitutions:``` section you will find settings for many of the available sensors. Note: in yaml all substitutions are strings and should be in ```'single quotes'``` or  ```"double quotes"``` but the value may be interpreted as a float or a boolean value.

```yaml
substitutions:
  name: "sensor-pkg-a-c4001"
  friendly_name: "Indoor Multi-Sensor Pkg A Radar C4001"
  version_suffix: "-1"

  # Settings
  use_pir_in_presence: "true"
  # Status LED Configuration
  status_day_brightness: "0.5"
  status_night_brightness: "0.20"
  status_daytime_lux: "12.0"
  status_nighttime_lux: "7.0"
  # Temperature Configuration
  temperature_offset: "0.0"
  # Humidity Configuration
  humidity_offset: "0.0"
  # CO₂ Configuration
  co2_calibration_date: "Not Set"
  # CO Configuration
  co_temp_id: "temperature"
  co_offset: "0.0"
  co_sensitivity: "2.000e-9"
  co_manufacture_date: "Not Set"
  co_serial_number: "Not Set"
  # Automatically controlled Vent
  vent_ha_entity: fan.vent_id
  vent_use_humidity: "true"
  vent_use_co2: "true"
  vent_min_on_time: "15"
  vent_hum_on_trigger: "10.0"
  vent_hum_off_trigger: "2.5"
  vent_co2_on_trigger: "1100"
  vent_co2_off_trigger: "900"
  # Smoke Alarm Configuration
  alarm_use_co: "true"
  alarm_use_co2: "true"
  alarm_use_pm: "true"
```

The ```packages:``` section will allow you to disable sensors by commenting out it's included package. Note: do not comment out any Main Config Files.

```yaml
packages:
  # Main Config Files
  common: github://mikelawrence/esphome-indoor-multi-sensor-config/common/common.yaml@main
  sen6x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkga-sen6x.yaml@main
  radar: github://mikelawrence/esphome-indoor-multi-sensor-config/common/radar-c4001.yaml@main

  # ADDITIONAL SENSORS
  # Carbon Dioxide (CO) - Figaro TGS5141 sensor
  co: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-co.yaml@main
  # Energy Usage - INA2XX sensor to measure Voltage, Power and Energy Usage
  ina2xx: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-ina2xx.yaml@main
  # Light Level - TSL2591 sensor
  tsl2591: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-tsl2591.yaml@main
  # Barometric Pressure - BMP581 sensor
  bmp581: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-bmp581.yaml@main
  # Microphone - Adds Sound Level meter
  mic: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-microphone.yaml@main

  # FEATURES
  # SEN6X Pressure Compensation - Adds pressure compensation to SEN6X
  press-comp: github://mikelawrence/esphome-indoor-multi-sensor-config/common/feat-sen6x-press-comp.yaml@main
  # Automatic Vent - Use humidity and CO₂ to control a bathroom vent
  # auto-vent: github://mikelawrence/esphome-indoor-multi-sensor-config/common/feat-auto-vent.yaml@main
  # Smoke Alarm - Use PM and CO₂ for smoke alarm functionality
  # smoke-alarm: github://mikelawrence/esphome-indoor-multi-sensor-config/common/feat-smoke-alarm.yaml@main
```
### Settings

```yaml
substitutions:
  version_suffix: "-1"
  # Settings
  use_pir_in_presence: "true"
  # Status LED Configuration
  status_day_brightness: "0.5"
  status_night_brightness: "0.20"
  status_daytime_lux: "12.0"
  status_nighttime_lux: "7.0"
  # Temperature Configuration
  temperature_offset: "0.0"
  # Humidity Configuration
  humidity_offset: "0.0"
  # CO₂ Configuration
  co2_calibration_date: "Not Set"
```

These are base settings available for any configuration.

+ **version_suffix** (string): The project version by default is the current release version from Github. You can tack additional version info to the end of the release with this substitution. 
  i.e. version_suffix set to "-A" will result in a project version like this 2025.07.1-A.
+ **use_pir_in_presence** (bool): You can disable the PIR motion detection from the presence sensor.
+ **status_day_brightness** (float): How bright is the Status LED during the day. Range is 0 to 1.0 where 1.0 means 100% brightness.
+ **status_night_brightness** (float): How bright is the Status LED during at night. Range is 0 to 1.0 where 1.0 means 100% brightness.
+ **status_daytime_lux** (float): The light level (lux) at which the Status LED will switch to daytime mode.
+ **status_nighttime_lux** (float): The light level (lux) at which the Status LED will switch to nighttime mode.
+ **temperature_offset** (float): The temperature sensor may have an offset due to environmental conditions. Use this to subtract out this error.
+ **humidity_offset** (float): The humidity sensor may have also have an offset. Use this to subtract out this error.
+ **co2_calibration_date** (string): Enter the last time the CO₂ was calibrated here and it will be reported as a text_sensor in the diagnostic section.

### Carbon Monoxide(CO) Configuration

```yaml
packages:
  # Carbon Dioxide (CO) - Figaro TGS5141 sensor
  co: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-co.yaml@main
```

If you have included this package the CO sensor is enabled and there are substitutions you need to edit.

```yaml
substitutions:
  # CO Configuration
  co_temp_id: "temperature"
  co_offset: "0.0"
  co_sensitivity: "2.000e-9"
  co_manufacture_date: "Unknown"
  co_serial_number: "111111111111111111"
```

+ **co_temp_id** (ID): The accuracy of the CO sensor is improved with temperature compensation. This is the entity id of the temperature sensor to use.
+ **co_offset** (float): The CO sensor and circuit will have a offset. Use this to subtract out this error.
+ **co_sensitivity** (float): The CO has a default sensitivity of 2.000e-9 Amps/ppm. This should be the factory measured sensitivity as reported in the QR code on the sensor.
+ **co_manufacture_date** (float): From the QR code on the sensor. The sensor has a 10 year life expectancy. Reported as a ```text_sensor``` in the diagnostic section.
+ **co_serial_number** (float): From the QR code on the sensor. Not necessary but might come in handy down the road. Reported as a ```text_sensor``` in the diagnostic section.

### Energy Usage Configuration

```yaml
packages:
  # Energy Usage - INA2XX sensor to measure Voltage, Power and Energy Usage
  ina2xx: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-ina2xx.yaml@main
```

If you have included this package the Energy Usage Sensor is enabled. Voltage, Power and Energy Usage will be reported as sensors. There are no substitutions to edit.

### Light Sensor Configuration

```yaml
packages:
  # Light Level - TSL2591 sensor
  tsl2591: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-tsl2591.yaml@main
```

If you have included this package the TSL2591 Light Level Sensor is enabled. Light Level in lux will be reported as a sensor. There are no substitutions to edit.

### Barometric Pressure Sensor Configuration

```yaml
packages:
  # Barometric Pressure - BMP581 sensor
  bmp581: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-bmp581.yaml@main
```

If you have included this package the BMP581 Barometric Pressure Sensor is enabled. The sensor reports absolute pressure. There are no substitutions to edit.

### Microphone Configuration

```yaml
packages:
  # Microphone - Adds Sound Level meter
  mic: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-microphone.yaml@main
```

If you have included this package the ICS-43434 MEMS microphone is enabled. The microphone measures sound levels and reports to levels a one minute average and one minute peak. There are no substitutions to edit.

### Automatically controlled Vent Configuration

```yaml
packages:
  # Automatic Vent - Use humidity and CO₂ to control a bathroom vent
  auto-vent: github://mikelawrence/esphome-indoor-multi-sensor-config/common/feat-auto-vent.yaml@main
```

If you have included this package the Automatic Vent control is enabled and there are substitutions you need to edit.

```yaml
substitutions:
  # Automatically controlled Vent
  vent_ha_entity: fan.vent_id
  vent_use_humidity: "true"
  vent_use_co2: "true"
  vent_min_on_time: "15"
  vent_hum_on_trigger: "10.0"
  vent_hum_off_trigger: "2.5"
  vent_co2_on_trigger: "1100"
  vent_co2_off_trigger: "900"
```

+ **vent_ha_entity** (ID): This is the Home Assistant entity id of automatically controlled vent.
+ **vent_use_humidity** (bool): Enable humidity based control of the vent by setting this to ```true```.
+ **vent_use_co2** (bool): Enable CO₂ based control of the vent by setting this to ```true```.
+ **vent_min_on_time** (integer): This is the minimum on time for a vent for manual mode and how long the vent will stay on after the humidity or CO₂ returns to normal.
+ **vent_hum_on_trigger** (integer): This is the humidity level (%) rise from baseline that will turn on the vent. Baseline here is a fast exponential average (15 minutes). Showers usually have a sharp rise in humidity when first starting so a value of 10% rise in a few minutes is definitely a shower starting.
+ **vent_hum_off_trigger** (integer): This is the humidity level (%) from baseline that will turn off the vent. Baseline here is a slow exponential average (6ish hours). You want this number slightly above zero because sometimes the humidity level doesn't go back to where it was before a shower occurred quick enough. And even though the baseline average will eventually get there and cut off the vent it will have been on for hours.
+ **vent_co2_on_trigger** (integer): This is the CO₂ level that will cause the vent to turn on. Make 100-200 higher than ```vent_co2_off_trigger``` to give the vent a bit of hysteresis.
+ **vent_co2_off_trigger** (integer): This is the CO₂ level that will cause the vent to turn off.

### Smoke Alarm Configuration

```yaml
packages:
  # Smoke Alarm - Use PM and CO₂ for smoke alarm functionality
  smoke-alarm: github://mikelawrence/esphome-indoor-multi-sensor-config/common/feat-smoke-alarm.yaml@main
```

If you have included this package the you can use multiple sensors to approximate a smoke detector. This is not a certified smoke detector and my not work at all. You have been warned!

```yaml
substitutions:
  # Smoke Alarm Configuration
  alarm_use_co: "true"
  alarm_use_co2: "true"
  alarm_use_pm: "true"
```

+ **alarm_use_co** (bool): Enable CO alarm functionality for the smoke detector but setting this to ```true```.
+ **alarm_use_co2** (bool): Enable CO₂  alarm functionality for the smoke detector but setting this to ```true```.
+ **alarm_use_pm** (bool): Enable Particulate Matter (PM) alarm functionality for the smoke detector but setting this to ```true```.

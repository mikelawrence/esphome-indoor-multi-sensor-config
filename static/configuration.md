---
layout: default
title: ESPHome Indoor Multi-Sensor
description: Configuration in ESPHome after taking control
---

# Configuration

Once you take control in ESPHome, there are two sections you need to configure, ```substitutions:``` and ```packages:```. In the ```substitutions:``` section you will find settings for many of the available sensors.
You only need to declare substitutions if you need a value other than default.

> With yaml all substitutions are strings and should be in ```'single quotes'``` or  
> ```"double quotes"``` even if the value is a float or a boolean value.

```yaml
substitutions:
  name: "sensor-pkg-a-c4001"
  friendly_name: "Indoor Multi-Sensor Pkg A Radar C4001"
  version_suffix: "-1"

  # Settings
  room_sound_id: "xxx_sound"
  # Status LED Configuration
  status_nightlight_brightness: "1.0"
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
  # Home Assistant Entities
  # Presence entity
  presence_ha_entity: "binary_sensor.unknown_room_occupancy"

  # git ref, leave at main unless you know what you are doing
  ref: "main"
```

The ```packages:``` section will allow you to disable sensors by commenting out it's included package.

```yaml
packages:
  # Main Config Files for Sensor Package-A and C4001 Radar
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
  # SCD4X Pressure Compensation - Adds pressure compensation to SCD4X
  # press-comp: github://mikelawrence/esphome-indoor-multi-sensor-config/common/feat-scd4x-press-comp.yaml@main
  # Automatic Vent - Use humidity and CO₂ to control a bathroom vent
  # auto-vent: github://mikelawrence/esphome-indoor-multi-sensor-config/common/feat-auto-vent.yaml@main
  # Smoke Alarm - Use PM and CO₂ for smoke alarm functionality
  # smoke-alarm: github://mikelawrence/esphome-indoor-multi-sensor-config/common/feat-smoke-alarm.yaml@main
```

The Main Config Files vary based on Sensor Package and Radar. Only these combinations of Main Config Files will work.

```yaml
  # Main Config Files for Sensor Package-A and C4001 Radar
  common: github://mikelawrence/esphome-indoor-multi-sensor-config/common/common.yaml@main
  sen6x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkga-sen6x.yaml@main
  radar: github://mikelawrence/esphome-indoor-multi-sensor-config/common/radar-c4001.yaml@main

  # Main Config Files for Sensor Package-A and LD2410 Radar
  common: github://mikelawrence/esphome-indoor-multi-sensor-config/common/common.yaml@main
  sen6x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkga-sen6x.yaml@main
  radar: github://mikelawrence/esphome-indoor-multi-sensor-config/common/radar-ld2410.yaml@main

  # Main Config Files for Sensor Package-A and LD2450 MTMZ Radar
  common: github://mikelawrence/esphome-indoor-multi-sensor-config/common/common.yaml@main
  sen6x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkga-sen6x.yaml@main
  radar: github://mikelawrence/esphome-indoor-multi-sensor-config/common/radar-ld2450ml-mtmz.yaml@main

  # Main Config Files for Sensor Package-A and LD2450 STSZ Radar
  common: github://mikelawrence/esphome-indoor-multi-sensor-config/common/common.yaml@main
  sen6x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkga-sen6x.yaml@main
  radar: github://mikelawrence/esphome-indoor-multi-sensor-config/common/radar-ld2450ml-stsz.yaml@main

  # Main Config Files for Sensor Package-B and C4001 Radar
  common: github://mikelawrence/esphome-indoor-multi-sensor-config/common/common.yaml@main
  sht4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-sht4x.yaml@main
  scd4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-scd4x.yaml@main
  sgp4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-sgp4x.yaml@main
  radar: github://mikelawrence/esphome-indoor-multi-sensor-config/common/radar-c4001.yaml@main

  # Main Config Files for Sensor Package-B and LD2410 Radar
  common: github://mikelawrence/esphome-indoor-multi-sensor-config/common/common.yaml@main
  sht4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-sht4x.yaml@main
  scd4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-scd4x.yaml@main
  sgp4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-sgp4x.yaml@main
  radar: github://mikelawrence/esphome-indoor-multi-sensor-config/common/radar-ld2410.yaml@main

  # Main Config Files for Sensor Package-B and LD2450 MTMZ Radar
  common: github://mikelawrence/esphome-indoor-multi-sensor-config/common/common.yaml@main
  sht4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-sht4x.yaml@main
  scd4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-scd4x.yaml@main
  sgp4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-sgp4x.yaml@main
  radar: github://mikelawrence/esphome-indoor-multi-sensor-config/common/radar-ld2450ml-mtmz.yaml@main

  # Main Config Files for Sensor Package-B and LD2450 STSZ Radar
  common: github://mikelawrence/esphome-indoor-multi-sensor-config/common/common.yaml@main
  sht4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-sht4x.yaml@main
  scd4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-scd4x.yaml@main
  sgp4x: github://mikelawrence/esphome-indoor-multi-sensor-config/common/pkgb-sgp4x.yaml@main
  radar: github://mikelawrence/esphome-indoor-multi-sensor-config/common/radar-ld2450ml-stsz.yaml@main
```

The additional Sensors and Features packages can mostly be included or not based on whether or not the sensors are populated on the board.

As an example, if you enable SCD4X pressure compensation but don't have a SCD4X sensor installed it's not going to work.

# Settings

```yaml
substitutions:
  name: "office-sensor"
  friendly_name: "Office Sensor"
  version_suffix: "-A"

  # Settings
  room_sound_id: "office_sound"
  # Status LED Configuration
  status_nightlight_brightness: "1.0"
  status_day_brightness: "0.5"
  status_night_brightness: "0.20"
  status_daytime_lux: "12.0"
  status_nighttime_lux: "7.0"
  presence_ha_entity: "binary_sensor.unknown_room_occupancy"
  # Temperature Configuration
  temperature_offset: "0.0"
  # Humidity Configuration
  humidity_offset: "0.0"
  # CO₂ Configuration
  co2_calibration_date: "Not Set"
```

These are base settings available for any configuration.

+ **name** (string): The standard ESPHome hostname. Alphanumeric and dash only. There is no default.
+ **friendly_name** (string): The standard ESPHome friendly name. There is no default.
+ **room_sound_id** (string): When making announcements the room name is often added. Use this to select the sound file.
  Look in the [common.yaml](common/common.yaml) file in the `media_player:` section for a list of available sound files. There is no default.
+ **status_nightlight_brightness** (float): This is the brightness level of the nightlight when enabled. Range is 0 to 1.0 where 1.0 means 100% brightness. Default is "1.0".
+ **status_night_brightness** (float): How bright is the Status LED during at night. Range is 0 to 1.0 where 1.0 means 100% brightness. Default is "0.15".
+ **status_daytime_lux** (float): The light level (lux) at which the Status LED will switch to daytime mode. Default is "10.0".
+ **status_nighttime_lux** (float): The light level (lux) at which the Status LED will switch to nighttime mode. Default is "3.0".
+ **presence_ha_entity** (ID): This is the Home Assistant entity id of a presence sensor. This presence sensor is or'ed with the internal presence state.
  This basically allows Home Assistant to control the Presence Status LED on the sensor. Useful when there are other presence sensors and timeouts. There is no default.
+ **temperature_offset** (float): The temperature sensor may have an offset due to environmental conditions. Use this to subtract out this error. Default is "0.0".
+ **humidity_offset** (float): The humidity sensor may have also have an offset. Use this to subtract out this error. Default is "0.0".
+ **co2_calibration_date** (string): Enter the last time the CO₂ was calibrated here and it will be reported as a text_sensor in the diagnostic section. Default is "Not Set".

# Carbon Monoxide(CO) Configuration

```yaml
packages:
  # Carbon Dioxide (CO) - Figaro TGS5141 sensor
  co: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-co.yaml@main
```

If you have included this package the CO sensor is enabled and there are substitutions you need to edit.

```yaml
substitutions:
  # CO Configuration
  co_offset: "0.0"
  co_sensitivity: "2.000e-9"
  co_manufacture_date: "12/22/2022"
  co_serial_number: "221111554259031129"
```

+ **co_offset** (float): The CO sensor and circuit will have a offset. Use this to subtract out this error. Default is "0.0".
+ **co_sensitivity** (float): This should be the factory measured sensitivity as reported in the QR code on the sensor in Amps/ppm. Default is "2.000e-9".
+ **co_manufacture_date** (float): From the QR code on the sensor. The sensor has a 10 year life expectancy. Reported as a ```text_sensor``` in the diagnostic section. Default is "Not Set".
+ **co_serial_number** (float): From the QR code on the sensor. Not necessary but might come in handy down the road. Reported as a ```text_sensor``` in the diagnostic section. Default is "Not Set".

# Energy Usage Configuration

```yaml
packages:
  # Energy Usage - INA2XX sensor to measure Voltage, Power and Energy Usage
  ina2xx: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-ina2xx.yaml@main
```

If you have included this package the Energy Usage Sensor is enabled. Voltage, Power and Energy Usage will be reported as sensors. There are no substitutions to edit.

# Light Sensor Configuration

```yaml
packages:
  # Light Level - TSL2591 sensor
  tsl2591: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-tsl2591.yaml@main
```

If you have included this package the TSL2591 Light Level Sensor is enabled. Light Level in lux will be reported as a sensor. There are no substitutions to edit.

# Barometric Pressure Sensor Configuration

```yaml
packages:
  # Barometric Pressure - BMP581 sensor
  bmp581: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-bmp581.yaml@main
```

If you have included this package the BMP581 Barometric Pressure Sensor is enabled. The sensor reports absolute pressure. There are no substitutions to edit.

# Microphone Configuration

```yaml
packages:
  # Microphone - Adds Sound Level meter
  mic: github://mikelawrence/esphome-indoor-multi-sensor-config/common/add-microphone.yaml@main
```

If you have included this package the ICS-43434 MEMS microphone is enabled. The microphone measures sound levels and reports to levels a one minute average and one minute peak. There are no substitutions to edit.

# Automatically controlled Vent Configuration

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
  vent_use_co2: "false"
  vent_min_on_time: "15"
  vent_hum_on_trigger: "10.0"
  vent_hum_off_trigger: "2.5"
  vent_co2_on_trigger: "1500"
  vent_co2_off_trigger: "1400"
```

+ **vent_ha_entity** (ID): This is the Home Assistant entity id of automatically controlled vent. There is no default.
+ **vent_use_humidity** (bool): Enable humidity based control of the vent by setting this to ```true```. Default is "true".
+ **vent_use_co2** (bool): Enable CO₂ based control of the vent by setting this to ```true```. Default is "false"
+ **vent_min_on_time** (integer): This is the minimum on time for a vent for manual mode and how long the vent will stay on after the humidity or CO₂ returns to normal. Default is "15".
+ **vent_hum_on_trigger** (integer): This is the humidity level (%) rise from baseline that will turn on the vent. Baseline here is a fast exponential average (15 minutes). Showers usually have a sharp rise in humidity when first starting so a value of 10% rise in a few minutes is definitely a shower starting. Default is "10.0".
+ **vent_hum_off_trigger** (integer): This is the humidity level (%) from baseline that will turn off the vent. Baseline here is a slow exponential average (6ish hours). You want this number slightly above zero because sometimes the humidity level doesn't go back to where it was before a shower occurred quick enough. And even though the baseline average will eventually get there and cut off the vent it will have been on for hours. Default is "2.5".
+ **vent_co2_on_trigger** (integer): This is the CO₂ level that will cause the vent to turn on. Make 100-200 higher than ```vent_co2_off_trigger``` to give the vent a bit of hysteresis. Default is "1500".
+ **vent_co2_off_trigger** (integer): This is the CO₂ level that will cause the vent to turn off. Default is "1400".

# Smoke Alarm Configuration

```yaml
packages:
  # Smoke Alarm - Use PM, CO and CO₂ for smoke alarm functionality
  smoke-alarm: github://mikelawrence/esphome-indoor-multi-sensor-config/common/feat-smoke-alarm.yaml@main
```

If you have included this package the you can use multiple sensors to approximate a smoke detector. This is not a certified smoke detector and my not work at all. You have been warned!

[back](./)

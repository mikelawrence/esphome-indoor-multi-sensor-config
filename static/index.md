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
  co2_calibration_date: "Unknown"
  # CO Configuration
  co_temp_id: "temperature"
  co_offset: "0.0"
  co_sensitivity: "2.000e-9"
  co_manufacture_date: "Unknown"
  co_serial_number: "111111111111111111"
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

The ```packages:``` section will allow you to disable sensors by commenting out it's included package. Note: do not comment out any Main Config Files.

```yaml
packages:
  remote_package_files:
    url: https://github.com/mikelawrence/esphome-indoor-multi-sensor-config
    refresh: 1h
    files:
      # Main Config Files
      - common/common.yaml
      - common/pkga-sen6x.yaml
      - common/radar-c4001.yaml

      # ADDITIONAL SENSORS
      # Carbon Dioxide (CO) - Figaro TGS5141 sensor
      - common/add-co.yaml
      # Energy Usage - INA2XX sensor to measure Voltage, Power and Energy Usage
      - common/add-ina2xx.yaml
      # Light Level - TSL2591 sensor
      - common/add-tsl2591.yaml
      # Barometric Pressure - BMP581 sensor
      - common/add-bmp581.yaml
      # Microphone - Adds Sound Level meter
      - common/add-microphone.yaml

      # FEATURES
      # SEN6X Pressure Compensation - Adds pressure compensation to SEN6X
      - common/feat-sen6x-press-comp.yaml
      # Automatic Vent - Use humidity and CO₂ control a bathroom vent
      - common/feat-auto-vent.yaml
```
### Settings

```yaml
  # Settings
  use_pir_in_presence: "true"
  # Status LED Configuration
  status_day_brightness: "0.5"
  status_night_brightness: "0.20"
  status_daytime_lux: "12.0"
  status_nighttime_lux: "7.0"
```

These are base sensor settings available for any configuration.

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
      # Carbon Dioxide (CO) - Figaro TGS5141 sensor
      - common/add-co.yaml
```

If you have included this package the CO sensor is enabled and there are substitutions you need to edit.

```yaml
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

### Automatically controlled Vent Configuration

```yaml
      # Automatic Vent - Use humidity and CO₂ control a bathroom vent
      - common/feat-auto-vent.yaml
```

If you have included this package the CO sensor is enabled and there are substitutions you need to edit.

```yaml
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

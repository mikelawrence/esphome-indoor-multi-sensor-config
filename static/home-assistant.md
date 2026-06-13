---
layout: default
title: ESPHome Indoor Multi-Sensor
description: Using the ESPHome Indoor Multi-Sensor with Home Assistant
---

# Home Assistant

There are numerous entities presented to Home Assistant here is a complete list of each with a description.

## Controls

+ **Announcement Volume** (*Number*): The default volume for announcements over the speaker. The range is 0 - 100 with 100 as the maximum. Announcements change the volume to this value during an announcement. The previous volume will be restored once the announcement is complete.

+ **Enable Announcements** (*Switch*): When on Announcements are enabled. 

+ **Enable Auto Vent** (*Switch*): When on the Automatic Vent based on humidity and CO2 levels will be enabled. 

+ **Enable LED** (*Switch*): When on the Status LED will be enabled.

+ **Enable Nightlight** (*Switch*): When on the Status LED will act as a nightlight. The nightlight is controlled by light levels and automatically comes on when the room is dark.

+ **Enable PIR** (*Switch*): When on the PIR sensor will be enabled. The PIR sensor is included in presence detection when enabled.

+ **Media Player** (*Media Player*): Can be used to play any media from Home Assistant.

+ **Silience Alarms** (*Button*): When pressed will silence alarms for 3 hours or until the sensor is restarted.

+ **Status Light** (*Switch*): When set to on the Status Light will be forced on. This only applies to presence status. Include this switch in a group and it will turn on the Presense status LED when the group is on. Handy when other sensors are involved in room presense.

## Sensors

+ **Analog Current** (*Sensor*): This measures the current (A) the analog section is using. Updates every minute.

+ **Analog Power** (*Sensor*): This measures the current (A) the analog section is using. Updates every minute.

+ **Analog Voltage** (*Sensor*): This measures the current (A) the analog section is using. Updates every minute.

+ **CO** (*Sensor*): Current Carbon Monoxide reading. Updates every minute.

+ **CO₂** (*Sensor*): Current Carbon Dioxide reading. Updates every minute.

+ **Digital Current** (*Sensor*): This measures the current (A) the digital section is using. Updates every minute.

+ **Digital Power** (*Sensor*): This measures the current (A) the digital section is using. Updates every minute.

+ **Digital Voltage** (*Sensor*): This measures the current (A) the digital section is using. Updates every minute.

+ **Humidity** (*Sensor*): Current Humidity sensor reading. For Sensor-Pkg-A configs the SEN66 sensor provides this reading. For Sensor-Pkg-B configs it is the SHT45 sensor. Updates every minute.

+ **Lux** (*Sensor*): Current lux reading from the TSL2591 sensor. Updates every minute.

+ **Moving Target Count** (*Sensor*): The number of moving target detected (up to 3 targets). Only available in the LD2450 Radar config. Updates at Update Rate.

+ **NOx** (*Sensor*): Current Nitrous-Oxide reading. For Sensor-Pkg-A configs the SEN66 sensor provides this reading. For Sensor-Pkg-B configs it is the SGP41 sensor. Updates every minute.

+ **PIR Motion** (*Sensor*): Current PIR motion state. This sensor will show as unavailable when Enable PIR is turned off. Updates every minute.

+ **PM <1µm Mass concentration** (*Sensor*): Current Particulate Matter <1µm Mass concentration. Only available with Sensor-Pkg-A. Updates every minute.

+ **PM <2.5µm Mass concentration** (*Sensor*): Current Particulate Matter <2.5µm Mass concentration. Only available with Sensor-Pkg-A. Updates every minute.

+ **PM <4µm Mass concentration** (*Sensor*): Current Particulate Matter <4µm Mass concentration. Only available with Sensor-Pkg-A. Updates every minute.

+ **PM <10µm Mass concentration** (*Sensor*): Current Particulate Matter <10µm Mass concentration. Only available with Sensor-Pkg-A. Updates every minute.

+ **Presence** (*Binary Sensor*): Includes both Presence mmWave from LD2450 and PIR Motion if enabled. For the LD2450 config updates at LD2450 Timeout rate.

+ **Presence mmWave** (*Binary Sensor*): This is presence from from installed radar. For the LD2450 config updates at LD2450 Timeout rate.

+ **Pressure** (*Sensor*): This is most recent absolute pressure from from BMP581. Updates every minute.

+ **Sound Level Peak** (*Sensor*): This is the most recent Sound Level Peak as measured from microphone. Updates every minute.

+ **Sound Level RMS** (*Sensor*): This is the most recent Sound Level RMS (average) over the last minute as measured from microphone. Updates every minute.

+ **Still Target Count** (*Sensor*): The current number of still targets in the LD2450 field of view. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target Count** (*Sensor*): The current number of targets in the LD2450 field of view. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target-1 Speed** (*Sensor*): Target-1 speed if there is at least one target in the field of view, unknown otherwise. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target-1 X** (*Sensor*): Target-1 x position if there is at least one target in the field of view, unknown otherwise. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target-1 Y** (*Sensor*): Target-1 y position if there is at least one target in the field of view, unknown otherwise. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target-2 Speed** (*Sensor*): Target-2 speed if there is at least two targets in the field of view, unknown otherwise. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target-2 X** (*Sensor*): Target-2 x position if there is at least two targets in the field of view, unknown otherwise. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target-2 Y** (*Sensor*): Target-2 y position if there is at least two targets in the field of view, unknown otherwise. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target-3 Speed** (*Sensor*): Target-3 speed if there is at least three targets in the field of view, unknown otherwise. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target-3 X** (*Sensor*): Target-3 x position if there is at least three targets in the field of view, unknown otherwise. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Target-3 Y** (*Sensor*): Target-3 y position if there is at least three targets in the field of view, unknown otherwise. Only available with the LD2450 config. Updates at LD2450 Timeout rate.

+ **Temperature** (*Sensor*): Current Temperature sensor reading. For Sensor-Pkg-A configs the SEN66 sensor provides this reading. For Sensor-Pkg-B configs it is the SHT45 sensor. Updates every minute.

+ **USB-C Current** (*Sensor*): This measures the current (A) the USB-C section is using. Updates every minute.

+ **USB-C Energy** (*Sensor*): This measures the accumulated energy (W Hr) the USB-C section is using. Updates every minute.

+ **USB-C Power** (*Sensor*): This measures the current (A) the USB-C section is using. Updates every minute.

+ **USB-C Voltage** (*Sensor*): This measures the current (A) the USB-C section is using. Updates every minute.

+ **Vent Auto CO₂** (*Binary Sensor*): When true Auto Vent has turned on the vent because CO₂ is too high. If Enable Auto Vent is off this sensor is unknown.

+ **Vent Auto Hum** (*Binary Sensor*): When true Auto Vent has turned on the vent because Humidity is too high. If Enable Auto Vent is off this sensor is unknown.

+ **Vent Manual** (*Binary Sensor*): When true Auto Vent has detected the vent was turned on manually. If Enable Auto Vent is off this sensor is unknown.

+ **VOC** (*Sensor*): Current Volatile Organic Compound reading. For Sensor-Pkg-A configs the SEN66 sensor provides this reading. For Sensor-Pkg-B configs it is the SGP41 sensor. Updates every minute.

# Lovelace Configurations

Over time I found helpful lovelace configurations on the Internet. I really
need to do some research to give credit to the appropriate people.

# LD2410 Lovelace

The LD2410 allows you to set the sensitivity for both moving and still targets at different range bins.
While this is a flexible arrangement that allows you to tune the sensor to your space it is hard to visualize.
This Lovelace configuration makes it easier to visualize and set the range bin values to fit your environment.

![LD2410 Lovelace](ld2410-lovelace.png){: .align-center}

Here is the [yaml](https://github.com/mikelawrence/esphome-indoor-multi-sensor-config/blob/main/lovelace/indoor-multi-sensor-ld2410-section.yml) for this Lovelace configuration.

# LD2450 Lovelace

The LD2450 allows you to set zones based on x and y coordinates. It can detect up to three targets and
you can configure up to three zones. This is even more difficult to visualize but luckily I have a Lovelace
config for this sensor too.

![LD2450 Lovelace](ld2450-lovelace.png){: .align-center}

Here is the [yaml](https://github.com/mikelawrence/esphome-indoor-multi-sensor-config/blob/main/lovelace/indoor-multi-sensor-ld2450-section.yml) for this Lovelace configuration.

[back](./)

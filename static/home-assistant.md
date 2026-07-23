---
layout: default
title: ESPHome Indoor Multi-Sensor
description: Using the ESPHome Indoor Multi-Sensor with Home Assistant
---

# Home Assistant

There are numerous entities presented to Home Assistant here is a complete list of each with a description.

## Controls

- **Announcement Volume** (*Number*): The default volume for announcements over the speaker. The range is 0 - 100 with 100 as the maximum. Announcements change the volume to this value during an announcement. The previous volume will be restored once the announcement is complete.

- **Enable Announcements** (*Switch*): When on Announcements are enabled.

- **Enable LED** (*Switch*): When on the Status LED will be enabled.

- **Enable Nightlight** (*Switch*): When on the Status LED will act as a nightlight. The nightlight is controlled by light levels and automatically comes on when the room is dark.

- **Media Player** (*Media Player*): Can be used to play any media from Home Assistant.

- **Silence Alarms** (*Button*): When pressed will silence alarms for 3 hours or until the sensor is restarted.

- **Status Light** (*Switch*): When set to on the Status Light will be forced on. This only applies to presence status. Include this switch in a group and it will turn on the Presence status LED when the group is on. Handy when other sensors are involved in room presense.

## Sensors

- **Analog Current** (*Sensor*): This measures the current (A) the analog section is using. Updates every minute.

- **Analog Power** (*Sensor*): This measures the current (A) the analog section is using. Updates every minute.

- **Analog Voltage** (*Sensor*): This measures the current (A) the analog section is using. Updates every minute.

- **CO** (*Sensor*): Current Carbon Monoxide reading. Updates every minute.

- **CO₂** (*Sensor*): Current Carbon Dioxide reading. Updates every minute.

- **Digital Current** (*Sensor*): This measures the current (A) the digital section is using. Updates every minute.

- **Digital Power** (*Sensor*): This measures the current (A) the digital section is using. Updates every minute.

- **Digital Voltage** (*Sensor*): This measures the current (A) the digital section is using. Updates every minute.

- **Humidity** (*Sensor*): Current Humidity sensor reading. For Sensor-Pkg-A configs the SEN66 sensor provides this reading. For Sensor-Pkg-B configs it is the SHT45 sensor. Updates every minute.

- **Lux** (*Sensor*): Current lux reading from the TSL2591 sensor. Updates every minute.

- **inhibit_time** (*Optional*): The dead-time after switching to the not present state before presence can be detected again. Default is 1 (seconds) with a range of 0.1 to 255.0. The ```Config Save``` button must be clicked to save the sensor configuration to flash and make operational. Only available with C4001 config.

- **Moving Target Count** (*Sensor*): The number of moving target detected (up to 3 targets). Only available in the LD2450 Radar config. Update Rate is equivalent to Timeout seconds.

- **NOx** (*Sensor*): Current Nitrous-Oxide reading. For Sensor-Pkg-A configs the SEN66 sensor provides this reading. For Sensor-Pkg-B configs it is the SGP41 sensor. Updates every minute.

- **PIR Motion** (*Sensor*): Current PIR motion state. This sensor will show as unavailable when Enable PIR is turned off. Updates every minute.

- **PM <1µm Mass concentration** (*Sensor*): Current Particulate Matter <1µm Mass concentration. Only available with Sensor-Pkg-A. Updates every minute.

- **PM <2.5µm Mass concentration** (*Sensor*): Current Particulate Matter <2.5µm Mass concentration. Only available with Sensor-Pkg-A. Updates every minute.

- **PM <4µm Mass concentration** (*Sensor*): Current Particulate Matter <4µm Mass concentration. Only available with Sensor-Pkg-A. Updates every minute.

- **PM <10µm Mass concentration** (*Sensor*): Current Particulate Matter <10µm Mass concentration. Only available with Sensor-Pkg-A. Updates every minute.

- **Presence mmWave** (*Binary Sensor*): This is presence from from installed radar. Clear presence will delay off for Timeout seconds.

- **Presence** (*Binary Sensor*): Includes both Presence mmWave from Radar and PIR Motion if enabled. Clear presence will delay off for Timeout seconds.

- **Pressure** (*Sensor*): This is most recent absolute pressure from from BMP581. Updates every minute.

- **Sound Level Peak** (*Sensor*): This is the most recent Sound Level Peak as measured from microphone. Updates every minute.

- **Sound Level RMS** (*Sensor*): This is the most recent Sound Level RMS (average) over the last minute as measured from microphone. Updates every minute.

- **Still Target Count** (*Sensor*): The current number of still targets in the LD2450 field of view. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target Count** (*Sensor*): The current number of targets in the LD2450 field of view. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target-1 Speed** (*Sensor*): Target-1 speed if there is at least one target in the field of view, unknown otherwise. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target-1 X** (*Sensor*): Target-1 x position if there is at least one target in the field of view, unknown otherwise. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target-1 Y** (*Sensor*): Target-1 y position if there is at least one target in the field of view, unknown otherwise. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target-2 Speed** (*Sensor*): Target-2 speed if there is at least two targets in the field of view, unknown otherwise. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target-2 X** (*Sensor*): Target-2 x position if there is at least two targets in the field of view, unknown otherwise. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target-2 Y** (*Sensor*): Target-2 y position if there is at least two targets in the field of view, unknown otherwise. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target-3 Speed** (*Sensor*): Target-3 speed if there is at least three targets in the field of view, unknown otherwise. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target-3 X** (*Sensor*): Target-3 x position if there is at least three targets in the field of view, unknown otherwise. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Target-3 Y** (*Sensor*): Target-3 y position if there is at least three targets in the field of view, unknown otherwise. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Temperature** (*Sensor*): Current Temperature sensor reading. For Sensor-Pkg-A configs the SEN66 sensor provides this reading. For Sensor-Pkg-B configs it is the SHT45 sensor. Updates every minute.

- **USB-C Current** (*Sensor*): This measures the current (A) the USB-C section is using. Updates every minute.

- **USB-C Energy** (*Sensor*): This measures the accumulated energy (W Hr) the USB-C section is using. Updates every minute.

- **USB-C Power** (*Sensor*): This measures the current (A) the USB-C section is using. Updates every minute.

- **USB-C Voltage** (*Sensor*): This measures the current (A) the USB-C section is using. Updates every minute.

- **Vent Auto CO₂** (*Binary Sensor*): When true Auto Vent has turned on the vent because CO₂ is too high. If Enable Auto Vent is off this sensor is unknown.

- **Vent Auto Hum** (*Binary Sensor*): When true Auto Vent has turned on the vent because Humidity is too high. If Enable Auto Vent is off this sensor is unknown.

- **Vent Manual** (*Binary Sensor*): When true Auto Vent has detected the vent was turned on manually. If Enable Auto Vent is off this sensor is unknown.

- **VOC** (*Sensor*): Current Volatile Organic Compound reading. For Sensor-Pkg-A configs the SEN66 sensor provides this reading. For Sensor-Pkg-B configs it is the SGP41 sensor. Updates every minute.

- **Zone-1 Moving Target Count** (*Sensor*): The current number of targets in Zone-1. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-1 Presence** (*Binary Sensor*): Current Zone-1 presence. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-1 Still Target Count** (*Sensor*): The current number of still targets in Zone-1. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-1 Target Count** (*Sensor*): The total number of targets in Zone-1. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-2 Moving Target Count** (*Sensor*): The current number of targets in Zone-2. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-2 Presence** (*Binary Sensor*): Current Zone-2 presence. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-2 Still Target Count** (*Sensor*): The current number of still targets in Zone-2. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-2 Target Count** (*Sensor*): The total number of targets in Zone-2. Only available with the LD2450 config.

- **Zone-3 Moving Target Count** (*Sensor*): The current number of targets in Zone-3. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-3 Presence** (*Binary Sensor*): Current Zone-3 presence. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-3 Still Target Count** (*Sensor*): The current number of still targets in Zone-3. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

- **Zone-3 Target Count** (*Sensor*): The total number of targets in Zone-3. Only available with the LD2450 config. Update Rate is equivalent to Timeout seconds.

## Configuration

- **Activate SHT Heater** (*Button*): Activate SHT Heater to clear the humidity sensor of saturation. Only available with Sensor-Pkg-A configs.

- **LD2410S Cal Start** (*Button*): Activate Auto-Calibration. Only available with LD2410S radar config.

- **CO Cal Offset** (*Number*): This calibration offset is added to CO readings.

- **CO Cal Sensitivity** (*Number*): This calibration sensitivity is multiplied with CO readings. This should be read from the Figaro Sensor bar code.

- **CO₂ Cal Date** (*Number*): This is user input for the last date the CO₂ sensor was calibrated. This calibration should be performed every 3-4 months.

- **CO₂ Cal Value** (*Number*): This calibration offset is added to CO readings.

- **CO₂ Calibrate** (*Button*): Force CO₂ calibration. Sensor set output CO₂ reading to match CO₂ Cal Value.,

- **Enable Auto Vent** (*Switch*): When on the Automatic Vent be enabled.

- **Enable Auto Vent CO₂** (*Switch*): When on the Automatic Vent will use CO2 levels in addition to humidity.

- **Enable Smoke Alarm** (*Switch*): When on the Smoke Alarm functionality will be enabled. This is experimental. DO NOT USE AS A PRIMARY SMOKE ALARM!

- **Enable PIR** (*Switch*): When on the PIR sensor will be enabled. The PIR sensor is included in presence detection when enabled.

- **G0 Move Threshold** (*Number*): This sets the move threshold for Gate 0. Only available with the LD2410 config.

- **G0 Still Threshold** (*Number*): This sets the still threshold for Gate 0. Only available with the LD2410 config.

- **G1 Move Threshold** (*Number*): This sets the move threshold for Gate 1. Only available with the LD2410 config.

- **G1 Still Threshold** (*Number*): This sets the still threshold for Gate 1. Only available with the LD2410 config.
.
- **G2 Move Threshold** (*Number*): This sets the move threshold for Gate 2. Only available with the LD2410 config.

- **G2 Still Threshold** (*Number*): This sets the still threshold for Gate 2. Only available with the LD2410 config.

- **G3 Move Threshold** (*Number*): This sets the move threshold for Gate 3. Only available with the LD2410 config.

- **G3 Still Threshold** (*Number*): This sets the still threshold for Gate 3. Only available with the LD2410 config.

- **G4 Move Threshold** (*Number*): This sets the move threshold for Gate 4. Only available with the LD2410 config.

- **G4 Still Threshold** (*Number*): This sets the still threshold for Gate 4. Only available with the LD2410 config.

- **G5 Move Threshold** (*Number*): This sets the move threshold for Gate 5.  Only available with the LD2410 config.

- **G5 Still Threshold** (*Number*): This sets the still threshold for Gate 5. Only available with the LD2410 config.

- **G6 Move Threshold** (*Number*): This sets the move threshold for Gate 6. Only available with the LD2410 config.

- **G6 Still Threshold** (*Number*): This sets the still threshold for Gate 6. Only available with the LD2410 config.

- **G7 Move Threshold** (*Number*): This sets the move threshold for Gate 7. Only available with the LD2410 config.

- **G7 Still Threshold** (*Number*): This sets the still threshold for Gate 7. Only available with the LD2410 config.

- **G8 Move Threshold** (*Number*): This sets the move threshold for Gate 8. Only available with the LD2410 config.

- **G8 Still Threshold** (*Number*): This sets the still threshold for Gate 8. Only available with the LD2410 config.

- **G0 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 0. Only available with the LD2410S config.

- **G0 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 0. Only available with the LD2410S config.

- **G1 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 1. Only available with the LD2410S config.

- **G1 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 1. Only available with the LD2410S config

- **G2 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 2. Only available with the LD2410S config.

- **G2 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 2. Only available with the LD2410S config.

- **G3 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 3. Only available with the LD2410S config.

- **G3 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 3. Only available with the LD2410S config.

- **G4 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 4. Only available with the LD2410S config.

- **G4 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 4. Only available with the LD2410S config.

- **G5 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 5. Only available with the LD2410S config.

- **G5 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 5. Only available with the LD2410S config.

- **G6 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 6. Only available with the LD2410S config.

- **G6 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 6. Only available with the LD2410S config.

- **G7 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 7. Only available with the LD2410S config.

- **G7 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 7. Only available with the LD2410S config.

- **G8 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 8. Only available with the LD2410S config.

- **G8 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 8. Only available with the LD2410S config

- **G9 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 9. Only available with the LD2410S config.

- **G9 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 9. Only available with the LD2410S config.

- **G10 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 10. Only available with the LD2410S config.

- **G10 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 10. Only available with the LD2410S config.

- **G11 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 11. Only available with the LD2410S config.

- **G11 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 11. Only available with the LD2410S config.

- **G12 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 12. Only available with the LD2410S config.

- **G12 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 12. Only available with the LD2410S config.

- **G13 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 13. Only available with the LD2410S config.

- **G13 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 13. Only available with the LD2410S config.

- **G14 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 14. Only available with the LD2410S config.

- **G14 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 14. Only available with the LD2410S config.

- **G15 Trigger Threshold** (*Number*): This sets the Trigger threshold for Gate 15. Only available with the LD2410S config.

- **G15 Hold Threshold** (*Number*): This sets the Hold threshold for Gate 15. Only available with the LD2410S config.

- **Humidity Cal Offset** (*Number*): This calibration offset is added to Humidity readings.

- **Hold Sensitivity** (*Optional*): The number represents the ease in which the sensor switches to the present state when someone enters the sensing range of the sensor. Default is 7 (no units) with a range of 0 to 9, higher is more sensitive. The ```Config Save``` button must be clicked to save the sensor configuration to flash and make operational. Only available with C4001 config.

- **LD2410 Bluetooth Enable** (*Switch*): Turns Bluetooth on the in LD2410 Sensor. Only available with the LD2410 config.

- **LD2410 Engineering Mode switch** (*Switch*): Turns Engineering Mode on the in LD2410 Sensor. LD2410 Bluetooth Enable must be on. Only available with the LD2410 config.

- **LD2410 Factory Reset** (*Button*): Will reset the LD2410 Sensor to factory defaults. Only available with the LD2410 config.

- **LD2450 Installation Angle** (*Number*): Changes the installation angle of the LD2450. Rotates the coordinates of the sensor to allow mounting in a corner. -45° would be mounted in a left corner and 45° would be mounted in a right corner. Only available with the LD2450 config.

- **LD2450 Bluetooth Enable** (*Switch*): Turns Bluetooth on the in LD2450 Sensor. Only available with the LD2450 config.

- **LD2450 Factory Reset** (*Button*): Will reset the LD2450 Sensor to factory defaults. Only available with the LD2450 config.

- **LD2450 Multi Target Tracking** (*Switch*): Enables up to three target tracking at the same time. Only available with the LD2450 config.

- **Min Range** (*Optional*): This is the minimum detection range. Default is 0.6 meters (m) with a range of 0.6 to 25.0 m. The manual recommends not changing this value. The ```Config Save``` button must be clicked to save the sensor configuration to flash and make operational. Only available with C4001 config.

- **Max Move Distance** (*Number*): The sets the maximum move distance bin. Only available with the LD2410 config.

- **Max Still Distance** (*Number*): The sets the maximum still distance bin. Only available with the LD2410 config.

- **Max Range** (*Optional*): This is the maximum detection range. Default is 6 meters (m) with a range of 0.6 to 25.0 m. The ```Config Save``` button must be clicked to save the sensor configuration to flash and make operational. Only available with C4001 config.

- **On Latency** (*Optional*): This time value is how long presence is detected before switching to the present state. Default is 0.050 (seconds) with a range of 0.0 to 100.0. The ```Config Save``` button must be clicked to save the sensor configuration to flash and make operational. Only available with C4001 config.

- **Restart** (*Button*): Will restart entire module.

- **Start Fan Cleaning** (*Button*): Start a fan cleaning for the SEN66 sensor. Only available with the Sensor-Pkg-A config.

- **Temperature Cal Offset** (*Number*): This calibration offset is added to Temperature readings.

- **Timeout** (*Number*): For binary_sensors this is how long the sensor has been quiet before turning off. For sensors this is minimum time between updates. If the is no change there will be no update. Default is 60s with a range of 1 to 3600 s.

- **Trigger Range** (*Optional*): Sets the maximum range at which occupancy can switch to present. The range between max detection range and trigger detection range can NOT cause occupancy to switch to present. Default is 0.6 meters (m) with a range of 0.6 to 25.0 m. The ```Config Save``` button must be clicked to save the sensor configuration to flash and make operational. Only available with C4001 config.

- **Trigger Sensitivity** (*Optional*): This number represents ease of continued presence detection after the sensor switched to the present state. Default is 5 (no units) with a range of 0 to 9, higher is more sensitive. The ```Config Save``` button must be clicked to save the sensor configuration to flash and make operational. Only available with C4001 config.

## Diagnostic

- **LD2410S Cal Running** (*Binary Sensor*): When ```true``` the LD2410S calibration is running. Only available with the LD2410S config.

- **LD2410S Cal Progress** (*Sensor*): This is the current progress of the Auto-Calibration. Range is 0 - 100 %. Will bu unknown when the Auto-Calibration is not running. Only available with the LD2410S config.

- **G0 Move Energy** (*Sensor*): Gate 0 Move Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G0 Still Energy** (*Sensor*): Gate 0 Still Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G1 Move Energy** (*Sensor*): Gate 1 Move Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G1 Still Energy** (*Sensor*): Gate 1 Still Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G2 Move Energy** (*Sensor*): Gate 2 Move Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G2 Still Energy** (*Sensor*): Gate 2 Still Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G3 Move Energy** (*Sensor*): Gate 3 Move Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G3 Still Energy** (*Sensor*): Gate 3 Still Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G4 Move Energy** (*Sensor*): Gate 4 Move Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G4 Still Energy** (*Sensor*): Gate 4 Still Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G5 Move Energy** (*Sensor*): Gate 5 Move Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G5 Still Energy** (*Sensor*): Gate 5 Still Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G6 Move Energy** (*Sensor*): Gate 6 Move Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G6 Still Energy** (*Sensor*): Gate 6 Still Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G7 Move Energy** (*Sensor*): Gate 7 Move Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G7 Still Energy** (*Sensor*): Gate 7 Still Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G8 Move Energy** (*Button*): Gate 8 Move Energy. Only works when LD2410 Engineering Mode switch is on. Only available with the LD2410 config.

- **G8 Still Energy** (*Button*): Gate 8 Still Energy. Only works when LD2410 Engineering Mode switch switch is on. Only available with the LD2410 config.

- **G0 Energy** (*Sensor*): Gate 0 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G1 Energy** (*Sensor*): Gate 1 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G2 Energy** (*Sensor*): Gate 2 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G3 Energy** (*Sensor*): Gate 3 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G4 Energy** (*Sensor*): Gate 4 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G5 Energy** (*Sensor*): Gate 5 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G6 Energy** (*Sensor*): Gate 6 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G7 Energy** (*Sensor*): Gate 7 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G8 Energy** (*Sensor*): Gate 8 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G9 Energy** (*Sensor*): Gate 9 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G10 Energy** (*Sensor*): Gate 10 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G11 Energy** (*Sensor*): Gate 11 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G12 Energy** (*Sensor*): Gate 12 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G13 Energy** (*Sensor*): Gate 13 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G14 Energy** (*Sensor*): Gate 14 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **G15 Energy** (*Sensor*): Gate 15 Energy. Only works when Minimal Output switch is off. Only available with the LD2410S config.

- **Heap Free** (*Sensor*): From ESPHome diagnostic.

- **Heap Max Block** (*Sensor*): From ESPHome diagnostic.

- **Loop Time** (*Sensor*): From ESPHome diagnostic.

- **LD2410 BT MAC** (*Sensor*): Bluetooth MAC address. Only available when Engineering Mode is on. Only available with the LD2410 config.

- **LD2410 Firmware** (*Sensor*): LD2410 module firmware version. Only available when Engineering Mode is on. Only available with the LD2410 config.

- **LD2410S Firmware** (*Sensor*): LD2410S module firmware version. Only available with the LD2410S config.

- **LD2450 Firmware** (*Sensor*): LD2450 module firmware version. Only available with the LD2450 config.

- **LD2450 Restart** (*Button*): Will restart LD2450 module. Only available with the LD2450 config.

- **Radar Included** (*Sensor*): Indicates the installed Radar sensor. Will be one of C4001, LD2410, LD2410S or LD2450.

[back](./)

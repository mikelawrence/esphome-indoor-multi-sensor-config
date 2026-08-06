![Sensor](https://raw.githubusercontent.com/mikelawrence/esphome-indoor-multi-sensor-hardware/main/enclosure/meta/ESPHome-Indoor-Multi-Sensor-Corner-Mount-Render.png)

# Initial Programming

<script src="version.js"></script>

You need to make two choices before programming the ESPHome Indoor Multi-Sensor.

First is the Sensor package. You can either choose Package A, the Sensirion SEN6X sensor package which is an all-in-one sensor package. Or you can choose Package B which is a lower cost discrete sensor set that is missing particulate matter sensors.

Next up is what type of radar sensor you plan on including. There are 4 options here, Hi Link LD2410 (My favorite), DFRobot C4001 (SEN0609 and SEN0610) Hi-Link LD2450, Hi-Link LD2410S and Hi-Link LD2420.

Each of these these builds include all supported sensors: pressure, light, sound level, power/energy monitor and speaker. If there are sensors you wish to not include, take control of the sensor and start configuring.

If you are really new to ESPHome I would recommend searching on Youtube for getting started videos.

> WARNING!
> The Hi-Link LD2410S and Hi-Link LD2420 only work on Rev-B boards.

# PCB Rev B Web Installation

Use the buttons below to install pre-built firmware directly to your Rev-B hardware via USB.

> This will install version <span id="current-version">unknown</span>.

| Sensor Pkg | No Radar | Radar LD2410 | Radar C4001 | Radar LD2450 | Radar LD2410S | Radar LD2420 |
|---|---|---|---|
| Pkg A | <esp-web-install-button manifest="firmware/multi-sensor-pkga-none.manifest.json"></esp-web-install-button> |  <esp-web-install-button manifest="firmware/multi-sensor-pkga-ld2410.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/multi-sensor-pkga-c4001.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/multi-sensor-pkga-ld2450.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/multi-sensor-pkga-2410s.manifest.json"></esp-web-install-button> | Coming Soon |
| Pkg B | <esp-web-install-button manifest="firmware/multi-sensor-pkgb-none.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/multi-sensor-pkgb-ld2410.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/multi-sensor-pkgb-c4001.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/multi-sensor-pkgb-ld2450.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/multi-sensor-pkgb-2410s.manifest.json"></esp-web-install-button> | Coming Soon |

<script type="module" src="https://unpkg.com/esp-web-tools@10/dist/web/install-button.js?module"></script>

# Calibration

## Package A

The SEN66 sensor has a defined calibration procedure as described in the [SEN6x – Temperature Acceleration and Compensation
Instructions](https://sensirion.com/media/documents/C964FCC8/69709EC3/PS_AN_SEN6x_Temperature_Compensation_and_Acceleration_Application_No.pdf) from Sensirion. There is also a [youtube video](https://youtu.be/HT16bm6oPHI?si=_pqvh2F-3bO1Wv5a) which is easier to follow.

I have perfomed this calibration procedure on each of the radar configurations since each radar has a different power dissipation. My setup includes the following item purchased off Amazon:

- [Seedling tray](https://a.co/d/058HEgbu) with cover. These are fairly common but usually only available in packs of 5 or more. They are not insulated if you wrap a blanket around it the temperature will stabalize even in an air conditioned room. Another option is a styrafoam cooler.

- [Seedling Heat Mat](https://a.co/d/0hUoT6jo) is intended to be used with the seedling tray. The low wattage works well for this application but be wary of the included controller. It does not regulate the temperature very well. As in more than +/- 2°F which is not that back but but is oscillates between the min and max and is clearly not a PID controller. In the end I used a separate PID controller as indicated below.

- [PID Temperature Controller](https://a.co/d/08tquZl0) is a significant improvement of the on/off controller above with hysteresis. It has Auto-Tuning which works quite well. Letting temperature stabilize in my blanket wrapped Seedling Tray with this controller resulted in very little oscillation.

- [SEK SensorBridge](https://sensirion.com/products/catalog/SEK-SensorBridge) is used to capture temperature data from separate SHT45 sensor and the internal SEN66 sensor embedded in Multi-Sensor platform.

Following the Sensirion procedure the computed values for each radar configuration are stored in the SEN66 Temperature Compensation Slot 0. Temperature Cal Offset is stored in Slot 1 and it used to further calibrate the temperature and humidity additional heating or cooling sources outside the the sensor module.

Here is a picture of the inside calibration setup. I printed a small platform to hold the sensor behind a corner wall. The corner wall purpose is two fold, first is provide a convenient mounting surface and it block drafts from the small circulation fan attached to the underside of the printed platform. Also under the platform is the SEK Sensorbridge.

![Inside](https://raw.githubusercontent.com/mikelawrence/esphome-indoor-multi-sensor-config/main/static/inside.jpg)

This is the whole assembly wrapped up all nice an cozy ia couple of balnkets.

![Inside](https://raw.githubusercontent.com/mikelawrence/esphome-indoor-multi-sensor-config/main/static/blanket-covered.jpg)

Here is a screen capture of the Sensirion Dataviewer with the data from the LD2410 test. It shows the computed compensation values effect on the the temperature and humidity data.

![Data Viewer](https://raw.githubusercontent.com/mikelawrence/esphome-indoor-multi-sensor-config/main/static/data-ld2410.png)

## Package B

The SHT45 sensor does not have built in temperature and humidity compensation. However, the temperature can still be adjusted with the Temperature Cal Offset number in Home Assistant. The humidity is also temperature compensated by the Temperature Cal Offset with the Magnus formula.

## Additional Calibration Steps

The calibration settings determined by the testing above are automatically applied by the configuration. This makes the sensor more accurate but there are other influences that will cause you to need additional calibration. To that end there are two numbers `Temperature Cal Offset` and  `Humidity Cal Offset` that added with an offset filter for final calibration. Remember that Humidity is affected temperature so it is always best to get temperature calibrated before attempting Humidity calibration.

# Next Steps

Right now Home Assistant is the only destination for this sensor. Click [Home Assistant configuration page](./home-assistant.html) to learn what's available in Home Assistant.

So you have taken control what's next? Go to the [ESPHome configuration page](./configuration.html) to learn just how much trouble you can get into with this sensor!

There also some handy [dashboards](./home-assistant-dashboard.html) to make it easy to configure the radar sensor.

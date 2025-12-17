![Sensor](https://raw.githubusercontent.com/mikelawrence/esphome-indoor-multi-sensor-hardware/main/enclosure/meta/ESPHome-Multi-Sensor-Enclosure-Render.png)

# Initial Programming

You need to make two choices before programming the ESPHome Indoor Multi-Sensor.

First is the Sensor package. You can either choose Package A, the Sensirion SEN6X sensor package which is an all-in-one sensor package. Or you can choose Package B which is a lower cost discrete sensor set that is missing particulate matter sensors.

Next up is what type of radar sensor you plan on including. There are 4 options here, Hi Link LD2410 (My favorite), DFRobot C4001 (SEN0609 and SEN0610) Hi-Link LD2450, Hi-Link LD2410S and Hi-Link LD2420.

Each of these these builds include all supported sensors: pressure, light, sound level, power/energy monitor and speaker. If there are sensors you wish to not include, take control of the sensor and start configuring.

If you are really new to ESPHome I would recommend searching on Youtube for getting started videos.

# Web Installation

Use the buttons below to install pre-built firmware directly to your device via USB. You must use Google Chrome or Microsoft Edge to program your device. Firefox does not work.

| Sensor Pkg | Radar LD2410 | Radar C4001 | Radar LD2450 | Radar LD2410S | Radar LD2420 |
|---|---|---|---|
| Pkg A | <esp-web-install-button manifest="firmware/sensor-pkg-a-ld2410.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-a-c4001.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-a-ld2450.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-a-ld2410s.manifest.json"></esp-web-install-button> | Coming Soon |
| Pkg B | <esp-web-install-button manifest="firmware/sensor-pkg-b-ld2410.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-b-c4001.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-b-ld2450.manifest.json"></esp-web-install-button> | <esp-web-install-button manifest="firmware/sensor-pkg-b-ld2410s.manifest.json"></esp-web-install-button> | Coming Soon |

<script type="module" src="https://unpkg.com/esp-web-tools@10/dist/web/install-button.js?module"></script>

# Next steps

Right now Home Assistant is the only destination for this sensor. Click [here](./home-assistant.html) to learn what's available in Home Assistant.

So you have taken control what's next? Go to the [configuration page](./configuration.html) to learn just how much trouble you can get into with this sensor!

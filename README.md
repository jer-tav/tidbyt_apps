# tidbyt_apps
Random Apps created for the Tidbyt using Starlark

## Pre-reqs
1. [Pixlet](https://github.com/tidbyt/pixlet) in your PATH

## TryFi 
This app shows your pet's step count for the day, using the [Fi Collar](https://tryfi.com/) API.

### Arguments
| Argument Name | Description | Required / Optional | Default |
| --- | --- | --- | --- |
| username | The username used with the Fi app | Required | None |
| password | The password used with the Fi app | Required | None |
| pet_name | The name of the pet to display the step count for | Required | None |

### Example Render with Pixlet
`pixlet render tryfi/tryfi.star username=example@email.com password=topsecretpassword pet_name=Fido`

## Nightscout
This app shows [Nightscout](https://nightscout.github.io) continuous glucose monitoring on the Tidbyt.

The app will display the users trend arrow (one of double up, up, 45 degree up, flat, 45 degree down, down and double down), along with the current BG reading and a delta from the previous reading.

The arrow and current BG reading is color coded red, yellow or green based on the parameters passed to the application (see below for these thresholds).  

If the current data is more than 15 minutes out of date, the arrow and current BG reading are coloured grey.

### Arguments
| Argument Name | Description | Required / Optional | Default |
| --- | --- | --- | --- | 
| id | The Nightscout ID for the user | Required | None
| normal_high | The normal high value - anything above this is considered yellow unless it is above the urgent_high | Optional | 150 |
| normal_low | The normal low value - anything below this is considered yellow unless it is below the urgent_low | Optional | 100 |
| urgent_high | The urgent high value - anything above this is considered red | Optional | 200 |
| urgent_low | The urgent low value - anything below this is considered red | Optional | 70 |

### Example Renders with Pixlet
`pixlet render nightscout/nightscout.star id=abc normal_high=170 normal_low=110`
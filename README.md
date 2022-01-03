# tidbyt_apps
Random Apps created for the Tidbyt using Starlark

## Pre-reqs
1. [Pixlet](https://github.com/tidbyt/pixlet) in your PATH

## TryFi 
This app shows your pet's step count for the day, using the [Fi Collar](https://tryfi.com/) API.

### Arguments
| Argument Name | Description |
| --- | --- |
| username | The username used with the Fi app |
| password | The password used with the Fi app |
| pet_name | The name of the pet to display the step count for |

### Example Render with Pixlet
`pixlet render tryfi/tryfi.star username=example@email.com password=topsecretpassword pet_name=Fido`


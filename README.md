### Swift Demo Program for Kvaser CAN Leaf Interfaces (macOS&reg;)

_Copyright &copy; 2021  Uwe Vogt, UV Software, Berlin (info@mac-can.com)_

# Running CAN on Mac&reg;

_Running CAN on Mac_ is the mission of the MacCAN project.
The macOS driver for CAN Leaf interfaces from [Kvaser](https://www.kvaser.com) is based on _MacCAN-Core_ which is an abstraction (or rather a wrapper) of Apple´s IOUsbKit to create USB user-space drivers for CAN interfaces from various vendors under macOS.

## SwiftCAN-KvaserCAN

This repo contains only a little example program that uses the [MacCAN-KvaserCAN](https://github.com/mac-can/MacCAN-KvaserCAN/) Swift wrapper as a required package dependency.
Feel free to modify the program.

### MacCAN-KvaserCAN Swift Wrapper

Visit my [GitHub Pages](https://mac-can.github.io/drivers/KvaserCAN/) to learn more about the macOS driver and SDK for Kvaser CAN Leaf interfaces.

### Supported CAN Leaf Hardware

- Kvaser Leaf Light v2 (EAN: 73-30130-00685-0)
- Kvaser Leaf Pro HS v2 (EAN: 73-30130-00843-4)

## Known Bugs and Caveats

- For a list of known bugs and caveats see tab [Issues](https://github.com/mac-can/MacCAN-KvaserCAN/issues) in the GitHub repo.

## This and That

### Licenses

#### SwiftCAN-KvaserCAN License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

#### MacCAN-KvaserCAN License

MacCAN-KvaserCAN is dual-licensed under the terms of the BSD 2-Clause "Simplified" License
and under the terms of the GNU General Public License v3.0 (or any later version).
The terms of the GNU General Public License v3.0 (or any later version) apply to this program, see above.

### Trademarks

Mac and macOS are trademarks of Apple Inc., registered in the U.S. and other countries. \
All other company, product and service names mentioned herein are trademarks, registered trademarks or service marks of their respective owners.

### Hazard Note

_If you connect your CAN device to a real CAN network when using this library, you might damage your application._

### Contact

E-Mail: mailto://info@mac.can.com \
Internet: https://www.mac-can.com

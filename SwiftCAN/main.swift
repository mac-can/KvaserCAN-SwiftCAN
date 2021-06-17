//  SPDX-License-Identifier: GPL-3.0-or-later
//
//  main.swift
//  SwiftCAN-KvaserCAN
//  Copyright (c) 2021 Uwe Vogt, UV Software, Berlin
//
import Foundation
import KvaserCAN

print("\(try CanApi.GetVersion())")
print("Copyright (c) 2020-2021 Uwe Vogt, UV Software, Berlin")
print("")
print("This program is free software: you can redistribute it and/or modify")
print("it under the terms of the GNU General Public License as published by")
print("the Free Software Foundation, either version 3 of the License, or")
print("(at your option) any later version.")
print("")
print("This program is distributed in the hope that it will be useful,")
print("but WITHOUT ANY WARRANTY; without even the implied warranty of")
print("MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the")
print("GNU General Public License for more details.")
print("")
print("You should have received a copy of the GNU General Public License")
print("along with this program.  If not, see <http://www.gnu.org/licenses/>.")
print("")

let can = KvaserCAN()
let channel: Int32 = 0
let mode: CanApi.Mode = [.DefaultOperationMode]
let baud: CanApi.CiaIndex = .Index250kbps
var step: String
var n = 0

if let version = can.wrapperVersion {
    print(">>> Version: major=\(version.major) minor=\(version.minor) patch=\(version.patch)")
}
//if let canApiVersion = can.canApiVersion {
//    print(">>> CAN API: major=\(canApiVersion.major) minor=\(canApiVersion.minor) patch=\(canApiVersion.patch)")
//}
//if let libraryVersion = can.libraryVersion {
//    print(">>> Library: major=\(libraryVersion.major) minor=\(libraryVersion.minor) patch=\(libraryVersion.patch)")
//}
//if let libraryInfo = can.libraryInfo {
//    print(">>> Library: id=\(libraryInfo.id) name=\"\(libraryInfo.name)\" vendor=\"\(libraryInfo.vendor)\"")
//}
//for x in KvaserCanChannel.allCases {
//    let state = try KvaserCAN.ProbeChannel(channel: x.rawValue, mode: mode)
//    print(">>> Probe channel \(x.rawValue): \(x.ChannelName()) -> (\(state))")
//}
do {
    step = "InitializeChannel"
    print(">>> \(step)(channel: \(channel), mode: \(mode))")
    try can.InitializeChannel(channel: channel, mode: mode)
    step = "StartController"
    print(">>> \(step)(index: \(baud))")
    try can.StartController(index: baud)
} catch let e as CanApi.Error {
    print("+++ error:   \(step) returned \(e) (\(e.description))")
    exit(1)
} catch {
    print("+++ error:   \(step) returned \(error)")
    exit(1)
}
if let canApiVersion = can.canApiVersion {
    print(">>> CAN API: major=\(canApiVersion.major) minor=\(canApiVersion.minor) patch=\(canApiVersion.patch)")
}
if let libraryVersion = can.libraryVersion {
    print(">>> Library: major=\(libraryVersion.major) minor=\(libraryVersion.minor) patch=\(libraryVersion.patch)")
}
if let libraryInfo = can.libraryInfo {
    print(">>> Library: id=\(libraryInfo.id) name=\"\(libraryInfo.name)\" vendor=\"\(libraryInfo.vendor)\"")
}
if let deviceInfo = can.deviceInfo {
    print(">>> Device : type=\(deviceInfo.type) name=\"\(deviceInfo.name)\" vendor=\"\(deviceInfo.vendor)\"")
}
if let capa = can.capability {
    print(">>> Op-Capa: FDOE=\(capa.isFdOperationEnabled) BRSE=\(capa.isBitrateSwitchingEnabled) NISO=\(capa.isNonIsoOperationEnabled) SHRD=\(capa.isSharedAccessEnabled) NXTD=\(capa.isExtendedFramesDisabled) NRTR=\(capa.isRemoteFramesDisabled) ERR=\(capa.isErrorFramesEnabled) MON=\(capa.isMonitorModeEnabled)")
}
if let mode = can.mode {
    print(">>> Op-Mode: FDOE=\(mode.isFdOperationEnabled) BRSE=\(mode.isBitrateSwitchingEnabled) NISO=\(mode.isNonIsoOperationEnabled) SHRD=\(mode.isSharedAccessEnabled) NXTD=\(mode.isExtendedFramesDisabled) NRTR=\(mode.isRemoteFramesDisabled) ERR=\(mode.isErrorFramesEnabled) MON=\(mode.isMonitorModeEnabled)")
}
if let bitrate = can.bitrate {
    print(">>> Bitrate: frequency=\(bitrate.frequency) nom_brp=\(bitrate.nominal.brp) nom_tseg1=\(bitrate.nominal.tseg1) nom_tseg2=\(bitrate.nominal.tseg2) nom_sjw=\(bitrate.nominal.sjw) nom_sam=\(bitrate.nominal.sam)")
}
if let speed = can.speed {
    print("             \(speed.nominal.busSpeed / 1000.0)kbps @ \(speed.nominal.samplePoint * 100.0)%")
}
var running: sig_atomic_t = 1
signal(SIGINT) { signal in running = 0 }

print("Be patient...")
for _ in 0..<2048 {
    do {
        step = "WriteMessage"
        try can.WriteMessage(message: CanApi.Message(canId: 0x100, data: [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88]), timeout: 1000)
    } catch let e as CanApi.Error {
        print("+++ error:   \(step) returned \(e) (\(e.description))")
        break
    } catch {
        print("+++ error:   \(step) returned \(error)")
        exit(1)
    }
    if running == 0 {
        break;
    }
}
if let status = can.status {
    print(">>> status:  BO=\(status.isBusOff) EW=\(status.isWarningLevel) BE=\(status.isBusError) TP=\(status.isTransmitterBusy) RE=\(status.isReceiverEmpty) ML=\(status.isMessageLost) QO=\(status.isQueueOverrun)")
}
if let statistics = can.statistics {
    print("             \(statistics.transmitted) frame(s) sent (error frames=\(statistics.errors))")
}
print("Press ^C to abort...")
while running != 0 {
    do {
        step = "ReadMessage"
        if let message = try can.ReadMessage() {
            print(">>> \(n): Message(id: \(message.canId), dlc: \(message.canDlc), data: \(message.data))")
        }
    } catch let e as CanApi.Error {
        print("+++ error:   \(step) returned \(e) (\(e.description))")
        break
    } catch {
        print("+++ error:   \(step) returned \(error)")
        exit(1)
    }
    n += 1
}
print("")
if let status = can.status {
    print(">>> status:  BO=\(status.isBusOff) EW=\(status.isWarningLevel) BE=\(status.isBusError) TP=\(status.isTransmitterBusy) RE=\(status.isReceiverEmpty) ML=\(status.isMessageLost) QO=\(status.isQueueOverrun)")
}
if let statistics = can.statistics {
    print("             \(statistics.received) frame(s) received (error frames=\(statistics.errors))")
}
do {
    step = "HardwareVersion"
    print(">>> \(try can.GetHardwareVersion())")
    step = "FirmwareVersion"
    print(">>> \(try can.GetFirmwareVersion())")
    step = "ResetController"
    print(">>> \(step)()")
    try can.ResetController()
    step = "TeardownChannel"
    print(">>> \(step)()")
    try can.TeardownChannel()
} catch let e as CanApi.Error {
    print("+++ error:   \(step) returned \(e) (\(e.description))")
    exit(1)
} catch {
    print("+++ error:   \(step) returned \(error)")
    exit(1)
}
print("Bye!")
exit(0)

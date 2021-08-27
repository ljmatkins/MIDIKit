//
//  MIDI1Parser Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventMIDI1ParserTests: XCTestCase {
    
    func testMIDIPacketData_parsedEvents_Empty() {
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
    }
    
    func testMIDIPacketData_parsedEvents_SingleEvents() {
        
        // - channel voice
        
        // note off
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0x80, 0x3C, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.noteOff(note: 60, velocity: 64, channel: 0, group: 0)]
        )
        
        // note on
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0x91, 0x3C, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.noteOn(note: 60, velocity: 64, channel: 1, group: 0)]
        )
        
        // poly aftertouch
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xA4, 0x3C, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.polyAftertouch(note: 60, pressure: 64, channel: 4, group: 0)]
        )
        
        // cc
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xB1, 0x01, 0x7F], timeStamp: 0)
                .parsedEvents().events,
            [.cc(controller: 1, value: 127, channel: 1, group: 0)]
        )
        
        // program change
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xCA, 0x20], timeStamp: 0)
                .parsedEvents().events,
            [.programChange(program: 32, channel: 10, group: 0)]
        )
        
        // channel aftertouch
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xD8, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.chanAftertouch(pressure: 64, channel: 8, group: 0)]
        )
        
        // pitch bend
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xE3, 0x00, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.pitchBend(value: 8192, channel: 3, group: 0)]
        )
        
        // - system messages
        
        // SysEx
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF0, 0x7D, 0x01, 0xF7], timeStamp: 0)
                .parsedEvents().events,
            [.sysEx(manufacturer: MIDI.Event.SysEx.Manufacturer(oneByte: 0x7D)!,
                    data: [0x01],
                    group: 0)
            ]
        )
        
        // System Common - timecode quarter-frame
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF1, 0x00], timeStamp: 0)
                .parsedEvents().events,
            [.timecodeQuarterFrame(byte: 0x00, group: 0)]
        )
        
        // System Common - Song Position Pointer
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF2, 0x08, 0x00], timeStamp: 0)
                .parsedEvents().events,
            [.songPositionPointer(midiBeat: 8, group: 0)]
        )
        
        // System Common - Song Select
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF3, 0x08], timeStamp: 0)
                .parsedEvents().events,
            [.songSelect(number: 8, group: 0)]
        )
        
        // System Common - (0xF4 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF4], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // System Common - (0xF5 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF5], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // System Common - Tune Request
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF6], timeStamp: 0)
                .parsedEvents().events,
            [.tuneRequest(group: 0)]
        )
        
        // System Common - System Exclusive End (EOX / End Of Exclusive)
        // on its own, 0xF7 is ignored
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF7], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // real time: timing clock
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF8], timeStamp: 0)
                .parsedEvents().events,
            [.timingClock(group: 0)]
        )
        
        // real time: (undefined)
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF9], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // real time: start
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFA], timeStamp: 0)
                .parsedEvents().events,
            [.start(group: 0)]
        )
        
        // real time: continue
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFB], timeStamp: 0)
                .parsedEvents().events,
            [.continue(group: 0)]
        )
        
        // real time: stop
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFC], timeStamp: 0)
                .parsedEvents().events,
            [.stop(group: 0)]
        )
        
        // real time: (undefined)
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFD], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // real time: active sensing
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFE], timeStamp: 0)
                .parsedEvents().events,
            [.activeSensing(group: 0)]
        )
        
        // real time: system reset
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFF], timeStamp: 0)
                .parsedEvents().events,
            [.systemReset(group: 0)]
        )
        
    }
    
    func testMIDIPacketData_parsedEvents_MultipleEvents() {
        
        // channel voice
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(
                bytes: [
                    0x80, 0x3C, 0x40,
                    0x90, 0x3C, 0x40
                ],
                timeStamp: 0
            )
            .parsedEvents().events,
            
            [.noteOff(note: 60, velocity: 64, channel: 0),
             .noteOn(note: 60, velocity: 64, channel: 0)]
        )
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(
                bytes: [
                    0xB1, 0x01, 0x7F,
                    0x96, 0x3C, 0x40,
                    0xB2, 0x02, 0x08
                ],
                timeStamp: 0
            )
            .parsedEvents().events,
            
            [.cc(controller: 1, value: 127, channel: 1),
             .noteOn(note: 60, velocity: 64, channel: 6),
             .cc(controller: 2, value: 8, channel: 2)]
        )
        
    }
    
    func testMIDIPacketData_parsedEvents_RunningStatus_SinglePacket() {
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(
                bytes: [
                    0x90,
                    0x3C, 0x40,
                    0x3D, 0x41
                ],
                timeStamp: 0
            )
            .parsedEvents().events,
            
            [.noteOn(note: 60, velocity: 64, channel: 0),
             .noteOn(note: 61, velocity: 65, channel: 0)]
        )
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(
                bytes: [
                    0x9F,
                    0x3C, 0x40,
                    0x3D, 0x41,
                    0x3E, 0x42
                ],
                timeStamp: 0
            )
            .parsedEvents().events,
            
            [.noteOn(note: 60, velocity: 64, channel: 15),
             .noteOn(note: 61, velocity: 65, channel: 15),
             .noteOn(note: 62, velocity: 66, channel: 15)]
        )
        
    }
    
    func testMIDIPacketData_parsedEvents_RunningStatus_SeparatePackets_Simple() {
        
        var parsed = MIDI.Packet.PacketData(
            bytes: [
                0x92,
                0x3C, 0x40
            ],
            timeStamp: 0
        )
        .parsedEvents(runningStatus: nil)
        
        XCTAssertEqual(
            parsed.events,
            [.noteOn(note: 60, velocity: 64, channel: 2)]
        )
        
        XCTAssertEqual(
            parsed.runningStatus,
            0x92
        )
        
        parsed = MIDI.Packet.PacketData(
            bytes: [
                0x3E, 0x42
            ],
            timeStamp: 0
        )
        .parsedEvents(runningStatus: parsed.runningStatus)
        
        XCTAssertEqual(
            parsed.events,
            [.noteOn(note: 62, velocity: 66, channel: 2)]
        )
        
        XCTAssertEqual(
            parsed.runningStatus,
            0x92
        )
        
        parsed = MIDI.Packet.PacketData(
            bytes: [
                0x84,
                0x01, 0x02
            ],
            timeStamp: 0
        )
        .parsedEvents(runningStatus: parsed.runningStatus)
        
        XCTAssertEqual(
            parsed.events,
            [.noteOff(note: 1, velocity: 2, channel: 4)]
        )
        
        XCTAssertEqual(
            parsed.runningStatus,
            0x84
        )
        
    }
    
    func testMIDIPacketData_parsedEvents_MidstreamRealTimeMessages() {
        
        // template method
        
        func parsedEvents(bytes: [MIDI.Byte]) -> [MIDI.Event] {
            MIDI.Packet.PacketData(bytes: bytes, timeStamp: 0)
                .parsedEvents().events
        }
        
        let systemRealTimeMessages: [MIDI.Byte : [MIDI.Event]] = [
            0xF8: [.timingClock(group: 0)],
            0xF9: [], // undefined
            0xFA: [.start(group: 0)],
            0xFB: [.continue(group: 0)],
            0xFC: [.stop(group: 0)],
            0xFD: [], // undefined
            0xFE: [.activeSensing(group: 0)],
            0xFF: [.systemReset(group: 0)]
        ]
        
        // tests
        
        // preface:
        // MIDI 1.0 Spec: "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
        
        // ------------------------------------------------
        
        // test: real time message byte in between status and data byte(s) of a CV message
        // result: should produce the CV message and the real-time message
        
        systemRealTimeMessages.forEach { realTimeMessage in
            
            let realTimeByte = realTimeMessage.key
            let realTimeEvent = realTimeMessage.value
            
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90,
                            realTimeByte, // inserted between status and databyte1
                            0x3C, 0x40]),
                
                realTimeEvent + [.noteOn(note: 60, velocity: 64, channel: 0)]
            )
            
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90, 0x3C,
                            realTimeByte, // inserted between databyte1 and databyte2
                            0x40]),
                
                realTimeEvent + [.noteOn(note: 60, velocity: 64, channel: 0)]
            )
            
        }
        
    }
    
    func testMIDIPacketData_parsedEvents_RunningStatus_SystemRealTime() {
        
        // template method
        
        func parsedEvents(bytes: [MIDI.Byte]) -> [MIDI.Event] {
            MIDI.Packet.PacketData(bytes: bytes, timeStamp: 0)
                .parsedEvents().events
        }
        
        let systemRealTimeMessages: [MIDI.Byte : [MIDI.Event]] = [
            0xF8: [.timingClock(group: 0)],
            0xF9: [], // undefined
            0xFA: [.start(group: 0)],
            0xFB: [.continue(group: 0)],
            0xFC: [.stop(group: 0)],
            0xFD: [], // undefined
            0xFE: [.activeSensing(group: 0)],
            0xFF: [.systemReset(group: 0)]
        ]
        
        // tests
        
        // premise: test that real time system messages reset Running Status
        
        // test: full CV message, real time system message, CV running status data bytes only
        // result: should produce two CV messages and a real time message
        
        systemRealTimeMessages.forEach { realTimeMessage in
            
            let realTimeByte = realTimeMessage.key
            let realTimeEvent = realTimeMessage.value
            
            // channel voice Running Status
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90, 0x3C, 0x40, // full CV note on message
                            realTimeByte, // real-time message
                            0x3D, 0x41 // CV running status data bytes
                    ]),
                
                [.noteOn(note: 60, velocity: 64, channel: 0)]
                    + realTimeEvent
                    + [.noteOn(note: 61, velocity: 65, channel: 0)]
            )
            
            // system real time events are not a SysEx terminator
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0xF0, 0x41, 0x01, 0x34,
                            realTimeByte, // real-time message
                            0x27, 0x52, 0xF7 // SysEx message continues
                    ]),
                
                realTimeEvent
                    + [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x01, 0x34, 0x27, 0x52])]
            )
            
        }
        
    }
    
    func testMIDIPacketData_parsedEvents_RunningStatus_SystemCommon() {
        
        // template method
        
        func parsedEvents(bytes: [MIDI.Byte]) -> [MIDI.Event] {
            MIDI.Packet.PacketData(bytes: bytes, timeStamp: 0)
                .parsedEvents().events
        }
        
        let systemCommonMessages: [[MIDI.Byte] : [MIDI.Event]] = [
            // 0xF0 - SysEx Start, not applicable to check in this test
            [0xF1, 0x00]       : [.timecodeQuarterFrame(byte: 0x00, group: 0)],
            [0xF2, 0x08, 0x00] : [.songPositionPointer(midiBeat: 8, group: 0)],
            [0xF3, 0x05]       : [.songSelect(number: 5, group: 0)],
            [0xF4]             : [], // undefined
            [0xF5]             : [], // undefined
            [0xF6]             : [.tuneRequest(group: 0)],
            [0xF7]             : [] // SysEx end
        ]
        
        // tests
        
        // premise: test that system common messages reset Running Status
        
        // test: full CV message, system common message, CV running status data bytes only
        // result: should produce the first CV messages and the system common message but not the second CV message
        
        systemCommonMessages.forEach { systemCommonMessage in
            
            let commonBytes = systemCommonMessage.key
            let commonEvent = systemCommonMessage.value
            
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90, 0x3C, 0x40] // full CV note on message
                            + commonBytes // real-time message
                            + [0x3D, 0x41] // CV running status data bytes
                    ),
                
                [.noteOn(note: 60, velocity: 64, channel: 0)]
                    + commonEvent
            )
            
        }
        
        // premise: a system common status byte should reset Running Status even if previous CV message was incomplete
        
        // test: incomplete CV message, then system common message starts
        // result: the incomplete CV message is discarded and the system common message succeeds
        
        systemCommonMessages.forEach { systemCommonMessage in
            
            let commonBytes = systemCommonMessage.key
            let commonEvent = systemCommonMessage.value
            
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90, 0x3C] // first 2/3 bytes of CV note on message
                        + commonBytes   // full real-time message
                        + [0x40,        // byte 3/3 of first CV note on message
                           0x3D, 0x41]  // CV running status data bytes
                ),
                
                commonEvent
            )
            
        }
        
    }
    
    func testMIDIPacketData_parsedEvents_Malformed() {
        
        // template method
        
        func parsedEvents(bytes: [MIDI.Byte]) -> [MIDI.Event] {
            MIDI.Packet.PacketData(bytes: bytes, timeStamp: 0)
                .parsedEvents().events
        }
        
        // tests
        
        // data bytes (< 0x80) are meaningless without a status byte or Running Status
        for byte: MIDI.Byte in 0x00...0x7F {
            XCTAssertEqual(parsedEvents(bytes: [byte]), [])
        }
        
        // note off:
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x80, 0x3C]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(parsedEvents(bytes: [0x80, 0x3C, 0x40, 0x3C]),
                       [.noteOff(note: 0x3C, velocity: 0x40, channel: 0)])
        // valid running status
        XCTAssertEqual(parsedEvents(bytes: [0x80, 0x3C, 0x40, 0x3D, 0x41]),
                       [.noteOff(note: 0x3C, velocity: 0x40, channel: 0),
                        .noteOff(note: 0x3D, velocity: 0x41, channel: 0)])
        
        // note on:
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0x90]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x90, 0x3C]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(parsedEvents(bytes: [0x90, 0x3C, 0x40, 0x3C]),
                       [.noteOn(note: 0x3C, velocity: 0x40, channel: 0)])
        // valid running status
        XCTAssertEqual(parsedEvents(bytes: [0x90, 0x3C, 0x40, 0x3D, 0x41]),
                       [.noteOn(note: 0x3C, velocity: 0x40, channel: 0),
                        .noteOn(note: 0x3D, velocity: 0x41, channel: 0)])
        
        // poly aftertouch:
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0xA0]), [])
        XCTAssertEqual(parsedEvents(bytes: [0xA0, 0x3C]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(parsedEvents(bytes: [0xA0, 0x3C, 0x40, 0x3C]),
                       [.polyAftertouch(note: 0x3C, pressure: 0x40, channel: 0)])
        // valid running status
        XCTAssertEqual(parsedEvents(bytes: [0xA0, 0x3C, 0x40, 0x3D, 0x41]),
                       [.polyAftertouch(note: 0x3C, pressure: 0x40, channel: 0),
                        .polyAftertouch(note: 0x3D, pressure: 0x41, channel: 0)])
        
        // cc
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0xB0]), [])
        XCTAssertEqual(parsedEvents(bytes: [0xB0, 0x3C]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(parsedEvents(bytes: [0xB0, 0x3C, 0x40, 0x3C]),
                       [.cc(controller: 0x3C, value: 0x40, channel: 0)])
        // valid running status
        XCTAssertEqual(parsedEvents(bytes: [0xB0, 0x3C, 0x40, 0x3D, 0x41]),
                       [.cc(controller: 0x3C, value: 0x40, channel: 0),
                        .cc(controller: 0x3D, value: 0x41, channel: 0)])
        
        // program change
        // requires one data byte to follow
        XCTAssertEqual(parsedEvents(bytes: [0xC0]), [])
        // valid event
        XCTAssertEqual(parsedEvents(bytes: [0xC0, 0x3C]),
                       [.programChange(program: 0x3C, channel: 0)])
        // valid running status
        XCTAssertEqual(parsedEvents(bytes: [0xC0, 0x3C, 0x3D]),
                       [.programChange(program: 0x3C, channel: 0),
                        .programChange(program: 0x3D, channel: 0)])
        
        // channel aftertouch
        // requires one data byte to follow
        XCTAssertEqual(parsedEvents(bytes: [0xD0]), [])
        // valid event
        XCTAssertEqual(parsedEvents(bytes: [0xD0, 0x3C]),
                       [.chanAftertouch(pressure: 0x3C, channel: 0)])
        // valid running status
        XCTAssertEqual(parsedEvents(bytes: [0xD0, 0x3C, 0x3D]),
                       [.chanAftertouch(pressure: 0x3C, channel: 0),
                        .chanAftertouch(pressure: 0x3D, channel: 0)])
        
        // pitch bend
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0xE0]), [])
        XCTAssertEqual(parsedEvents(bytes: [0xE0, 0x00]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(parsedEvents(bytes: [0xE0, 0x00, 0x40, 0x01]),
                       [.pitchBend(value: 8192, channel: 0)])
        // valid running status
        XCTAssertEqual(parsedEvents(bytes: [0xE0, 0x00, 0x40, 0x01, 0x40]),
                       [.pitchBend(value: 8192, channel: 0),
                        .pitchBend(value: 8193, channel: 0)])
        
        // SysEx start
        // [0xF0, ... variable number of SysEx bytes]
        XCTAssertEqual(parsedEvents(bytes: [0xF0]), [])
        
        // System Common - timecode quarter-frame
        // [0xF1, byte]
        XCTAssertEqual(parsedEvents(bytes: [0xF1]), [])
        
        // System Common - Song Position Pointer
        // [0xF2, lsb byte, msb byte]
        XCTAssertEqual(parsedEvents(bytes: [0xF2]), [])
        XCTAssertEqual(parsedEvents(bytes: [0xF2, 0x08]), [])
        // not technically compatible with Running Status
        XCTAssertEqual(parsedEvents(bytes: [0xF2, 0x08, 0x00, 0x09, 0x00]),
                       [.songPositionPointer(midiBeat: 8)])
        
        // System Common - Song Select
        // [0xF3, byte]
        XCTAssertEqual(parsedEvents(bytes: [0xF3]), [])
        // valid event
        XCTAssertEqual(parsedEvents(bytes: [0xF3, 0x3C]),
                       [.songSelect(number: 0x3C)])
        // not technically compatible with Running Status
        XCTAssertEqual(parsedEvents(bytes: [0xF3, 0x3C, 0x3D]),
                       [.songSelect(number: 0x3C)])
        
        // System Common - Undefined
        // [0xF4]
        // (undefined, not relevant to check in this test)
        
        // System Common - Undefined
        // [0xF5]
        // (undefined, not relevant to check in this test)
        
        // System Common - Tune Request
        // [0xF6]
        // single status byte message, not relevant to check in this test
        
        // System Common - System Exclusive End (EOX / End Of Exclusive)
        // [0xF7]
        // on its own without context, it's meaningless/invalid
        XCTAssertEqual(parsedEvents(bytes: [0xF7]), [])
        
        // System Real Time - Timing Clock
        // [0xF8]
        // single status byte message, not relevant to check in this test
        
        // Real Time - Undefined
        // [0xF9]
        // (undefined, not relevant to check in this test)
        
        // System Real Time - Start
        // [0xFA]
        // single status byte message, not relevant to check in this test
        
        // System Real Time - Continue
        // [0xFB]
        // single status byte message, not relevant to check in this test
        
        // System Real Time - Stop
        // [0xFC]
        // single status byte message, not relevant to check in this test
        
        // System Real Time - Undefined
        // [0xFD]
        // (undefined, not relevant to check in this test)
        
        // System Real Time - Active Sensing
        // [0xFE]
        // single status byte message, not relevant to check in this test
        
        // System Real Time - System Reset
        // [0xFF]
        // single status byte message, not relevant to check in this test
        
    }
    
    func testMIDIPacketData_parsedEvents_SysEx() {
        
        // template method
        
        func parsedEvents(bytes: [MIDI.Byte]) -> [MIDI.Event] {
            MIDI.Packet.PacketData(bytes: bytes, timeStamp: 0)
                .parsedEvents().events
        }
        
        // tests
        
        // test SysEx termination conditions:
        // - 0xF7
        // - no termination byte
        // - new status byte
        
        // 0xF7 termination byte
        XCTAssertEqual(parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x34, 0xF7]),
                       [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x01, 0x34], group: 0)])
        
        // no termination byte
        XCTAssertEqual(parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x34]),
                       [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x01, 0x34], group: 0)])
        
        // new status byte (non-realtime)
        XCTAssertEqual(parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x34,
                                            0x90, 0x3C, 0x40]),
                       [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x01, 0x34], group: 0),
                        .noteOn(note: 60, velocity: 64, channel: 0, group: 0)])
        
        // system real time events are not a SysEx terminator, as the parser does not look ahead and assumes the SysEx could continue to receive data bytes
        XCTAssertEqual(parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x34,
                                            0xFE]),
                       [.activeSensing(group: 0),
                        .sysEx(manufacturer: .oneByte(0x41)!, data: [0x01, 0x34], group: 0)])
        
        // multiple SysEx messages in a single packet
        XCTAssertEqual(parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x02, 0xF7,   // 0xF7 termination
                                            0xF0, 0x42, 0x03, 0x04, 0xF7]), // 0xF7 termination
                       [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x01, 0x02], group: 0),
                        .sysEx(manufacturer: .oneByte(0x42)!, data: [0x03, 0x04], group: 0)])
        
        // multiple SysEx messages in a single packet
        XCTAssertEqual(parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x02,   // no 0xF7 termination
                                            0xF0, 0x42, 0x03, 0x04]), // 0xF0 acts as termination to 1st sysex
                       [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x01, 0x02], group: 0),
                        .sysEx(manufacturer: .oneByte(0x42)!, data: [0x03, 0x04], group: 0)])
        
        
    }
    
}
#endif
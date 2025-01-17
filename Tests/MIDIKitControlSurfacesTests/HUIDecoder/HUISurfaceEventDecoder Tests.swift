//
//  HUISurfaceEventDecoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitControlSurfaces

final class HUISurfaceEventDecoderTests: XCTestCase {
    /// Verifies that a HUI event encodes and decodes back to itself.
    func runHUIEventTest(
        _ sourceEvent: HUISurfaceEvent,
        matches outputEvents: [HUISurfaceEvent]? = nil
    ) {
        var decodedEvents: [HUISurfaceEvent] = []
        let decoder = HUISurfaceEventDecoder { huiEvent in
            decodedEvents.append(huiEvent)
        }
        let midiEvents = sourceEvent.encode()
        decoder.midiIn(events: midiEvents)
        
        let eventsToMatch = outputEvents ?? [sourceEvent]
        
        XCTAssertEqual(decodedEvents, eventsToMatch)
    }
    
    func testPing() {
        runHUIEventTest(.ping)
    }
    
    func testSwitch() {
        runHUIEventTest(
            .switch(huiSwitch: .channelStrip(2, .solo), state: true)
        )
    }
    
    func testFaderLevel() {
        runHUIEventTest(
            .faderLevel(channelStrip: 2, level: .midpoint)
        )
    }
    
    func testLevelMeter() {
        runHUIEventTest(
            .levelMeter(channelStrip: 2, side: .right, level: 8)
        )
    }
    
    func testVPot() {
        runHUIEventTest(
            .vPot(vPot: .editAssignA, delta: 4)
        )
    }
    
    func testJogWheel() {
        runHUIEventTest(
            .jogWheel(delta: -4)
        )
    }
    
    func testSystemReset() {
        runHUIEventTest(
            .systemReset
        )
    }
}

#endif

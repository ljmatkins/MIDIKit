//
//  HUISurfaceModel Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitControlSurfaces

final class HUISurfaceModelTests: XCTestCase {
    func testChannelStripsValidation() {
        var model = HUISurfaceModel()
        XCTAssertEqual(model.channelStrips.count, 8)
        
        // uses set { }
        model.channelStrips = [.init(), .init()]
        XCTAssertEqual(model.channelStrips.count, 8)
        
        // uses _modify { }
        _ = model.channelStrips.removeLast()
        XCTAssertEqual(model.channelStrips.count, 8)
        
        // uses _modify { }
        model.channelStrips.append(.init())
        XCTAssertEqual(model.channelStrips.count, 8)
    }
}

#endif

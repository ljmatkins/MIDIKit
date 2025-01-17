//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

/// Receiving MIDI happens as an asynchronous background callback. That means it cannot update
/// SwiftUI view state directly. Therefore, we need a helper class that conforms to
/// `ObservableObject` which contains `@Published` properties that SwiftUI can use to update views.
final class MIDIHelper: ObservableObject {
    private weak var midiManager: MIDIManager?
    
    public init() { }
    
    public func setup(midiManager: MIDIManager) {
        self.midiManager = midiManager
        
        midiManager.notificationHandler = { notification, manager in
            self.logNotification(notification)
        }
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    }
    
    // MARK: - Virtual Endpoints
    
    func addVirtualInput() {
        guard let midiManager = midiManager else { return }
        let name = UUID().uuidString
        // we don't care about received MIDI events for this example project
        try? midiManager.addInput(name: name, tag: name, uniqueID: .adHoc, receiver: .events({ _ in }))
    }
    
    func addVirtualOutput() {
        guard let midiManager = midiManager else { return }
        let name = UUID().uuidString
        // we won't be sending any events in this example project
        try? midiManager.addOutput(name: name, tag: name, uniqueID: .adHoc)
    }
    
    func removeVirtualInput() {
        guard let midiManager = midiManager else { return }
        guard let port = midiManager.managedInputs.randomElement() else { return }
        midiManager.remove(.input, .withTag(port.key))
    }
    
    func removeVirtualOutput() {
        guard let midiManager = midiManager else { return }
        guard let port = midiManager.managedOutputs.randomElement() else { return }
        midiManager.remove(.output, .withTag(port.key))
    }
    
    // MARK: - Log MIDI Notification
    
    func logNotification(_ notification: MIDIIONotification) {
        switch notification {
        case .setupChanged:
            print("Setup changed")
            
        case .added(let object, let parent):
            let objectDescription = description(for: object)
            let parentDescription = description(for: parent)
            print("Added: \(objectDescription), parent: \(parentDescription)")
            
        case .removed(let object, let parent):
            let objectDescription = description(for: object)
            let parentDescription = description(for: parent)
            print("Removed: \(objectDescription), parent: \(parentDescription)")
            
        case .propertyChanged(let property, let object):
            let objectDescription = description(for: object)
            let propertyValueDescription = object.propertyStringValue(for: property)
            print("Property Changed: \(property) for \(objectDescription) to \(propertyValueDescription)")
            
        case .thruConnectionChanged:
            // this notification carries no data
            print("Thru Connection Changed")
            
        case .serialPortOwnerChanged:
            // this notification carries no data
            print("Serial Port Owner Changed")
            
        case .ioError(let device, let error):
            print("I/O Error for device \(device.name): \(error)")
            
        case .other(let messageIDRawValue):
            print("Other with ID \(messageIDRawValue)")
        }
    }
    
    func description(for object: AnyMIDIIOObject?) -> String {
        guard let object = object else { return "nil" }
        
        switch object {
        case .device(let device):
            return "Device \(device) with \(device.entities.count) entities"
            
        case .entity(let entity):
            return "Entity \(entity) with \(entity.inputs.count) inputs and \(entity.outputs.count) outputs"
            
        case .inputEndpoint(let endpoint):
            return "Input Endpoint \"\(endpoint.name)\" with ID \(endpoint.uniqueID)"
            
        case .outputEndpoint(let endpoint):
            return "Output Endpoint \"\(endpoint.name)\" with ID \(endpoint.uniqueID)"
        }
    }
}

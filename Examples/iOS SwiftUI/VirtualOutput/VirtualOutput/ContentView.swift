//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

struct ContentView: View {
    @EnvironmentObject var midiManager: MIDIManager
    
    let virtualOutputName = "TestApp Output"
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("This example creates a virtual MIDI output port named \"TestApp Output\".")
                .multilineTextAlignment(.center)
            
            Button("Send Note On C3") {
                sendNoteOn()
            }
            
            Button("Send Note Off C3") {
                sendNoteOff()
            }
            
            Button("Send CC1") {
                sendCC1()
            }
        }
        .font(.system(size: 18))
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

extension ContentView {
    /// Convenience accessor for the created virtual MIDI Output.
    var virtualOutput: MIDIOutput? {
        midiManager.managedOutputs[virtualOutputName]
    }
    
    func sendNoteOn() {
        guard let output = virtualOutput else { return }
    
        try? output.send(
            event: .noteOn(
                60,
                velocity: .midi1(127),
                channel: 0
            )
        )
    }
    
    func sendNoteOff() {
        guard let output = virtualOutput else { return }
    
        try? output.send(
            event: .noteOff(
                60,
                velocity: .midi1(0),
                channel: 0
            )
        )
    }
    
    func sendCC1() {
        guard let output = virtualOutput else { return }
    
        try? output.send(
            event: .cc(
                1,
                value: .midi1(64),
                channel: 0
            )
        )
    }
}

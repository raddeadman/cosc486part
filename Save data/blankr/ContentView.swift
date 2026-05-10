//
//  ContentView.swift
//  blankr
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SaveDataDemoView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalNote.self, inMemory: true)
}

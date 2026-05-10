//
//  ContentView.swift
//  blankr
//

import SwiftData
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

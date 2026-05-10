//
//  blankrApp.swift
//  blankr
//

import SwiftData
import SwiftUI

@main
struct blankrApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: JournalNote.self)
        }
    }
}

//
//  SaveDataDemoView.swift
//  SwiftData persistence patterns from Apple's "Save data" tutorial series.
//

import SwiftData
import SwiftUI

@Model
final class JournalNote {
    var title: String
    var createdAt: Date

    init(title: String, createdAt: Date = .now) {
        self.title = title
        self.createdAt = createdAt
    }
}

struct SaveDataDemoView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalNote.createdAt, order: .reverse) private var notes: [JournalNote]
    @State private var draft = ""

    var body: some View {
        NavigationStack {
            List {
                if notes.isEmpty {
                    ContentUnavailableView(
                        "No notes yet",
                        systemImage: "note.text",
                        description: Text("Type a title and tap Save — data persists in the SwiftData store.")
                    )
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(notes) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.title)
                            Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteNotes)
                }
            }
            .navigationTitle("Saved notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") { saveDraft() }
                        .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .safeAreaInset(edge: .bottom) {
                TextField("New note title", text: $draft)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .background(.ultraThinMaterial)
            }
        }
    }

    private func saveDraft() {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        modelContext.insert(JournalNote(title: trimmed))
        draft = ""
    }

    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(notes[index])
        }
    }
}

#Preview {
    SaveDataDemoView()
        .modelContainer(for: JournalNote.self, inMemory: true)
}

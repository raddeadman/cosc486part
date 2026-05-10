//
//  ModelTypesDemoView.swift
//  Custom types & Codable — aligned with “Model data with custom types”.
//

import SwiftUI

enum SkillLevel: String, Codable, CaseIterable, Identifiable {
    case beginner
    case intermediate
    case advanced

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }
}

struct Course: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var durationHours: Double
    var level: SkillLevel
}

struct ModelTypesDemoView: View {
    @State private var courses: [Course] = [
        Course(id: "swift-ui", title: "SwiftUI Essentials", durationHours: 12, level: .beginner),
        Course(id: "data", title: "Modeling Data", durationHours: 8, level: .intermediate),
    ]

    @State private var jsonSnippet = "Tap “Encode JSON” for Codable output."

    var body: some View {
        NavigationStack {
            List {
                Section("Courses") {
                    ForEach(courses) { course in
                        NavigationLink(value: course) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(course.title)
                                Text("\(course.durationHours, specifier: "%g") h · \(course.level.title)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Encoding") {
                    Text(jsonSnippet)
                        .font(.caption.monospaced())
                        .textSelection(.enabled)
                    Button("Encode JSON") { encodeSample() }
                }
            }
            .navigationTitle("Custom types")
            .navigationDestination(for: Course.self) { course in
                CourseDetailView(course: course)
            }
        }
    }

    private func encodeSample() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let data = try encoder.encode(courses)
            jsonSnippet = String(decoding: data, as: UTF8.self)
        } catch {
            jsonSnippet = "Encode failed: \(error.localizedDescription)"
        }
    }
}

private struct CourseDetailView: View {
    let course: Course

    var body: some View {
        Form {
            Section("Properties") {
                LabeledContent("ID", value: course.id)
                LabeledContent("Title", value: course.title)
                LabeledContent("Duration (hours)", value: "\(course.durationHours, specifier: "%g")")
                LabeledContent("Level", value: course.level.title)
            }
        }
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ModelTypesDemoView()
}

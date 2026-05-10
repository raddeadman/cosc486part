//
//  NavigateSampleDataRootView.swift
//  Patterns from Apple's "Navigate sample data" (NavigationStack, typed navigation, sample models).
//

import SwiftUI

/// Sample model type used as navigation value (like tutorial sample arrays bound to `NavigationStack`).
struct Friend: Identifiable, Hashable {
    let id: String
    var name: String
    var hobby: String
}

private let sampleFriends: [Friend] = [
    Friend(id: "alex", name: "Alex", hobby: "Photography"),
    Friend(id: "sam", name: "Sam", hobby: "Climbing"),
    Friend(id: "jordan", name: "Jordan", hobby: "SwiftUI"),
]

struct NavigateSampleDataRootView: View {
    var body: some View {
        NavigationStack {
            List(sampleFriends) { friend in
                NavigationLink(value: friend) {
                    VStack(alignment: .leading) {
                        Text(friend.name)
                        Text(friend.hobby)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Friends")
            .navigationDestination(for: Friend.self) { friend in
                FriendDetailView(friend: friend)
            }
        }
    }
}

private struct FriendDetailView: View {
    let friend: Friend

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(friend.name)
                .font(.largeTitle.bold())
            LabeledContent("Hobby", value: friend.hobby)
            Text("This screen is pushed via `navigationDestination(for:)` using the selected model value.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .navigationTitle(friend.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigateSampleDataRootView()
}

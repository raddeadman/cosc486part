//
//  ViewController.swift
//

import SwiftData
import SwiftUI
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let container = try ModelContainer(for: JournalNote.self)
            let root = SaveDataDemoView().modelContainer(container)
            let hosting = UIHostingController(rootView: root)
            addChild(hosting)
            hosting.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(hosting.view)
            NSLayoutConstraint.activate([
                hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
                hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
            hosting.didMove(toParent: self)
        } catch {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "Could not open SwiftData store: \(error.localizedDescription)"
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            ])
        }
    }
}

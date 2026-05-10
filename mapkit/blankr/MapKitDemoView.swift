//
//  MapKitDemoView.swift
//  Concepts from “Integrating MapKit with SwiftUI” (Hacking with Swift).
//

import MapKit
import SwiftUI

private struct MapLocation: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapKitDemoView: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )

    @State private var mapStyleChoice = 0
    @State private var interactionChoice = 0
    @State private var lastTapDescription = "Tap the map…"

    private let locations: [MapLocation] = [
        MapLocation(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        MapLocation(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076)),
    ]

    private let customAnnotationCoordinate = CLLocationCoordinate2D(latitude: 51.5033, longitude: -0.1196)

    var body: some View {
        VStack(spacing: 0) {
            controlPanel

            MapReader { proxy in
                Map(position: $position, interactionModes: currentInteractionModes) {
                    ForEach(locations) { location in
                        Marker(location.name, coordinate: location.coordinate)
                    }
                    Annotation("Custom", coordinate: customAnnotationCoordinate) {
                        Text("Custom pin")
                            .font(.caption)
                            .padding(6)
                            .background(.orange.opacity(0.9))
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                    .annotationTitles(.hidden)
                }
                .onMapCameraChange(frequency: MapCameraUpdateFrequency.continuous) { _ in }
                .mapStyle(currentMapStyle)
                .onTapGesture { tapPosition in
                    if let coordinate = proxy.convert(tapPosition, from: .local) {
                        lastTapDescription = String(
                            format: "(%.4f, %.4f)",
                            coordinate.latitude,
                            coordinate.longitude
                        )
                    }
                }
            }
            .frame(maxHeight: .infinity)

            Text("Last tap (lat, lon): \(lastTapDescription)")
                .font(.caption)
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
    }

    private var controlPanel: some View {
        VStack(spacing: 8) {
            Picker("Style", selection: $mapStyleChoice) {
                Text("Standard").tag(0)
                Text("Imagery").tag(1)
                Text("Hybrid").tag(2)
                Text("Hybrid 3D").tag(3)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Picker("Interaction", selection: $interactionChoice) {
                Text("All").tag(0)
                Text("Rotate+Zoom").tag(1)
                Text("None").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            HStack(spacing: 24) {
                Button("Paris") {
                    position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        )
                    )
                }
                Button("Tokyo") {
                    position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        )
                    )
                }
                Button("London") {
                    position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        )
                    )
                }
            }
            .buttonStyle(.bordered)
        }
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }

    private var currentMapStyle: MapStyle {
        switch mapStyleChoice {
        case 1: return .imagery
        case 2: return .hybrid
        case 3: return .hybrid(elevation: .realistic)
        default: return .standard
        }
    }

    private var currentInteractionModes: MapInteractionModes {
        switch interactionChoice {
        case 1: return [.rotate, .zoom]
        case 2: return []
        default: return .all
        }
    }
}

#Preview {
    MapKitDemoView()
}

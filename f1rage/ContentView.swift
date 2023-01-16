//
//  ContentView.swift
//  f1rage
//
//  Created by Dušky Papulák on 16/01/2023.
//

import SwiftUI

struct MainView: View {
    @State private var drivers: [Driver] = []
    @State private var circuits: [Circuit] = []
    @State private var selectedView: String = "drivers" // "drivers" or "circuits"

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.selectedView = "drivers"
                }) {
                    Text("Drivers")
                        .font(.headline)
                        .foregroundColor(self.selectedView == "drivers" ? .black : .gray)
                }
                Spacer()
                Button(action: {
                    self.selectedView = "circuits"
                }) {
                    Text("Circuits")
                        .font(.headline)
                        .foregroundColor(self.selectedView == "circuits" ? .black : .gray)
                }
            }
            .padding()
            if selectedView == "drivers" {
                List(drivers, id: \.driverId) { driver in
                    VStack(alignment: .leading) {
                        Text("\(driver.givenName) \(driver.familyName)")
                        Text(driver.nationality)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onAppear {
                    let apiHandler = APIHandler()
                    apiHandler.fetchData(endpoint: "drivers") { result in
                        switch result {
                        case .success(let MRData):
                            if let driverTable = MRData.DriverTable {
                                self.drivers = driverTable.Drivers
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                List(circuits, id: \.circuitId) { circuit in
                    VStack(alignment: .leading) {
                        Text(circuit.circuitName)
                        Text(circuit.Location.locality)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onAppear {
                    let apiHandler = APIHandler()
                    apiHandler.fetchData(endpoint: "circuits") { result in
                        switch result {
                        case .success(let MRData):
                            if let circuitTable = MRData.CircuitTable {
                                self.circuits = circuitTable.Circuits
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
static var previews: some View {
MainView()
}
}

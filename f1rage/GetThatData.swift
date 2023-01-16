import Foundation
import SwiftUI

struct MRData: Codable {
    let CircuitTable: CircuitTable?
    let DriverTable: DriverTable?
}

struct CircuitTable: Codable {
    let season: String
    let Circuits: [Circuit]
}

struct Circuit: Codable {
    let circuitId: String
    let url: String
    let circuitName: String
    let Location: CircuitLocation
}

struct CircuitLocation: Codable {
    let locality: String
    let country: String
    let lat: String
    let long: String
}

struct DriverTable: Codable {
    let Drivers: [Driver]
}

struct Driver: Codable {
    let driverId: String
    let givenName: String
    let familyName: String
    let nationality: String
    let dateOfBirth: String
    let url: String
}

class APIHandler {
    enum APIError: Error {
        case noData
        case invalidResponse
        case serverError(code: Int)
    }

    func fetchData(endpoint: String, completion: @escaping (Result<MRData, Error>) -> Void) {
        let url = URL(string: "https://ergast.com/api/f1/\(endpoint).json?limit=1000&offset=0")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }

            if httpResponse.statusCode != 200 {
                completion(.failure(APIError.serverError(code: httpResponse.statusCode)))
                return
            }
            do {
                let MRData = try JSONDecoder().decode(MRData.self, from: data)
                completion(.success(MRData))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}

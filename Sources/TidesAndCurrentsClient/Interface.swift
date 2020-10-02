//
//  Tides
//
//  Created by Erik Tollefsrud on 9/14/20.
//

import Combine
import Foundation

public struct TidesClient {
    public var stations: () -> AnyPublisher<[Station], Failure>
    public var tidePredictionData: (Int) -> AnyPublisher<TidePredictions, Failure>
    
    public struct Failure: Error, Equatable {
        public init() {}
    }
    
    public init(
        stations: @escaping () -> AnyPublisher<[Station], Failure>,
        tidePredictionData: @escaping (Int) -> AnyPublisher<TidePredictions, Failure>
    ) {
        self.stations = stations
        self.tidePredictionData = tidePredictionData
    }
}

public struct StationLocations: Decodable {
    public init(count: Int, stations: [Station]) {
        self.count = count
        self.stations = stations
    }
    
    public let count: Int
    public let stations: [Station]
}

public struct Station: Decodable, Equatable, Identifiable {
    
    public let id: Int
    public let name: String
    public let state: String
    public let latitude: Double
    public let longitude: Double
    
    public init(id: Int, name: String, state: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        let id = Int(idString)!
        
        let name = try container.decode(String.self, forKey: .name)
        
        let state = try container.decode(String.self, forKey: .state)
        
        let latitude = try container.decode(Double.self, forKey: .latitude)

        let longitude = try container.decode(Double.self, forKey: .longitude)
        
        self.init(id: id, name: name, state: state, latitude: latitude, longitude: longitude)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case state
        case latitude = "lat"
        case longitude = "lng"
    }
}

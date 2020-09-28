//
//  Tides
//
//  Created by Erik Tollefsrud on 9/14/20.
//

import ComposableArchitecture
import Foundation

public struct TidesClient {
    public var stations: () -> Effect<[Station], Failure>
    
    public struct Failure: Error, Equatable {
        public init() {}
    }
    
    public init(
        stations: @escaping () -> Effect<[Station], Failure>
    ) {
        self.stations = stations
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

//public struct TidesClient {
//    public var tides: (Int) -> AnyPublisher<WaterLevelReading, Error>
//
//    public init(
//        tides: @escaping (Int) -> AnyPublisher<WaterLevelReading, Error>
//    ) {
//        self.tides = tides
//    }
//}

//public struct TidesClient {
//    public var allLocations: () -> Effect<[WaterStation], Failure>
//
//    public struct Failure: Error, Equatable {}
//}
//
//public struct WaterLevel {
//    let time: Date
//    let value: String
//    let sigma: String?
//    let flags: String
//    let qualityAssurance: String
//}
//
//extension TidesClient {
//
//}
//
//extension WaterLevel: Decodable {
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let timeString = try container.decode(String.self, forKey: .time)
//        let time = WaterLevel.formatter.date(from: timeString)!
//
//        let value = try container.decode(String.self, forKey: .value)
//        let sigma = try container.decode(String.self, forKey: .sigma)
//        let flags = try container.decode(String.self, forKey: .flags)
//        let qualityAssurance = try container.decode(String.self, forKey: .qualityAssurance)
//
//        self.init(time: time, value: value, sigma: sigma, flags: flags, qualityAssurance: qualityAssurance)
//    }
//    static let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        return formatter
//    }()
//
//    private enum CodingKeys: String, CodingKey {
//        case time = "t"
//        case value = "v"
//        case sigma = "s"
//        case flags = "f"
//        case qualityAssurance = "q"
//    }
//}
//
//public struct WaterStation: Decodable {
//    let id: Int
//    let name: String
//    let latitude: Double
//    let longitude: Double
//
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case latitude = "lat"
//        case longitude = "lon"
//    }
//
//    init(id: Int, name: String, latitude: Double, longitude: Double) {
//        self.id = id
//        self.name = name
//        self.latitude = latitude
//        self.longitude = longitude
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let idString = try container.decode(String.self, forKey: .id)
//        let id = Int(idString)!
//
//        let name = try container.decode(String.self, forKey: .name)
//
//        let latString = try container.decode(String.self, forKey: .latitude)
//        let latitude = Double(latString)!
//
//        let lonString = try container.decode(String.self, forKey: .longitude)
//        let longitude = Double(lonString)!
//
//        self.init(id: id, name: name, latitude: latitude, longitude: longitude)
//    }
//}
//
//public struct WaterLevelReading: Decodable {
//    let station: WaterStation
//    let data: [WaterLevel]
//
//    enum CodingKeys: String, CodingKey {
//        case station = "metadata"
//        case data
//    }
//}

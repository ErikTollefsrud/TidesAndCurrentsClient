//
//  Station.swift
//  
//
//  Created by Erik Tollefsrud on 4/30/21.
//

import Foundation

public struct Station: Codable, Equatable, Identifiable {
    public let id: String
    public let name: String
    public let state: String
    public let latitude: Double
    public let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case state
        case latitude = "lat"
        case longitude = "lng"
    }

    public init(id: String, name: String, state: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name.localizedCapitalized
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
    }

    //    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let id = try container.decode(String.self, forKey: .id)
//        let name = try container.decode(String.self, forKey: .name)
//        let state = try container.decode(String.self, forKey: .state)
//        let latitude = try container.decode(Double.self, forKey: .latitude)
//        let longitude = try container.decode(Double.self, forKey: .longitude)
//
//        self.init(id: id, name: name, state: state, latitude: latitude, longitude: longitude)
//    }
    
}


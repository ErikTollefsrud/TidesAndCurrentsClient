//
//  File.swift
//  
//
//  Created by Klajd Deda on 5/11/21.
//

import Foundation

public struct StationResponse: Codable, Equatable {
    public let count: Int
    public let stations: [Station]
    public let units: String?

    enum CodingKeys: String, CodingKey {
        case count
        case stations
        case units
    }
}

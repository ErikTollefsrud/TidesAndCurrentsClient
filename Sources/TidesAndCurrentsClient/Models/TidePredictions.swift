//
//  TidePredictions.swift
//  
//
//  Created by Erik Tollefsrud on 4/30/21.
//

import Foundation

public struct TidePredictions: Codable, Equatable {
    public var tides: [Tide] = [Tide]()

    enum CodingKeys: String, CodingKey {
        case tides = "predictions"
    }
    
    public init(tides: [Tide]) {
        self.tides = tides
    }
}

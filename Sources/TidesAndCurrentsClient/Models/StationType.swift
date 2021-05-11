//
//  File.swift
//  
//
//  Created by Klajd Deda on 5/10/21.
//

import Foundation

public enum StationType: String {
    case currentPredictions = "currentpredictions"
    case tidePredictions = "tidepredictions"
    case waterLevels = "waterlevels"
    case waterTemp = "watertemp"
    
    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "type", value: self.rawValue)]
    }
}

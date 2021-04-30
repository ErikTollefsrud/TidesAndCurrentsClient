//
//  TidePredictions.swift
//  
//
//  Created by Erik Tollefsrud on 4/30/21.
//

import Foundation

public struct TidePredictions: Decodable, Equatable {
    public var predictions: [Tide] = [Tide]()
    
    public init(predictions: [Tide]) {
        self.predictions = predictions
    }
}

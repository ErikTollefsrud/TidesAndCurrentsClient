//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 9/24/20.
//

import Combine
import Foundation


extension TidesClient {
    public static let mock = Self(
        stations: {
            return Just([
                Station(id: "12345678", name: "Station 1", state: "MN", latitude: 100.00, longitude: -100.00),
                Station(id: "87654321", name: "Station 2", state: "WI", latitude: 200.00, longitude: -200.00)
            ]).setFailureType(to: TidesClient.Failure.self)
            .eraseToAnyPublisher()
        }, tidePredictionData: { stationId in
            return Just(TidePredictions(predictions:
                                            [Tide(time: Date(), value: 10.0, type: .high)])
            ).setFailureType(to: TidesClient.Failure.self)
            .eraseToAnyPublisher()
            
        })
    
}

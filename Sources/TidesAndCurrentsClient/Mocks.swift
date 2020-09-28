//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 9/24/20.
//

import ComposableArchitecture
import Foundation


extension TidesClient {
    public static let mock = Self {        
        return Effect(value: [
            Station(id: 12345678, name: "Station 1", state: "MN", latitude: 100.00, longitude: -100.00),
            Station(id: 87654321, name: "Station 2", state: "WI", latitude: 200.00, longitude: -200.00)
        ]).eraseToEffect()
    }
}

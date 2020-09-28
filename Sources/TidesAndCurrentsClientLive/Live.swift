//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 9/14/20.
//

import ComposableArchitecture
import Foundation
import TidesAndCurrentsClient

extension TidesClient {
    public static let live = Self {
        let url = URL(string: "https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations.json?type=waterlevels")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            //.print()
            .map { data, _ in data }
            .decode(type: StationLocations.self, decoder: JSONDecoder())
            .mapError { _ in Failure() }
            .map { $0.stations }
            .eraseToEffect()
    }
}

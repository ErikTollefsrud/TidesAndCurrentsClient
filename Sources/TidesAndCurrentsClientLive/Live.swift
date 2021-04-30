//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 9/14/20.
//

import Combine
import Foundation
import TidesAndCurrentsClient

extension TideClient {
    public static let live = Self.init(
        fetchTidePredictionStations: {
            let apiRequest = NOAA_APIClient.fetchStations(.tidePredictions).request
            guard let url = apiRequest.url else { fatalError("Could not make url from apiRequest.")}
            
            return fetch(url)
                .mapError { NOAA_APIClientError(errorMsg: $0.localizedDescription, errorCode: 0)}
                .eraseToAnyPublisher()
        },
        fetch48HourTidePredictions: { stationID in
            let apiRequest = NOAA_APIClient.fetch48HourTidePredictions(stationID: stationID).request
            guard let url = apiRequest.url else { fatalError("Could not make url from apiRequest.")}
            
            return fetch(url)
                .mapError { NOAA_APIClientError.init(errorMsg: $0.localizedDescription, errorCode: 1)}
                .eraseToAnyPublisher()
        })
}

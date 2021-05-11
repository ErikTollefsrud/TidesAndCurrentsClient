//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 9/14/20.
//

import Combine
import Foundation
import TidesAndCurrentsClient
import Commons

extension TideClient {
    public static let live = Self.init(
        fetchTidePredictionStations: {
            let api = APIRequest.fetchStations(.tidePredictions)

            return api
                .dataTaskPublisher()
                .tryMap { try api.decode(StationResponse.self, from: $0) }
                .mapError { $0.apiError }
                .eraseToAnyPublisher()
        },
        fetch48HourTidePredictions: { stationID in
            let api = APIRequest.fetch48HourTidePredictions(stationID: stationID)

            return api
                .dataTaskPublisher()
                .tryMap { data in
                    Commons.log("bytes: \(String .init(data: data, encoding: .utf8) ?? "")")
                    return try api.decode(TidePredictions.self, from: data)
                }
                .mapError { $0.apiError }
                .eraseToAnyPublisher()
        })
}

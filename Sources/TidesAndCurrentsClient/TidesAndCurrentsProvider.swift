//
//  TidesAndCurrentsProvider.swift
//  
//
//  Created by Erik Tollefsrud on 3/29/21.
//

import Combine
import Foundation

// MARK: TidesAndCurrentsProvider
public struct TidesAndCurrentsProvider {
    
    /// Search for Stations that provide tide predictions.
    public var tidePredictionStations: () -> AnyPublisher<[Station]?, Never>
    public var nextTwoDaysOfPredictions: (_ stationID: String) -> AnyPublisher<TidePredictions?, Never>
    
    public init(
        tidePredictionStations: @escaping () -> AnyPublisher<[Station]?, Never>,
        nextTwoDaysOfPredictions: @escaping (_ stationID: String) -> AnyPublisher<TidePredictions?, Never>
    ) {
        self.tidePredictionStations = tidePredictionStations
        self.nextTwoDaysOfPredictions = nextTwoDaysOfPredictions
    }
}

private let dispatcher = TidesAndCurrentsDispatcher()

extension TidesAndCurrentsProvider {
    public static var live: TidesAndCurrentsProvider {
        .init(tidePredictionStations: {
            dispatcher.dispatch(request: TidesAndCurrentsRequest<[Station]?>.tidePredictionStations())
        }, nextTwoDaysOfPredictions: { stationID in
            dispatcher.dispatch(request: TidesAndCurrentsRequest<TidePredictions>.nextTwoDaysOfPredictions(for: stationID))
        }
)
    }
}

//
//  TidesAndCurrentsProvider.swift
//  
//
//  Created by Erik Tollefsrud on 3/29/21.
//

import Combine
import Foundation

public enum TideError: Error, Equatable {
    public static func == (lhs: TideError, rhs: TideError) -> Bool {
        // FIXME
        // this was a quick hack to allow TCA to compile
        return true
    }

    case parentError(Error)
    case foo
}

// MARK: TidesAndCurrentsProvider
public struct TidesAndCurrentsProvider {
    
    /// Search for Stations that provide tide predictions.
    public var tidePredictionStations: () -> AnyPublisher<[Station], TideError>
    public var nextTwoDaysOfPredictions: (_ stationID: String) -> AnyPublisher<TidePredictions, TideError>
    
    public init(
        tidePredictionStations: @escaping () -> AnyPublisher<[Station], TideError>,
        nextTwoDaysOfPredictions: @escaping (_ stationID: String) -> AnyPublisher<TidePredictions, TideError>
    ) {
        self.tidePredictionStations = tidePredictionStations
        self.nextTwoDaysOfPredictions = nextTwoDaysOfPredictions
    }
}

private let dispatcher = TidesAndCurrentsDispatcher()

extension TidesAndCurrentsProvider {
    public static var live: TidesAndCurrentsProvider {
        .init(tidePredictionStations: {
            dispatcher.dispatch(request: TidesAndCurrentsRequest<[Station]>.tidePredictionStations())
        }, nextTwoDaysOfPredictions: { stationID in
            dispatcher.dispatch(request: TidesAndCurrentsRequest<TidePredictions>.nextTwoDaysOfPredictions(for: stationID))
        }
)
    }
}

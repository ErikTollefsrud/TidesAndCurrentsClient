//
//  Tides
//
//  Created by Erik Tollefsrud on 9/14/20.
//

import Combine
import Foundation
import TidesAndCurrentsClient

public struct TideClient {
    public var fetchTidePredictionStations: () -> AnyPublisher<StationResponse, APIError>
    public var fetch48HourTidePredictions: (_ stationID: String) -> AnyPublisher<TidePredictions, APIError>
    
    public init(
        fetchTidePredictionStations: @escaping () -> AnyPublisher<StationResponse, APIError>,
        fetch48HourTidePredictions: @escaping ( _ stationID: String) -> AnyPublisher<TidePredictions, APIError>
    ) {
        self.fetchTidePredictionStations = fetchTidePredictionStations
        self.fetch48HourTidePredictions = fetch48HourTidePredictions
    }
}

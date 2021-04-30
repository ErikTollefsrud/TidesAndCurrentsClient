//
//  Tides
//
//  Created by Erik Tollefsrud on 9/14/20.
//

import Combine
import Foundation

public struct TideClient {
    public var fetchTidePredictionStations: () -> AnyPublisher<StationResponse, NOAA_APIClientError>
    public var fetch48HourTidePredictions: (_ stationID: String) -> AnyPublisher<TidePredictions, NOAA_APIClientError>
    
    public init(
        fetchTidePredictionStations: @escaping () -> AnyPublisher<StationResponse, NOAA_APIClientError>,
        fetch48HourTidePredictions: @escaping( _ stationID: String) -> AnyPublisher<TidePredictions, NOAA_APIClientError>
    ){
        self.fetchTidePredictionStations = fetchTidePredictionStations
        self.fetch48HourTidePredictions = fetch48HourTidePredictions
    }
}

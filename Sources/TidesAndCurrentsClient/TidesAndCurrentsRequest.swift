//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 3/22/21.
//

import Combine
import Foundation

struct TidesAndCurrentsRequest<DataType> {
    enum BaseURL: String {
        case meta = "https://api.tidesandcurrents.noaa.gov/mdapi/"
        case station = "https://api.tidesandcurrents.noaa.gov/api/"
    }
    
    let baseURL: BaseURL
    var path: String {
        switch baseURL {
        case .meta:
            return "prod/webapi/stations.json"
        case .station:
            return "prod/datagetter"
        }
    }
    let parameters: [String: String]
    let decode: (Data) -> DataType?
}


extension TidesAndCurrentsRequest {
    static func dailyHighLowTide(stationID: String) -> TidesAndCurrentsRequest<TidePredictions> {
        .init(baseURL: .station, parameters: [
            "begin_date" : "20210323",
            "end_date" : "20210324",
            "station" : stationID,
            "product" : "predictions",
            "datum" : "mllw",
            "units" : "english",
            "time_zone" : "gmt",
            "application" : "TidesAndCurrentsApp",
            "format" : "json",
            "interval" : "hilo"
        ], decode: { try? JSONDecoder().decode(TidePredictions.self, from: $0)}
)
    }
    
    static func nextTwoDaysOfPredictions(for stationID: String) -> TidesAndCurrentsRequest<TidePredictions> {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyyMMdd"
            return formatter
        }()
        let todayString = formatter.string(from: Date())
        let endDate = formatter.string(from: Date().addingTimeInterval(172_800))
        
        return .init(
            baseURL: .station,
            parameters: [
                "product" : "predictions",
                "application" : "TidesAndCurrentsApp",
                "begin_date" : todayString,
                "end_date" : endDate,
                "datum" : "mllw",
                "units" : "english",
                "station" : stationID,
                "time_zone" : "lst_ldt",
                "interval" : "hilo",
                "format" : "json"
            ],
            decode: { try? JSONDecoder().decode(TidePredictions.self, from: $0)})
    }
    
    static func tidePredictionStations() -> TidesAndCurrentsRequest<[Station]> {
        .init(
            baseURL: .meta,
            parameters: [
                "type" : "tidepredictions"
            ],
            decode: {
                do {
                    let response = try JSONDecoder().decode(StationResponse.self, from: $0)
                    return response.stations as [Station]
                } catch {
                    //let output = String.init(data: $0, encoding: .utf8)
                    print("Decode Error: \(error)\nData:\($0)")
                    //print("Output: \(output)")
                    return nil
                }
                
            })
    }
}

//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 4/29/21.
//

import Combine
import Foundation

public enum NOAA_APIClient {
    public enum StationType: String {
        case currentPredictions = "currentpredictions"
        case tidePredictions = "tidepredictions"
        case waterLevels = "waterlevels"
        case waterTemp = "watertemp"
        
        var queryItems: [URLQueryItem] {
            get {
                [URLQueryItem(name: "type", value: self.rawValue)]
            }
        }
    }
    
    case fetchStations(StationType)
    case fetch48HourTidePredictions(stationID: String)
    
    // Not implemented yet, but I'd like to eventually make this API call
    // to get nearby stations of the one selected (a way to look up and down the coast)
    // https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations/9414290/nearby.json?radius=3
    //case nearbyStationsTo(stationID: String, distance: Int) //
    
    public var request: URLRequest {
        get {
            return URLRequest(url: self.url())
        }
    }
    
    func endpoint() -> String {
        let base = "https://api.tidesandcurrents.noaa.gov"
        
        switch self {
        case .fetchStations(_):
            return "\(base)/mdapi/prod/webapi/stations.json"
        case .fetch48HourTidePredictions(_):
            return "\(base)/api/prod/datagetter"
        }
    }
    
    func url() -> URL {
        switch self {
        case let .fetchStations(stationType):
            var components = URLComponents(string: self.endpoint())!
            components.queryItems = stationType.queryItems
            guard let url = components.url else { fatalError("Could not construct fetchStation url")}
            return url
        
        case let .fetch48HourTidePredictions(stationID: stationID):
            let formatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyyMMdd"
                return formatter
            }()
            let todayString = formatter.string(from: Date())
            let endDate = formatter.string(from: Date().addingTimeInterval(172_800))
            
            var components = URLComponents(string: self.endpoint())!
            
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "station", value: stationID))
            queryItems.append(URLQueryItem(name: "begin_date", value: todayString))
            queryItems.append(URLQueryItem(name: "end_date", value: endDate))
            let _ = URLQueryItem.defaultTideQueryItems.map { queryItems.append($0) }
            
            components.queryItems = queryItems
            
            guard let url = components.url else { fatalError("Could not construct fetch48HourTidePredictions url")}
            
            return url
        }
    }
}

public struct NOAA_APIClientError: Error, Decodable, Equatable {
    public var errorMsg: String
    public var errorCode: Int
    
    public init(errorMsg: String, errorCode: Int) {
        self.errorMsg = errorMsg
        self.errorCode = errorCode
    }
}

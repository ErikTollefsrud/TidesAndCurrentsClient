//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 4/29/21.
//

import Combine
import Foundation
import Commons

public enum APIRequest {
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    public enum Scheme: String {
        case http = "http"
        case https = "https"
    }
    
    case fetchStations(StationType)
    case fetchStationsBad(StationType)
    case fetch48HourTidePredictions(stationID: String)
    
    public var apiScheme: Scheme {
        switch self {
        default: return .https
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .fetchStations: return .get
        case .fetchStationsBad: return .get
        case .fetch48HourTidePredictions: return .get
        }
    }
    
    public var baseURL: URL {
        return URL(fileURLWithPath: "https://api.tidesandcurrents.noaa.gov")
    }
    
    public var relativePath: String {
        switch self {
        case .fetchStations: return "mdapi/prod/webapi/stations.json"
        case .fetchStationsBad: return "mdapi/prod/webapi/s_will_fail_tations.json"
        case .fetch48HourTidePredictions: return "api/prod/datagetter"
        }
    }
    
    // Not implemented yet, but I'd like to eventually make this API call
    // to get nearby stations of the one selected (a way to look up and down the coast)
    // https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations/9414290/nearby.json?radius=3
    //case nearbyStationsTo(stationID: String, distance: Int) //
    
    public var completeURL: URL {
        return baseURL
            .appendingPathComponent(relativePath)
            .appending(queryItems: queryItems)
    }
    
    /**
     For  now (simplicity) we manage caching outside this
     But feel free to go crazy here
     */
    public var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
    
    public var timeout: TimeInterval {
        return 3.0
    }
    
    /**
     Return the json encoded data for the httpBody
     Typically for POST requests
     */
    public var httpBody: Data {
        switch self {
        case .fetchStations:
            return Data()
            
        case .fetchStationsBad:
            return Data()
            
        case .fetch48HourTidePredictions:
            return Data()
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case let .fetchStations(stationType):
            return stationType.queryItems
            
        case let .fetchStationsBad(stationType):
            return stationType.queryItems
            
        case let .fetch48HourTidePredictions(stationID):
            let formatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyyMMdd"
                return formatter
            }()
            let todayString = formatter.string(from: Date())
            let endDate = formatter.string(from: Date().addingTimeInterval(172_800))
            var queryItems: [URLQueryItem] = URLQueryItem.defaultTideQueryItems
            
            queryItems.append(URLQueryItem(name: "station", value: stationID))
            queryItems.append(URLQueryItem(name: "begin_date", value: todayString))
            queryItems.append(URLQueryItem(name: "end_date", value: endDate))
            
            return queryItems
        }
    }
    
    /**
     Each API could use it's own encoder/decoder
     */
    public var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    public var decoder: JSONDecoder {
        switch self {
        case .fetchStations:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
            
        case .fetchStationsBad:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
            
        case .fetch48HourTidePredictions(stationID: let stationID):
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let formatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                //formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.dateFormat = "yyyy-MM-dd HH:mm"

                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)
                let date = formatter.date(from: dateStr) ?? Date.distantPast
//                // possible date strings: "2016-05-01",  "2016-07-04T17:37:21.119229Z", "2018-05-20T15:00:00Z"
//                let len = dateStr.count
//                var date: Date? = nil
//                if len == 10 {
//                    date = dateNoTimeFormatter.date(from: dateStr)
//                } else if len == 20 {
//                    date = isoDateFormatter.date(from: dateStr)
//                } else {
//                    date = self.serverFullDateFormatter.date(from: dateStr)
//                }
//                guard let date_ = date else {
//                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
//                }
                Commons.log("decode: '\(dateStr)' date: '\(date)'")
                return date
            })

            return decoder
        }
    }
    
    /**
     Short cut
     */
    private func _updateHeaders(request: inout URLRequest) {
        // request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        // not sure if we need to ask for 'charset=utf-8'
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.addValue(Configuration.authorization, forHTTPHeaderField: "Authorization")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.setValue(UUID().uuidString, forHTTPHeaderField: "MessageID")
        request.setValue("en-US", forHTTPHeaderField: "Accept-Language")
        // request.setValue(Bundle.userAgent, forHTTPHeaderField: "User-Agent")
    }
    
    // https://medium.com/flawless-app-stories/ignorance-of-the-urlrequest-cache-a3584bc2f05f
    // we do not want the URL to cache at this time
    public var urlRequest: URLRequest {
        var request = URLRequest(url: completeURL, cachePolicy: cachePolicy, timeoutInterval: timeout)
        
        Commons.log("url: '\(request.url?.absoluteString ?? "")'")
        // Commons.log("httpBody: '\(String(data: httpBody, encoding: .utf8) ?? "")'")
        
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        request.addValue("\(httpBody.count)", forHTTPHeaderField: "Content-Length")
        _updateHeaders(request: &request)
        request.cachePolicy = cachePolicy
        return request
    }
}

// MARK: - APIRequest (CustomStringConvertible)
/**
 Convenience to print the 'rawValue'
 */
extension APIRequest: CustomStringConvertible {
    public var description: String {
        switch self {
        case .fetchStations: return "fetchStations"
        case .fetchStationsBad: return "fetchStationsBad"
        case .fetch48HourTidePredictions: return "fetch48HourTidePredictions"
        }
    }
}

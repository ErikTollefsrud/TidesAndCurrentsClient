//
//  APIRequest+Publishers.swift
//  MarriottSwiftUI
//
//  Created by Klajd Deda on 12/23/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import Foundation
import Commons
import Combine
//import ComposableArchitecture

extension APIRequest {
    struct ServerError: Codable {
        var error: Bool
        var reason: String
    }
    /**
     just so we can identify each request
     */
    private var cacheFingerprint: String {
        switch self {
        case .fetchStations:
            return [StationType.currentPredictions.rawValue, StationType.tidePredictions.rawValue, StationType.waterLevels.rawValue,StationType.waterTemp.rawValue].joined(separator: ",")
            
        case .fetchStationsBad:
            return [StationType.currentPredictions.rawValue, StationType.tidePredictions.rawValue, StationType.waterLevels.rawValue,StationType.waterTemp.rawValue].joined(separator: ",")
            
        case let .fetch48HourTidePredictions(stationID):
            return [stationID].joined(separator: ",")
        }
    }

    // cacheURL will be different for each relativePath ie: http path as well as the httpBody, ie: what we are sending
    // this allows for the same APIRequest request 'case' but different http body to have different individual cache
    //
    private var cacheURL: URL {
        var fingerprint = completeURL.absoluteString.data(using: .utf8) ?? Data()

        fingerprint.append(cacheFingerprint.data(using: .utf8) ?? Data())
        let rv = URL.baseCacheURL
            .cacheURL(Data.self, from: relativePath)
            .deletingLastPathComponent()
            .appendingPathComponent(fingerprint.md5)
            .appendingPathExtension("bytes")

        return rv
    }

    private func updateCache(_ data: Data) -> Data {
        try? FileManager.default.createDirectory(
            at: self.cacheURL.deletingLastPathComponent(),
            withIntermediateDirectories: true,
            attributes: nil
        )
        try? data.write(to: self.cacheURL)

        Commons.log("api: '\(self)' cached: '\(data.count) bytes' on: '\(self.cacheURL.relativeCachePath)'")
        return data
    }

    public var cachedData: Data {
        (try? Data.init(contentsOf: cacheURL)) ?? Data()
    }

    public func removeCache() {
        try? FileManager.default.removeItem(at: cacheURL)
    }
    
    /**
     If there is cached data for this request publish it
     otherwise publish  data from remote URL
     */
    public func dataPublisher() -> AnyPublisher<Data, APIError> {
        let data = cachedData
        if !data.isEmpty {
            Commons.log("api: '\(self)' using cache from: '\(self.cacheURL.relativeCachePath)'")
            // 1) we got cached data from this request's url
            return Just(data)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        return dataTaskPublisher()
    }

    /**
     Publish  data from remote URL and update cached data
     */
    public func dataTaskPublisher() -> AnyPublisher<Data, APIError> {
        let urlRequest = self.urlRequest
        let fetchPath = urlRequest.url?.absoluteString ?? ""
        
        Commons.log("api: '\(self)' fetchPath: '\(fetchPath)'")
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            // .delay(for: APIRequest.delayTime, scheduler: DispatchQueue.global(), options: .none)
            .mapError { APIError.request(underlyingError: $0) }
            .tryMap { value -> Data in
                Commons.log("api: '\(self)' received: '\(value.data.count) bytes' from: '\(fetchPath)'")
                // Commons.log("json: ----\n\(String(data: value.data, encoding: .utf8) ?? "")\n --------")
                
                guard let response = value.response as? HTTPURLResponse,
                      (response.statusCode == 200 || response.statusCode == 207)
                else {
                    if !value.data.isEmpty {
                        // if you want to see what we are getting
                        // we could not parse the server error json
                        let jsonString = String(data: value.data, encoding: .utf8) ?? "uknown ..."
                        Commons.log("api: '\(self)' received server data error: '\(jsonString)'")
                        throw APIError.serverErrorData(value.data)
                    }
                    throw APIError.statusCode
                }
                return value.data
            }
            // cache the bytes ...
            .map(self.updateCache)
            .mapError { APIError.request(underlyingError: $0) }
            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
}

extension APIRequest {
    /**
     When we fail to parse this comes nifty since it will print the json error and the payload
     */
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            Commons.log("-------- -------- -------- -------- -------- -------- -------- --------")
            Commons.log("type: '\(String(reflecting: type))'")
            Commons.log("error: '\(error)'")
            Commons.log("json: ----\n\(String(data: data, encoding: .utf8) ?? "")\n --------")
            throw error
        }
    }
}

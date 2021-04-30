//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 4/30/21.
//

import Combine
import Foundation

/// Measurement Units
///
/// english: feet
/// metric: meters
public enum Units: String {
    case english = "english"
    case metric = "metric"
}

public enum Format {
    case json
    case xml
}

public func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { result in
            let decoder = JSONDecoder()
            guard let urlResponse = result.response as? HTTPURLResponse,
                  (200...299).contains(urlResponse.statusCode) else {
                let apiError = try decoder.decode(NOAA_APIClientError.self, from: result.data)
                throw apiError
            }
            return try decoder.decode(T.self, from: result.data)
        }
        .eraseToAnyPublisher()
}

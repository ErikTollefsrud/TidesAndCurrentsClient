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

extension URLQueryItem {
    public static let defaultTideQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "product", value: "predictions"),
        URLQueryItem(name: "application", value: "TidesAndCurrentsApp"),
        URLQueryItem(name: "datum", value: "mllw"),
        URLQueryItem(name: "units", value: Units.english.rawValue),
        URLQueryItem(name: "time_zone", value: "lst_ldt"),
        URLQueryItem(name: "interval", value: "hilo"),
        URLQueryItem(name: "format", value: "json")
    ]
}

//public func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
//    NSLog("url: \(url.absoluteString)")
//    return URLSession.shared.dataTaskPublisher(for: url)
//        .tryMap { result in
//            NSLog("received: '\(result.data.count)")
//
//            let decoder = JSONDecoder()
//            guard let urlResponse = result.response as? HTTPURLResponse,
//                  (200...299).contains(urlResponse.statusCode) else {
//                let apiError = try decoder.decode(APIError.self, from: result.data)
//                throw apiError
//            }
//            return try decoder.decode(T.self, from: result.data)
//        }
//        .subscribe(on: DispatchQueue.global())
//        .eraseToAnyPublisher()
//}

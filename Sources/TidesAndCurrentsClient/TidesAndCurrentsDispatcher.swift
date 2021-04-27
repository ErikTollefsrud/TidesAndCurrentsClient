//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 3/23/21.
//

import Combine
import Foundation

struct TidesAndCurrentsDispatcher {
    
    func dispatch<DataType>(request: TidesAndCurrentsRequest<DataType>) -> AnyPublisher<DataType, TideError> {
        let foo = URLSession.shared
            .dataTaskPublisher(for: URLRequest(from: request)) // chop below this line.
            .map { $0.data }
            .tryMap { try request.decode($0) }
            .mapError { TideError.parentError($0) }
            .eraseToAnyPublisher()
        return foo
    }
    
    // NOTE: Uncomment to do the dispatch but also see the HTTP response and output
    //    func dispatch<DataType>(request: TidesAndCurrentsRequest<DataType>) -> AnyPublisher<DataType?, Never> {
    //        return URLSession.shared.dataTaskPublisher(for: URLRequest(from: request))
    //            .map {
    //                print($0.response)
    //                let string = String.init(data: $0.data, encoding: .utf8)
    //                print(string)
    //                return request.decode($0.data)
    //            }
    //            .replaceError(with: nil)
    //            .eraseToAnyPublisher()
    //    }
}

extension URLRequest {
    init<DataType>(from tideAndCurrentRequest: TidesAndCurrentsRequest<DataType>) {
        let components = configure(URLComponents(string: tideAndCurrentRequest.baseURL.rawValue + tideAndCurrentRequest.path)!) {
            $0.queryItems = tideAndCurrentRequest.parameters.map(URLQueryItem.init)
        }
        self = URLRequest(url: components.url!)
    }
}

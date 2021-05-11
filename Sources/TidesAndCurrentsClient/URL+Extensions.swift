//
//  File.swift
//  
//
//  Created by Klajd Deda on 5/10/21.
//

import Foundation

// MARK: - URL (Extensions) -

public extension URL {
    func appendingQueryItem(name: String, value: String) -> URL {
        return appending(queryItems: [URLQueryItem(name: name, value: value)])
    }

    func appending(queryItem: URLQueryItem) -> URL {
        return appending(queryItems: [queryItem])
    }

    func appending(queryItems: [URLQueryItem]) -> URL {
        guard !queryItems.isEmpty,
              var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
            else { return self }

        var updatedItems = urlComponents.queryItems ?? [URLQueryItem]()

        updatedItems.append(contentsOf: queryItems)
        urlComponents.queryItems = updatedItems
        guard let rv = urlComponents.url
            else { return self }
        return rv
    }
}

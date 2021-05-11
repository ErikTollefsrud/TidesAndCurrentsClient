//
//  URL+Extensions.swift
//
//  Created by Klajd Deda on 7/1/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import Foundation

// MARK: - URL (Extensions)
// MARK: -

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

public extension String {
    static let kAFCharactersGeneralDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static let kAFCharactersSubDelimitersToEncode = "!$&'()*+,;="

    var percentEscapedString: String {
        var allowedCharacterSet = NSCharacterSet.urlUserAllowed
        allowedCharacterSet.remove(charactersIn: Self.kAFCharactersGeneralDelimitersToEncode + Self.kAFCharactersSubDelimitersToEncode)

        let escaped = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
//        // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
//        // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
//
//        static NSUInteger const batchSize = 50;
//
//        NSUInteger index = 0;
//        NSMutableString *escaped = @"".mutableCopy;
//
//        while (index < string.length) {
//            NSUInteger length = MIN(string.length - index, batchSize);
//            NSRange range = NSMakeRange(index, length);
//
//            // To avoid breaking up character sequences such as 👴🏻👮🏽
//            range = [string rangeOfComposedCharacterSequencesForRange:range];
//
//            NSString *substring = [string substringWithRange:range];
//            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
//            [escaped appendString:encoded];
//
//            index += range.length;
//        }

        return escaped ?? self
    }
}

public extension URLQueryItem {
    var percentEscaped: URLQueryItem {
        URLQueryItem(name: name, value: (value ?? "").percentEscapedString)
    }
}


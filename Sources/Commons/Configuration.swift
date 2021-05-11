//
//  Configuration.swift
//
//  Created by Klajd Deda on 12/22/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import Foundation


public struct Configuration {
    static private var infoDictionary: [String: Any] = {
        Bundle.main.infoDictionary ?? [String: Any]()
    }()

    public enum Key: String {
        case apiBaseUrl = "API_BASE_URL"
        case apiKey = "API_KEY"
        case accessToken = "ACCESS_TOKEN"
    }

    public static func value<T>(for key: Key) -> T? where T: LosslessStringConvertible {
        return infoDictionary[key.rawValue] as? T
    }

    public static func set<T>(_ value: T, for key: Key) where T: LosslessStringConvertible {
        return infoDictionary[key.rawValue] = value
    }

    public static var authorization: String {
        let value: String = Configuration.value(for: .apiKey) ?? ""
        let accessToken: String = Configuration.value(for: .accessToken) ?? ""
        var rv = "Basic \(value)"

        if !accessToken.isEmpty {
            rv += ", Bearer \(accessToken)"
        }
        return rv
    }

    public static var baseURL: URL {
        let value: String = Configuration.value(for: .apiBaseUrl) ?? ""
        return URL(string: "https://" + value)!
    }
}

//
//  UserDefaultsState.swift
//
//  Created by Klajd Deda on 11/28/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefaultsState<Value>: Equatable where Value: Equatable, Value: Codable {
    let key: String
    let defaultValue: Value
    var storage: UserDefaults = .standard

    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

    // if the value is nil return defaultValue
    // if the value empty return defaultValue
    // otherwise return the value
    //
    public var wrappedValue: Value {
        get {
            let value: Value? = storage.get(forKey: key)
            if let stringValue = value as? String, stringValue.isEmpty {
                // for string values we want to equate nil with empty string as well
                return defaultValue
            }
            return value ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}

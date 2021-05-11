//
//  UserDefaults.swift
//
//  Created by Klajd Deda on 11/28/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import Foundation

extension UserDefaults {
    // let value: Value already set somewhere
    // UserDefaults.standard.set(newValue, forKey: "foo")
    //
    func set<T>(_ value: T, forKey: String) where T: Encodable {
        do {
            let encoded = try JSONEncoder().encode(value)
            setValue(encoded, forKey: forKey)
        } catch {
            Commons.log("error: '\(error)'")
        }
    }

    // let value: Value? = UserDefaults.standard.get(forKey: "foo")
    //
    func get<T>(forKey: String) -> T? where T: Decodable {
        guard let data = value(forKey: forKey) as? Data,
            let decodedData = try? JSONDecoder().decode(T.self, from: data)
            else { return nil }
        return decodedData
    }
}

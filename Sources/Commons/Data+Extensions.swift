//
//  Data+Extensions.swift
//
//  Created by Klajd Deda on 1/16/21.
//  Copyright © 2021 id-design. All rights reserved.
//

import Foundation
import CommonCrypto
import CryptoKit

public extension Data {
    /**
     returns a unique fingerprint
     ie: 2E79D73C-EAB5-44E0-9DEC-75602872402E
     */
    var md5: String {
        let digest = Insecure.MD5.hash(data: self)
        var tokens = digest.map { String(format: "%02hhx", $0) }

        if tokens.count == 16 {
            tokens.insert("-", at: 4)
            tokens.insert("-", at: 7)
            tokens.insert("-", at: 10)
            tokens.insert("-", at: 13)

            if let uuid = UUID(uuidString: tokens.joined(separator: "").uppercased()) {
                return uuid.uuidString
            }
        }

        return tokens.joined(separator: "").uppercased()
    }
}

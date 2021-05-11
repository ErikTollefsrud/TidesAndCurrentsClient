//
//  File.swift
//  
//
//  Created by Klajd Deda on 5/10/21.
//

import Foundation
import Commons

public enum APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        // FIXME
        // this was a quick hack to allow TCA to compile
        return true
    }

    case statusCode
    case serverErrorData(Data)
    case request(underlyingError: Error)
    case unableToDecode(underlyingError: Error)

    public var errorCode: Int {
        switch self {
        case .statusCode: return 11_101
        case .serverErrorData: return 11_102
        case .request: return 11_103
        case .unableToDecode: return 11_104
        }
    }
}
 
extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .statusCode: return "The server returned and invalid status code"
            case let .serverErrorData(data): return String(data: data, encoding: .utf8) ?? "Unknown ..."
            case let .request(underlyingError): return underlyingError.localizedDescription
            case let .unableToDecode(underlyingError): return underlyingError.localizedDescription
        }
    }
}

extension Error {
    public var apiError: APIError {
        Commons.log("\n--------\nerror: \(self)\n--------------------------------")

        guard let apiError = self as? APIError
        else { return APIError.unableToDecode(underlyingError: self) }
        return apiError
    }
}

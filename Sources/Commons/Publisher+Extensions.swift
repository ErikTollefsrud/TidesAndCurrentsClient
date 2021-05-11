//
//  File.swift
//  
//
//  Created by Klajd Deda on 2/25/21.
//

import Foundation
import Combine

// https://jasdev.me/zip-many
//
public extension Publisher {
    func zip<Other: Publisher>(with others: [Other])
        -> AnyPublisher<[Output], Failure>
        where Other.Output == Output, Other.Failure == Failure {
        let initialResult = map { [$0] }.eraseToAnyPublisher()

        return others
            .reduce(initialResult) { zipped, next in
                zipped
                    .zip(next) /// (1) `([Output], Output)`.
                    .map { $0 + [$1] } /// (2) Restores `Array` value events by flattening the upstream tuple.
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

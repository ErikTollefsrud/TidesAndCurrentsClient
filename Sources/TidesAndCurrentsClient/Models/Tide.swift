//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 9/28/20.
//

import Foundation

public struct Tide: Codable, Equatable, Hashable {
    public var id: UUID = UUID()
    public var time: Date
    public var value: Double = 0.0
    public var type: TideType
    private var valueString: String  = "" {
        didSet {
            value = Double(self.valueString) ?? 0.0
        }
    }

    public enum TideType: String, Codable {
        case high = "H"
        case low = "L"
    }

    enum CodingKeys: String, CodingKey {
        case time = "t"
        case valueString = "v"
        case type
    }
    
    
    public init(
        time: Date,
        value: Double,
        type: Tide.TideType
    ) {
        //self.id = id
        self.time = time
        self.value = value
        self.type = type
    }

//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let timeString = try container.decode(String.self, forKey: .time)
//        let time = Tide.formatter.date(from: timeString)!
//
//        let valueString = try container.decode(String.self, forKey: .value)
//        let value = Double(valueString)
//
//        let typeString = try container.decode(String.self, forKey: .type)
//        let type = TideType.init(rawValue: typeString)
//
//        guard let unwrappedValue = value,
//              let unwrappedType = type else {
//            throw TideError.decodingError("Could not decode Tide struct from json")
//        }
//
//        self.init(time: time, value: unwrappedValue, type: unwrappedType)
//    }
//
//    static let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        //formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        return formatter
//    }()
//
    
    public enum TideError: Error {
        case decodingError(String)
    }
}

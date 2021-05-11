//
//  Color+Extensions.swift
//
//  Created by Klajd Deda on 2/15/21.
//

import Foundation
import SwiftUI


// experimental, trying to JSON the color ...
extension Color: Codable {
    static let knownColors = ["red": UIColor.red, "blue": UIColor.blue]
    enum CodingKeys: String, CodingKey {
        case colorDescription
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorDescription = (try? container.decode(String.self, forKey: .colorDescription)) ?? "clear"
        let uiColor: UIColor? = {
            let tokens = colorDescription.components(separatedBy: " ")
            if tokens.count == 1 {
                return Color.knownColors[colorDescription]
            } else if tokens.count == 5 {
                // UIExtendedSRGBColorSpace 0.1 0.2 0.3 1
                // let nameSpace = tokens.removeFirst() ?? "UIExtendedSRGBColorSpace"
                let rgba = tokens.map { Double($0) ?? 0 }.map { CGFloat($0) }

                return UIColor.init(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
            }
            return nil
        }()

        guard let honestUIColor = uiColor
        else { throw NSError(domain: "Commons", code: 42, userInfo: ["colorName": "colorDescription"] ) }
        self.init(honestUIColor)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.description, forKey: .colorDescription)
    }

}

public struct ColorTest {
    public init() {

    }

    public func testColors() {
        let colors: [Color] = [
            .red,
            .init(UIColor.init(red: 0.1, green: 0.2, blue: 0.3, alpha: 1)),
            .blue
        ]

        _ = colors.map { (color) -> Bool in
            let data = (try? JSONEncoder.init().encode(color)) ?? Data()
            let decodedColor = (try? JSONDecoder.init().decode(Color.self, from: data)) ?? Color.clear

            switch decodedColor == color {
                case true:
                    Commons.log("passed: \(String(data: data, encoding: .utf8) ?? "")")
                    return true
                case false:
                    Commons.log("failed: \(String(data: data, encoding: .utf8) ?? "")")
                    return false
            }
        }
    }
}

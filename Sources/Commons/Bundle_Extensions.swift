//
//  Bundle_Extensions.swift
//
//  Created by Klajd Deda on 7/10/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import Foundation
import SwiftUI


public extension Bundle {
    var version: String {
        guard let plist = Bundle.main.infoDictionary,
            let rv = plist["CFBundleShortVersionString"] as? String
            else { return "0.0.0" }
        
        return rv
    }
    
    var appIcon: UIImage {
        guard let plist = Bundle.main.infoDictionary,
            let icons = plist["CFBundleIcons"] as? [String: Any],
            let primaryIcons = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let primaryIconFiles = primaryIcons["CFBundleIconFiles"] as? [String],
            let iconFileName = primaryIconFiles.first,
            let rv = UIImage(named: iconFileName)
            else { return UIImage() }
        
        return rv
    }
    
    var buildNumber: String {
        guard let plist = Bundle.main.infoDictionary,
            let rv = plist["CFBundleVersion"] as? String
            else { return "1000" }
        
        return rv
    }

    static let userAgent: String = {
        let info = Bundle.main.infoDictionary ?? [String: Any]()
        let executable = info["CFBundleExecutable"] ?? "Marriott-SWIFTUI"
        let shortVersion = info["CFBundleShortVersionString"] ?? "0.0.0"
        let device = UIDevice.current.model
        let deviceVersion = "iOS \(UIDevice.current.systemVersion)"
        let scale = String(format: "Scale/%0.2f", UIScreen.main.scale)

        return "\(executable)/\(shortVersion) (\(device); \(deviceVersion); \(scale))"
    }()
}


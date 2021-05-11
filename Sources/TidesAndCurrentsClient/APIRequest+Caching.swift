//
//  DataCache.swift
//
//  Created by Klajd Deda on 7/9/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import Foundation
import Commons

public extension URL {
    static var baseCacheURL: URL = {
        var url = Bundle.main.resourceURL!.appendingPathComponent("DataCache")

        #if DEBUG
        let fileName = #file

        // this is a demo app
        // we want the cache base folder to be on the top level project folder
        // we can observe/studdy the cached files
        url = URL(fileURLWithPath: fileName)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("DataCache")
        #endif
        Commons.log("url: \(url.absoluteString)")
        return url
    }()


    var relativeCachePath: String {
        return path.replacingOccurrences(of: URL.baseCacheURL.path, with: "..")
    }
}

public extension Data {
    init?(fromCache relativePath: String) {
        let fileURL = URL.baseCacheURL
            .appendingPathComponent(relativePath)

        guard FileManager.default.fileExists(atPath: fileURL.path)
        else { return nil }
        guard let jsonData = try? Data(contentsOf: fileURL)
        else { return nil }

        self = jsonData
    }

    func store(relativePath: String) {
        let fileURL = URL.baseCacheURL
            .appendingPathComponent(relativePath)

        do {
            if !FileManager.default.fileExists(atPath: fileURL.deletingLastPathComponent().path) {
                try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            }
            try self.write(to: fileURL)
            Commons.log("wrote: '\(count) bytes' to: '\(fileURL.relativeCachePath)'")
        } catch {
            Commons.log("failed to write to: \(fileURL.path)")
            Commons.log("error: '\(error)'")
        }
    }
}

/**
 Simplistic implementation of a cache subsystem.
 The cache data backed by the file system
 Generic
 */
public extension URL {
    func cacheURL<T>(_ type: T.Type, from relativePath: String) -> URL {
        let typeName = String(describing: type)
        let fileName = "\(typeName).json".lowercased()
        return URL.baseCacheURL
            .appendingPathComponent(relativePath).appendingPathComponent(fileName)
    }
}

public extension JSONDecoder {
    func load<T>(_ type: T.Type, relativePath: String) -> T? where T : Decodable {
        return load(type, from: URL.baseCacheURL
                        .cacheURL(type, from: relativePath))
    }

    func load<T>(_ type: T.Type, from fileURL: URL) -> T? where T : Decodable {
        guard FileManager.default.fileExists(atPath: fileURL.path)
        else {
            Commons.log("file not found at: '\(fileURL.relativeCachePath)'")
            return nil }
        guard let jsonData = try? Data(contentsOf: fileURL)
        else {
            Commons.log("no data found at: '\(fileURL.relativeCachePath)'")
            return nil }

        do {
            return try decode(T.self, from: jsonData)
        } catch {
            Commons.log("error: '\(error)'")
        }
        Commons.log("no data at: '\(fileURL.relativeCachePath)'")
        return nil
    }
}

public extension JSONEncoder {
    static var storeJSONData: Bool = {
        return UserDefaults.standard.bool(forKey: "JSONEncoder.storeJSONData")
    }()

    func store<T: Codable>(_ modelObject: T, relativePath: String) {
        let fileURL = URL.baseCacheURL
            .cacheURL(type(of: modelObject), from: relativePath)
        return store(modelObject, fileURL: fileURL)
    }

    func store<T: Codable>(_ modelObject: T, fileURL: URL) {
//        guard Self.storeJSONData
//            else { return }

        let jsonData: Data = {
            do {
                return try self.encode(modelObject)
            } catch {
                Commons.log("error: '\(error)'")
            }
            return Data()
        }()

        do {
            if !FileManager.default.fileExists(atPath: fileURL.deletingLastPathComponent().path) {
                try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            }
            try jsonData.write(to: fileURL)
            Commons.log("wrote: '\(jsonData.count) bytes' to: '\(fileURL.relativeCachePath)'")
            // Commons.log("wrote: \(String(data: jsonData, encoding: .utf8) ?? "")")
        } catch {
            Commons.log("failed to write to: \(fileURL.path)")
            Commons.log("error: '\(error)'")
        }
    }
}

// https://stackoverflow.com/questions/60983230/how-to-properly-pull-from-cache-before-remote-using-swift-combine
//
//// MARK: - APIRequest (caching)
//
//extension APIRequestPublisher {
//    func cacheAsJson<Model: Codable>(_ model: Model) -> Model {
//        apiRequest.
//        encoder.store(model, relativePath: relativePath)
//        return model
//    }
//}
//

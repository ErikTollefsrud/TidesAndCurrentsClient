//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 9/14/20.
//

import Combine
import Foundation
import TidesAndCurrentsClient

extension TidesClient {
    public static let live = Self(
        stations: {
            let url = URL(string: "https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations.json?type=tidepredictions")!
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in data }
                .decode(type: StationLocations.self, decoder: JSONDecoder())
                .mapError { _ in Failure() }
                .map { $0.stations }
                .eraseToAnyPublisher()
        },
        tidePredictionData: { stationId in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let nowString = formatter.string(from: Date())
            
            let url = URL(string: "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?product=predictions&application=NOS.COOPS.TAC.WL&begin_date=\(nowString)&range=48&datum=MLLW&station=\(stationId)&time_zone=LST_LTD&units=english&interval=hilo&format=json)")!
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in data }
                .decode(type: TidePredictions.self, decoder: JSONDecoder())
                .mapError { _ in Failure() }
                .map { $0 }
                .eraseToAnyPublisher()
        })
}

import XCTest
@testable import TidesAndCurrentsClient
@testable import TidesAndCurrentsClientLive

final class TidesAndCurrentsClientTests: XCTestCase {

    
    func testStationResponseDecoder() throws {
        let jsonString = """
        {
          "count": 2,
          "units": null,
          "stations": [
            {
              "state": "HI",
              "tidepredoffsets": {
                "self": "https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations/1610367/tidepredoffsets.json"
              },
              "type": "S",
              "timemeridian": -150,
              "reference_id": "1612340",
              "timezonecorr": -10,
              "id": "1610367",
              "name": "Nonopapa, Niihau Island",
              "lat": 21.87,
              "lng": -160.235,
              "affiliations": "",
              "portscode": "",
              "products": null,
              "disclaimers": null,
              "notices": null,
              "self": null,
              "expand": null,
              "tideType": ""
            },
            {
              "state": "HI",
              "tidepredoffsets": {
                "self": "https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations/1611347/tidepredoffsets.json"
              },
              "type": "R",
              "timemeridian": -150,
              "reference_id": "1611400",
              "timezonecorr": -10,
              "id": "1611347",
              "name": "Port Allen, Hanapepe Bay",
              "lat": 21.9033,
              "lng": -159.592,
              "affiliations": "",
              "portscode": "",
              "products": null,
              "disclaimers": null,
              "notices": null,
              "self": null,
              "expand": null,
              "tideType": ""
            }
            ]
        }
        """
        
        let data = jsonString.data(using: .utf8)
        let response = try JSONDecoder().decode(StationResponse.self, from: data!)
        
        XCTAssertEqual(response.count, 2)
        
        let station1 = response.stations.first
        
        XCTAssertEqual(station1?.name, "Nonopapa, Niihau Island")
    }
    
    func testTidePredictionsDecoder() throws {
        let jsonString = """
        { "predictions" : [
            {"t":"2021-03-20 01:08", "v":"3.624", "type":"H"},
            {"t":"2021-03-20 06:45", "v":"0.811", "type":"L"},
            {"t":"2021-03-20 13:49", "v":"3.289", "type":"H"},
            {"t":"2021-03-20 18:54", "v":"0.750", "type":"L"},
            {"t":"2021-03-21 01:55", "v":"3.517", "type":"H"},
            {"t":"2021-03-21 07:44", "v":"1.049", "type":"L"},
            {"t":"2021-03-21 14:37", "v":"3.264", "type":"H"},
            {"t":"2021-03-21 19:55", "v":"0.902", "type":"L"}
        ]}
        """
                
        let data = jsonString.data(using: .utf8)

        let response = try JSONDecoder().decode(TidePredictions.self, from: data!)

        XCTAssertEqual(response.predictions.count, 8)
        XCTAssert(type(of: response.predictions.first) == Tide?.self)
        
    }
    
    func testTideDecode() throws {
        let jsonString = """
                        [
                            {"t":"2021-03-20 01:08", "v":"3.624", "type":"H"},
                            {"t":"2021-03-20 06:45", "v":"0.811", "type":"L"},
                            {"t":"2021-03-20 13:49", "v":"3.289", "type":"H"},
                            {"t":"2021-03-20 18:54", "v":"0.750", "type":"L"},
                            {"t":"2021-03-21 01:55", "v":"3.517", "type":"H"},
                            {"t":"2021-03-21 07:44", "v":"1.049", "type":"L"},
                            {"t":"2021-03-21 14:37", "v":"3.264", "type":"H"},
                            {"t":"2021-03-21 19:55", "v":"0.902", "type":"L"}
                        ]
                """
        
        let data = jsonString.data(using: .utf8)
        let response = try JSONDecoder().decode([Tide].self, from: data!)
        
        XCTAssertEqual(response.count, 8)
        XCTAssert(type(of: response) == Array<Tide>.self)
    }
    
    static var allTests = [
        ("testStationResponseDecoder", testStationResponseDecoder),
        ("testTidePredictionsDecoder", testTidePredictionsDecoder),
        ("testTideDecode", testTideDecode)
    ]
}

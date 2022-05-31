//
//  RepositoryMock.swift
//  WeatherForecastTests
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation

struct RepositoryMock: Repository {
    var result: Result<WeatherForecastData, DataRepositoryError>
    
    func fetchList(query: String, cached: @escaping ([WeatherForecastItem]) -> Void,
                   completion: @escaping (Result<WeatherForecastData, DataRepositoryError>) -> Void) -> NetworkCancellable? {
        //Mock cached
        let data = try? result.get()
        let items = data?.listItems ?? []
        cached(items)
        
        //Mock from API
        completion(result)
        return nil
    }
}

func MockJSONData() -> String {
    let json = """
    {
      "city": {
        "id": 1580578,
        "name": "Ho Chi Minh City",
        "coord": {
          "lon": 106.6667,
          "lat": 10.8333
        },
        "country": "VN",
        "population": 0,
        "timezone": 25200
      },
      "cod": "200",
      "message": 0.0702227,
      "cnt": 7,
      "list": [
        {
          "dt": 1653537600,
          "sunrise": 1653517797,
          "sunset": 1653563462,
          "temp": {
            "day": 31.19,
            "min": 26.17,
            "max": 32.97,
            "night": 26.83,
            "eve": 31.12,
            "morn": 26.48
          },
          "feels_like": {
            "day": 36.33,
            "night": 29.71,
            "eve": 36.73,
            "morn": 26.48
          },
          "pressure": 1007,
          "humidity": 64,
          "weather": [
            {
              "id": 501,
              "main": "Rain",
              "description": "moderate rain",
              "icon": "10d"
            }
          ],
          "speed": 4.23,
          "deg": 243,
          "gust": 9.97,
          "clouds": 95,
          "pop": 0.84,
          "rain": 9.68
        },
        {
          "dt": 1653624000,
          "sunrise": 1653604194,
          "sunset": 1653649878,
          "temp": {
            "day": 29.41,
            "min": 25.95,
            "max": 32.46,
            "night": 26.14,
            "eve": 29.18,
            "morn": 26.3
          },
          "feels_like": {
            "day": 33.64,
            "night": 26.14,
            "eve": 32.74,
            "morn": 26.3
          },
          "pressure": 1007,
          "humidity": 70,
          "weather": [
            {
              "id": 501,
              "main": "Rain",
              "description": "moderate rain",
              "icon": "10d"
            }
          ],
          "speed": 6.64,
          "deg": 260,
          "gust": 9.36,
          "clouds": 99,
          "pop": 0.97,
          "rain": 6.15
        },
        {
          "dt": 1653710400,
          "sunrise": 1653690593,
          "sunset": 1653736295,
          "temp": {
            "day": 29.73,
            "min": 25.11,
            "max": 29.74,
            "night": 25.53,
            "eve": 28.59,
            "morn": 25.11
          },
          "feels_like": {
            "day": 33.31,
            "night": 26.31,
            "eve": 31.53,
            "morn": 25.87
          },
          "pressure": 1008,
          "humidity": 65,
          "weather": [
            {
              "id": 500,
              "main": "Rain",
              "description": "light rain",
              "icon": "10d"
            }
          ],
          "speed": 7.37,
          "deg": 237,
          "gust": 9.55,
          "clouds": 43,
          "pop": 1,
          "rain": 4.27
        },
        {
          "dt": 1653796800,
          "sunrise": 1653776991,
          "sunset": 1653822711,
          "temp": {
            "day": 29.14,
            "min": 24.53,
            "max": 30.51,
            "night": 26.02,
            "eve": 28.9,
            "morn": 24.53
          },
          "feels_like": {
            "day": 32.47,
            "night": 26.02,
            "eve": 32.69,
            "morn": 25.28
          },
          "pressure": 1008,
          "humidity": 67,
          "weather": [
            {
              "id": 501,
              "main": "Rain",
              "description": "moderate rain",
              "icon": "10d"
            }
          ],
          "speed": 5.34,
          "deg": 270,
          "gust": 10.21,
          "clouds": 100,
          "pop": 1,
          "rain": 10.7
        },
        {
          "dt": 1653883200,
          "sunrise": 1653863391,
          "sunset": 1653909128,
          "temp": {
            "day": 30.68,
            "min": 25.12,
            "max": 32.94,
            "night": 26.72,
            "eve": 30.22,
            "morn": 25.12
          },
          "feels_like": {
            "day": 34.18,
            "night": 29.13,
            "eve": 34.13,
            "morn": 25.96
          },
          "pressure": 1007,
          "humidity": 60,
          "weather": [
            {
              "id": 500,
              "main": "Rain",
              "description": "light rain",
              "icon": "10d"
            }
          ],
          "speed": 5.88,
          "deg": 272,
          "gust": 10.49,
          "clouds": 97,
          "pop": 0.57,
          "rain": 0.14
        },
        {
          "dt": 1653969600,
          "sunrise": 1653949791,
          "sunset": 1653995544,
          "temp": {
            "day": 31.16,
            "min": 25.71,
            "max": 31.16,
            "night": 26.19,
            "eve": 28.56,
            "morn": 25.71
          },
          "feels_like": {
            "day": 35.45,
            "night": 26.19,
            "eve": 32.63,
            "morn": 26.58
          },
          "pressure": 1006,
          "humidity": 61,
          "weather": [
            {
              "id": 501,
              "main": "Rain",
              "description": "moderate rain",
              "icon": "10d"
            }
          ],
          "speed": 5.51,
          "deg": 228,
          "gust": 12.46,
          "clouds": 93,
          "pop": 1,
          "rain": 11.22
        },
        {
          "dt": 1654056000,
          "sunrise": 1654036192,
          "sunset": 1654081961,
          "temp": {
            "day": 29.24,
            "min": 25.26,
            "max": 30.01,
            "night": 25.37,
            "eve": 28,
            "morn": 25.26
          },
          "feels_like": {
            "day": 34.08,
            "night": 26.16,
            "eve": 31.36,
            "morn": 26.09
          },
          "pressure": 1007,
          "humidity": 74,
          "weather": [
            {
              "id": 501,
              "main": "Rain",
              "description": "moderate rain",
              "icon": "10d"
            }
          ],
          "speed": 6.33,
          "deg": 237,
          "gust": 11.09,
          "clouds": 100,
          "pop": 1,
          "rain": 14.09
        }
      ]
    }
    """
    
    return json
}

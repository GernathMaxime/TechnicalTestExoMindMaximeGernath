//
//  WeatherData.swift
//  TechnicalTestExoMindMaximeGernath
//
//  Created by Gernath Maxime on 15/10/2024.
//

import Foundation

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let main: Main
    let clouds: Clouds
    let name: String
    
    init(cityName: String, temperature: Double, cloudiness: Int) {
        self.name = cityName
        self.main = Main(temp: temperature)
        self.clouds = Clouds(all: cloudiness)
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    var all: Int
}

// MARK: - Main
struct Main: Codable {
    var temp: Double
}

enum CodingKeys: String, CodingKey {
    case name
    case main
    case clouds
}

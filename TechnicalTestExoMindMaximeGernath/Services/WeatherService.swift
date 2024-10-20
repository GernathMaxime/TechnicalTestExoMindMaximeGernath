//
//  WeatherService.swift
//  TechnicalTestExoMindMaximeGernath
//
//  Created by Gernath Maxime on 15/10/2024.
//

import Foundation
import Combine

class WeatherService {
    
    private let baseURL = Constants.API.baseURL
    private let apiKey = Constants.API.apiKey
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherData, Error> {
        guard let url = buildURL(for: city) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func buildURL(for city: String) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
        URLQueryItem(name: "q", value: city),
        URLQueryItem(name: "appid", value: apiKey),
        URLQueryItem(name: "units", value: "metric")
        ]
        return components?.url
    }
}

//
//  ProgressViewModel.swift
//  TechnicalTestExoMindMaximeGernath
//
//  Created by Gernath Maxime on 15/10/2024.
//

import Foundation
import Combine

class ProgressViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var progress: Double = 0.0
    @Published var currentMessage: String = ""
    @Published var weatherResults: [WeatherData] = []
    @Published var isLoading: Bool = true
    @Published var hasError: Bool = false
    
    private var timer: Timer?
    private var messageTimer: Timer?
    private var apiCallTimer: Timer?
    var cancellables = Set<AnyCancellable>()
    
    private let cities = Constants.Cities.cities
    private var currentCityIndex = 0
    private let messages = Constants.ProgressMessages.messages
    private var messageIndex = 0
    
    private let weatherService = WeatherService()
    
    func startProgression() {
        resetProgress()
        startProgressTimer()
        startMessageTimer()
        startAPICallTimer()
    }
    
    private func resetProgress() {
        progress = 0.0
        currentCityIndex = 0
        weatherResults.removeAll()
        hasError = false
        isLoading = true
    }
    
    private func startProgressTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.Timer.updateInterval,
            repeats: true,
            block: { [weak self] _ in
                guard let self = self else { return }
                self.progress += (100.0 / Constants.Timer.progressDuration)
                if self.progress >= 100 {
                    self.timer?.invalidate()
                    self.messageTimer?.invalidate()
                    self.apiCallTimer?.invalidate()
                    self.isLoading = false
                }
            })
    }
    
    private func startMessageTimer() {
        messageTimer = Timer.scheduledTimer(
            withTimeInterval: Constants.Timer.messageChangeInterval,
            repeats: true,
            block: { [weak self] _ in
                guard let self = self else { return }
                self.currentMessage = self.messages[self.messageIndex]
                self.messageIndex = (self.messageIndex + 1) % self.messages.count
            })
    }
    
    private func startAPICallTimer() {
        apiCallTimer = Timer.scheduledTimer(
            withTimeInterval: Constants.Timer.apiCallInternal,
            repeats: true,
            block: { [weak self] _ in
                guard let self = self else { return }
                self.fetchWeatherForCurrentCity()
            }
        )
    }
    
    private func fetchWeatherForCurrentCity() {
        let city = cities[currentCityIndex]
        
        weatherService.fetchWeather(for: city)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .failure:
                    self.hasError = true
                    self.apiCallTimer?.invalidate()
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] weatherData in
                guard let self = self else { return }
                self.weatherResults.append(
                    WeatherData(cityName: city,
                                temperature: weatherData.main.temp,
                                cloudiness: weatherData.clouds.all)
                )
                self.currentCityIndex += 1
                
                if self.currentCityIndex >= self.cities.count {
                    self.apiCallTimer?.invalidate()
                }
            })
            .store(in: &cancellables)
    }
    
    func restart() {
        startProgression()
    }
    
    deinit {
        timer?.invalidate()
        messageTimer?.invalidate()
        apiCallTimer?.invalidate()
    }
}

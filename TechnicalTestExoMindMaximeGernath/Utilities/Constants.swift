//
//  Constants.swift
//  TechnicalTestExoMindMaximeGernath
//
//  Created by Gernath Maxime on 15/10/2024.
//

import Foundation

struct Constants {
    
    struct API {
        static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        static let apiKey = "37c30f5613bf958818dc98b324fa93ed"
    }
    
    struct Cities {
        static let cities = [
        "Rennes",
        "Paris",
        "Nantes",
        "Bordeaux",
        "Lyon"
        ]
    }
    struct Timer {
        static let progressDuration: Double = 60.0
        static let updateInterval: Double = 1.0
        static let apiCallInternal: Double = 10.0
        static let messageChangeInterval: Double = 6.0
    }
    
    struct ProgressMessages {
        static let messages = [
        "Nous téléchargeons les données...",
        "C'est presque fini...",
        "Plus que quelques secondes avant d'avoir le résultat..."
        ]
    }
    
    struct ErrorMessages {
        static let apiError = "Impossible de récupérer les données météo. Veuillez réessayer."
        static let genericError = "Une erreur est survenue. Veuillez réessayer."
    }
    
    struct UIText {
        static let simpleText = "Un text"
        static let simpleButtonText = "Un bouton"
        static let progressBarText = "Regardez moi cette barre !"
        static let confirmationText = "ok"
        static let alert = "Erreur"
        static let restart = "Recommencer"
        static let resultsTitle = "Résultats de la météo"
    }
}

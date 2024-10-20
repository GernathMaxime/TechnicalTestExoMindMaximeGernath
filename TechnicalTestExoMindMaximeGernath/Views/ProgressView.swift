//
//  ProgressView.swift
//  TechnicalTestExoMindMaximeGernath
//
//  Created by Gernath Maxime on 15/10/2024.
//

import UIKit

class ProgressViewController: UIViewController {
    //MARK: - Properties
    
    private let viewModel = ProgressViewModel()
    
    lazy private var waitingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "waitingLabel_ProgressViewController"
        return label
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = "stackView_ProgressViewController"
        return stackView
    }()
    
    lazy private var buttonLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.UIText.progressBarText
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "buttonLabel_ProgressViewController"
        return label
    }()
    
    lazy private var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.accessibilityIdentifier = "progressBar_ProgressViewController"
        return progressView
    }()
    
    lazy private var restartButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.UIText.restart, for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(restartButtonSelector), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "sampleButton_ProgressViewController"
        return button
    }()
    
    lazy private var resultsTableView: WeatherResultView = {
        let tableView = WeatherResultView()
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "resultsTableView_ProgressViewController"
        return tableView
    }()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        viewModel.startProgression()
        
        self.setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = .white
        restartButton.layer.cornerRadius = 15
        restartButton.layer.masksToBounds = true
    }
}

//MARK: - Setup methods

extension ProgressViewController {
    private func setup() {
        setupInterface()
        setupConstraints()
    }
    
    private func setupInterface() {
        view.addSubview(waitingLabel)
        view.addSubview(resultsTableView)
        view.addSubview(restartButton)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(buttonLabel)
        stackView.addArrangedSubview(progressBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // waitingLabel
            waitingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            waitingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            waitingLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            waitingLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            // resultsTableView
            resultsTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            resultsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            // restartButton
            restartButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            // stackView
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }
    
    private func setupBindings() {
        viewModel.$progress.sink { [weak self] progress in
            DispatchQueue.main.async {
                self?.progressBar.setProgress(Float(progress / 100), animated: true)
            }
        }.store(in: &viewModel.cancellables)
        
        viewModel.$currentMessage.sink { [weak self] message in
            DispatchQueue.main.async {
                self?.waitingLabel.text = message
            }
        }.store(in: &viewModel.cancellables)
        
        viewModel.$isLoading.sink { [weak self] isLoading in
            DispatchQueue.main.async {
                if !isLoading {
                    self?.showResults()
                }
            }
        }.store(in: &viewModel.cancellables)
        
        viewModel.$hasError.sink { [weak self] hasError in
            DispatchQueue.main.async {
                if hasError {
                    DispatchQueue.main.async {
                        self?.showErrorAlert()
                    }
                }
            }
        }.store(in: &viewModel.cancellables)
    }
    
    private func showResults() {
        stackView.isHidden = true
        waitingLabel.isHidden = true
        resultsTableView.isHidden = false
        restartButton.isHidden = false
        resultsTableView.setWeatherData(viewModel.weatherResults)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: Constants.UIText.alert,
            message: Constants.ErrorMessages.apiError,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Constants.UIText.confirmationText, style: .default))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Selectors

extension ProgressViewController {
    @objc func restartButtonSelector() {
        stackView.isHidden = false
        waitingLabel.isHidden = false
        resultsTableView.isHidden = true
        restartButton.isHidden = true
        viewModel.restart()
    }
}

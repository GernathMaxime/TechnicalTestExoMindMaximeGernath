//
//  HomeView.swift
//  TechnicalTestExoMindMaximeGernath
//
//  Created by Gernath Maxime on 15/10/2024.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: - Properties
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = "stackView_HomeViewController"
        return stackView
    }()
    
    lazy private var simpleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.UIText.simpleText
        label.textAlignment = .center
        label.textColor = .black
        label.accessibilityIdentifier = "simpleLabel_HomeViewController"
        return label
    }()
    
    lazy private var simpleButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.UIText.simpleButtonText, for: .normal)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(buttonSelector), for: .touchUpInside)
        button.accessibilityIdentifier = "simpleButton_HomeViewController"
        return button
    }()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = .white
        simpleButton.layer.cornerRadius = 15
        simpleButton.layer.masksToBounds = true
    }
}

//MARK: - Setup methods

extension HomeViewController {
    func setup() {
        setupInterface()
        setupConstraints()
    }
    
    func setupInterface() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(simpleLabel)
        stackView.addArrangedSubview(simpleButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // stackView
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
        ])
    }
}

//MARK: - Selectors

extension HomeViewController {
    @objc func buttonSelector() {
        let progressViewController = ProgressViewController()
        
        navigationController?.pushViewController(progressViewController, animated: true)
    }
}

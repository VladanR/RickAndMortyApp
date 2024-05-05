//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/17/23.
//

import UIKit

/// ViewController for search and display Locations
final class RMLocationViewController: UIViewController, RMLocationViewModelDelegate, RMLocationViewDelegate {

    private let primaryView = RMLocationView()
    
    private let viewModel = RMLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        primaryView.delegate = self
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func search() {
        let viewController = RMSearchViewController(config: RMSearchViewController.Config(type: .location))
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
    
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocationModel) {
        let viewController = RMLocationDetailsViewController(location: location)
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}

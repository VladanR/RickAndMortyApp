//
//  RMLocationDetailsViewController.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/23/23.
//

import UIKit

final class RMLocationDetailsViewController: UIViewController, RMLocationDetailsViewModelDelegate, RMLocationDetailsViewDelegate {

//    private let location: RMLocationModel
    
    private let viewModel: RMLocationDetailsViewModel
    
    private let locationDetailsView = RMLocationDetailsView()
    
    init(location: RMLocationModel) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailsViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(locationDetailsView)
        addConstraints()
        locationDetailsView.delegate = self
        title = "Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            locationDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationDetailsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            locationDetailsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            locationDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }

    @objc private func share() {
        
    }
    
    func didFetchLocationDetails() {
        locationDetailsView.configure(with: viewModel)
        
    }
    
    func rmLocationDetailsView(_ detailView: RMLocationDetailsView, didSelect character: RMCharacterModel) {
        let viewController = RMCharacterDetailsViewController(viewModel: .init(character: character))
        viewController.title = character.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}


//
//  RMEpisodeDetailsViewController.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/21/23.
//

import UIKit

final class RMEpisodeDetailsViewController: UIViewController, RMEpisodeDetailsViewModelDelegate, RMEpisodeDetailsViewDelegate {
    
    private let viewModel: RMEpisodeDetailsViewModel
    
    private let episodeDetailsView = RMEpisodeDetailsView()
    
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailsViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(episodeDetailsView)
        addConstraints()
        episodeDetailsView.delegate = self
        title = "Episode"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            episodeDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeDetailsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeDetailsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }

    @objc private func share() {
        
    }
    
    func didFetchEpisodeDetails() {
        episodeDetailsView.configure(with: viewModel)
        
    }
    
    func rmEpisodeDetailsView(_ detailView: RMEpisodeDetailsView, didSelect character: RMCharacterModel) {
        let viewController = RMCharacterDetailsViewController(viewModel: .init(character: character))
        viewController.title = character.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}

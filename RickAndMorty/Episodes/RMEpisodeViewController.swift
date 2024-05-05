//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/17/23.
//

import UIKit

/// ViewController for search and display Episodes
final class RMEpisodeViewController: UIViewController , RMEpisodeListViewDelegate {
    
    private let episodeList = RMEpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setupView()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
    }
    
    @objc private func search() {
        let viewController = RMSearchViewController(config: RMSearchViewController.Config(type: .episode))
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupView() {
        episodeList.delegate = self
        view.addSubview(episodeList)
        NSLayoutConstraint.activate([
            episodeList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeList.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeList.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisodeModel) {
        
        let detailsViewController = RMEpisodeDetailsViewController(url: URL(string: episode.url))
        detailsViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

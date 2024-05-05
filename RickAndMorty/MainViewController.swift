//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/17/23.
//

import UIKit

final class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabs()
    }

    private func setupTabs() {
        let charactersViewController = RMCharacterViewController()
        let locationsViewController = RMLocationViewController()
        let episodesViewController = RMEpisodeViewController()
        let settingsViewController = RMSettingsViewController()
        
        charactersViewController.navigationItem.largeTitleDisplayMode = .automatic
        locationsViewController.navigationItem.largeTitleDisplayMode = .automatic
        episodesViewController.navigationItem.largeTitleDisplayMode = .automatic
        settingsViewController.navigationItem.largeTitleDisplayMode = .automatic
        
        let characters = UINavigationController(rootViewController: charactersViewController)
        let locations = UINavigationController(rootViewController: locationsViewController)
        let episodes = UINavigationController(rootViewController: episodesViewController)
        let settings = UINavigationController(rootViewController: settingsViewController)
        
        characters.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
        locations.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 2)
        episodes.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
        settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        for nav in [characters, locations, episodes, settings] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [characters, locations, episodes, settings], animated: true)
        
    }
}


//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/17/23.
//

import UIKit

/// ViewController for displaying and searching Characters
final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate {

    private let characterList = RMCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
    }
    
    @objc private func search() {
        let viewController = RMSearchViewController(config: RMSearchViewController.Config(type: .character))
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupView() {
        characterList.delegate = self
        view.addSubview(characterList)
        NSLayoutConstraint.activate([
            characterList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterList.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterList.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacterModel) {
        let viewModel = RMCharacterDetailsViewModel(character: character)
        let detailsViewController = RMCharacterDetailsViewController(viewModel: viewModel)
        detailsViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}


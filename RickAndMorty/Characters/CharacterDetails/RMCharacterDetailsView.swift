//
//  RMCharacterDetailsVIew.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/20/23.
//

import UIKit

final class RMCharacterDetailsView: UIView {
    
    public var characterDetailsView: UICollectionView?
    private var viewModel: RMCharacterDetailsViewModel
    
    private var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    init(frame: CGRect, viewModel: RMCharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBlue
        translatesAutoresizingMaskIntoConstraints = false
        let characterDetailsView = createCharacterDetailsView()
        self.characterDetailsView = characterDetailsView
        addSubviews(characterDetailsView, loadingSpinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        guard let characterDetailsView = characterDetailsView else {
            return
        }
        NSLayoutConstraint.activate([
            loadingSpinner.widthAnchor.constraint(equalToConstant: 100),
            loadingSpinner.heightAnchor.constraint(equalToConstant: 100),
            loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            characterDetailsView.topAnchor.constraint(equalTo: topAnchor),
            characterDetailsView.leftAnchor.constraint(equalTo: leftAnchor),
            characterDetailsView.rightAnchor.constraint(equalTo: rightAnchor),
            characterDetailsView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func createCharacterDetailsView() -> UICollectionView {
        
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(RMCharacterPhotoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.reuseIdentifier)
        collectionView.register(RMCharacterInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.reuseIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        
        switch sectionTypes[sectionIndex] {
            
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInformationSectionLayout()
        case .episodes:
            return viewModel.createEpisodesSectionLayout()
        }
    }
    
    
}

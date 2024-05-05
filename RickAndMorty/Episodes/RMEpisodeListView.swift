//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/21/23.
//

import UIKit

protocol RMEpisodeListViewDelegate: AnyObject {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisodeModel)
}

final class RMEpisodeListView: UIView {
    
    public weak var delegate: RMEpisodeListViewDelegate?
    
    private let viewModel = RMEpisodeListViewModel()

    private var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let episodeListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.reuseIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.reuseIdentifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemMint
        addSubviews(episodeListView, loadingSpinner)
        addConstraints()
        loadingSpinner.startAnimating()
        viewModel.delegate = self
        viewModel.getAllEpisodes()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     private func addConstraints() {
        
        NSLayoutConstraint.activate([
            loadingSpinner.widthAnchor.constraint(equalToConstant: 100),
            loadingSpinner.heightAnchor.constraint(equalToConstant: 100),
            loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            episodeListView.topAnchor.constraint(equalTo: topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        episodeListView.delegate = viewModel
        episodeListView.dataSource = viewModel
    }
}


extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
    
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) {
        episodeListView.performBatchUpdates {
            self.episodeListView.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectEpisode(_ episode: RMEpisodeModel) {
        delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
    }
    
    func didLoadInitialEpisodes() {
        loadingSpinner.stopAnimating()
        episodeListView.isHidden = false
        episodeListView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.episodeListView.alpha = 1
        }
    }
}

//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/20/23.
//

import UIKit

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter characterL: RMCharacterModel)
}

final class RMCharacterListView: UIView {
    
    public weak var delegate: RMCharacterListViewDelegate?
    
    private let viewModel = RMCharacterListViewModel()

    private var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let characterListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterViewCell.self, forCellWithReuseIdentifier: RMCharacterViewCell.cellReuseIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.reuseIdentifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemMint
        addSubviews(characterListView, loadingSpinner)
        addConstraints()
        loadingSpinner.startAnimating()
        viewModel.delegate = self
        viewModel.getAllCharacters()
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
            
            characterListView.topAnchor.constraint(equalTo: topAnchor),
            characterListView.leftAnchor.constraint(equalTo: leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        characterListView.delegate = viewModel
        characterListView.dataSource = viewModel
    }
}


extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

extension RMCharacterListView: RMCharacterListViewViewModelDelegate {
    
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        characterListView.performBatchUpdates {
            self.characterListView.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectCharacter(_ character: RMCharacterModel) {
        delegate?.rmCharacterListView(self, didSelectCharacter: character)
    }
    
    func didLoadInitialCharacters() {
        loadingSpinner.stopAnimating()
        characterListView.isHidden = false
        characterListView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.characterListView.alpha = 1
        }
    }
}

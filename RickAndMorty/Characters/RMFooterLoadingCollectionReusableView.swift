//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/20/23.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
        static let reuseIdentifier = "RMFooterLoading"
    
    private var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(loadingSpinner)
        addContstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContstraints() {
        NSLayoutConstraint.activate([
            loadingSpinner.widthAnchor.constraint(equalToConstant: 100),
            loadingSpinner.heightAnchor.constraint(equalToConstant: 100),
            loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func startAnimating() {
        loadingSpinner.startAnimating()
    }
}

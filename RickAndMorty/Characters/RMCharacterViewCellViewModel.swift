//
//  RMCharacterViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/20/23.
//

import Foundation

final class RMCharacterViewCellViewModel: Hashable, Equatable {
    static func == (lhs: RMCharacterViewCellViewModel, rhs: RMCharacterViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageUrl: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
    
    init(characterName: String, characterStatus: RMCharacterStatus, characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
}

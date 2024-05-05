//
//  RMEpisodeDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/21/23.
//

import UIKit

protocol RMEpisodeDetailsViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailsViewModel {
    
    private let endpointURL: URL?
    
    private var dataTuple: (episode: RMEpisodeModel, characters: [RMCharacterModel])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterViewCellViewModel])
    }
    
    public weak var delegate: RMEpisodeDetailsViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
    
    public func character(at index: Int) -> RMCharacterModel? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        var createdString = episode.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name ", value: episode.name),
                .init(title: "Air Date ", value: episode.air_date),
                .init(title: "Episode ", value: episode.episode),
                .init(title: "Created ", value: createdString),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return RMCharacterViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
            }))
        ]
    }
    
    public func fetchEpisodeData() {
        guard let url = endpointURL, let request = RMAPIRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisodeModel.self) { [weak self] response in
            switch response {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: RMEpisodeModel) {
        let requests: [RMAPIRequest] = episode.characters.compactMap {
            return URL(string: $0)
        }.compactMap {
            return RMAPIRequest(url: $0)
        }
        
        let group = DispatchGroup()
        var characters: [RMCharacterModel] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacterModel.self) { response in
                defer {
                    group.leave()
                }
                switch response {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main) {
            self.dataTuple = (episode, characters)
        }
    }
}

//
//  RMLocationDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/23/23.
//

import Foundation


protocol RMLocationDetailsViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailsViewModel {
    
    private let endpointURL: URL?
    
    private var dataTuple: (location: RMLocationModel, characters: [RMCharacterModel])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterViewCellViewModel])
    }
    
    public weak var delegate: RMLocationDetailsViewModelDelegate?
    
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
        let location = dataTuple.location
        let characters = dataTuple.characters
        var createdString = location.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name ", value: location.name),
                .init(title: "Type ", value: location.type),
                .init(title: "Dimension ", value: location.dimension),
                .init(title: "Created ", value: createdString),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return RMCharacterViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
            }))
        ]
    }
    
    public func fetchLocationData() {
        guard let url = endpointURL, let request = RMAPIRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMLocationModel.self) { [weak self] response in
            switch response {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(location: RMLocationModel) {
        let requests: [RMAPIRequest] = location.residents.compactMap {
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
            self.dataTuple = (location, characters)
        }
    }
}

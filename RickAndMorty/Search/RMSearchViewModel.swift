//
//  RMSearchViewModel.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/23/23.
//

import UIKit

final class RMSearchViewModel {
    let config: RMSearchViewController.Config
    private var optionMap: [RMSearchInputViewModel.DynamicOption: String] = [:]
    private var searchText = ""
    public weak var charactersDelegate: RMCharacterListViewViewModelDelegate?
    public weak var searchDelegate: RMSearchViewDelegate?
    
    private var optionMapUpdateBlock: (((RMSearchInputViewModel.DynamicOption, String)) -> Void)?
    private var searchResultHandler:((RMSearchResultViewModel) -> Void)?
    private var noResultsHandler:(() -> Void)?
    private var searchResultModel: Codable?
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    public func set(value: String, for option: RMSearchInputViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewModel.DynamicOption, String)) -> Void) {
        self.optionMapUpdateBlock = block
    }
    
    public func executeSearch() {
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]
               
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: RMSearchInputViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        let request = RMAPIRequest(endpoint: config.type.endpoint, queryParameters: queryParams)
        print(request.url?.absoluteURL as Any)
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMCharactersResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMEpisodesResponse.self, request: request)
        }
       
    }
    private func makeSearchAPICall<T:Codable>(_ type: T.Type, request: RMAPIRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] response in
            switch response {
            case .success(let model):
                self?.processSearchResults(model:model)
//                print("Search results found: \(model.results.count)")
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResults(model: Codable) {
        var resultsViewModel: RMSearchResultViewModel?
        if let charactersResults = model as? RMCharactersResponse {
            resultsViewModel = .characters(charactersResults.results.compactMap({
                return RMCharacterViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image))
            }))
        }
        else if let locationsResults = model as? RMLocationsResponse {
            resultsViewModel = .locations(locationsResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }
        else if let episodesResults = model as? RMEpisodesResponse {
            resultsViewModel = .episodes(episodesResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodesURL: URL(string: $0.url))
            }))
        }
        if let results = resultsViewModel {
            self.searchResultHandler?(results)
        } else {
            handleNoResults()
        }
    }
    
    private func handleNoResults() {
        print("No results")
        noResultsHandler?()
    }
    
    public func locationSearchResult(at index: Int) -> RMLocationModel? {
           guard let searchModel = searchResultModel as? RMLocationsResponse else {
               return nil
           }
           return searchModel.results[index]
       }
}

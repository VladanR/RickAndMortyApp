//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/27/23.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}

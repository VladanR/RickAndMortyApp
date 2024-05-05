//
//  RMCharactersResponse.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/17/23.
//

import Foundation

struct RMCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMCharacterModel]
    
}

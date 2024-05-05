//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/21/23.
//

import Foundation

struct RMEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisodeModel]
    
}

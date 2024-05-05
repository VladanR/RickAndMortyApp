//
//  RMLocationsResponse.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/22/23.
//

import Foundation

struct RMLocationsResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMLocationModel]
    
}

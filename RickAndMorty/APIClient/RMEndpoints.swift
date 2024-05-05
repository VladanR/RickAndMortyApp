//
//  RMEndpoints.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/17/23.
//

import Foundation

/// Represents each unique API endpoint
@frozen enum RMEndpoints: String, CaseIterable, Hashable {
    case character
    case episode
    case location
}

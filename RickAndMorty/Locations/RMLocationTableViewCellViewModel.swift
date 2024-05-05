//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/22/23.
//

import UIKit

struct RMLocationTableViewCellViewModel: Hashable, Equatable {
    
    private let location: RMLocationModel
    
    init(location: RMLocationModel) {
        self.location = location
    }
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return "Type: "+location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
}

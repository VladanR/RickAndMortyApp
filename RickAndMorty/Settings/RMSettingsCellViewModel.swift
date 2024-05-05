//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/22/23.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    let id = UUID()
    
    public let type: RMSettingsOptions
    public let onTapHandler: (RMSettingsOptions) -> Void
    
    init(type: RMSettingsOptions, onTapHandler: @escaping (RMSettingsOptions) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    public var image: UIImage? {
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}

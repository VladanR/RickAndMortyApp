//
//  RMSettingsSwiftUIView.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/22/23.
//

import SwiftUI

struct RMSettingsSwiftUIView: View {
    let viewModel: RMSettingsViewModel
    
    init(viewModel: RMSettingsViewModel) {
        self.viewModel = viewModel
    }
    
    let strings = ["A", "B", "C"]
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                
                Spacer()
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

struct RMSettingsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsSwiftUIView(viewModel: .init(cellViewModels: RMSettingsOptions.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { option in
                
            }
        })))
    }
}

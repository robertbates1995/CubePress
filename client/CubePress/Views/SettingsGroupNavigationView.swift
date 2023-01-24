//
//  SettingsGroupNavigationView.swift
//  CubePressTests
//
//  Created by Robert Bates on 1/9/23.
//

import SwiftUI


struct SettingsGroupNavigationView: View {
    @ObservedObject var model: SettingsGroupNavigationModel
    
    var body: some View {
        NavigationView {
            List(model.settingsGroups) { group in
                NavigationLink {
                    SettingsGroupView(model: SettingsGroupModel(settings: group.settingsList, title: group.title, subTitle: group.subTitle))
                } label: {
                    VStack {
                        HStack {
                            Text(group.title)
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text(group.subTitle)
                                .font(.subheadline)
                                .italic()
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct SettingsGroupNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGroupNavigationView (
            model: SettingsGroupNavigationModel (
                settingsGroups: SettingsGroupNavigationModel.testSettingsGroups
            )
        )
    }
}

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
                        Text(group.title)
                        Text(group.subTitle)
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

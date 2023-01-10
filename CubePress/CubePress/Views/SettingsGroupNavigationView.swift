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
                NavigationLink( group.title , destination: SettingsGroupView(model: SettingsGroupModel(settings: CubePressApp.listOfSettings, title: group.title)))
                    .isDetailLink(false)
            }
            Text("Nothing Selected")
        }
    }
}

struct SettingsGroupNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGroupNavigationView(
            model: SettingsGroupNavigationModel(
                settingsGroups:
                    [
                        SettingsGroupModel(settings: CubePressApp.listOfSettings, title: "Test Group Title 1"),
                        SettingsGroupModel(settings: CubePressApp.listOfSettings, title: "Test Group Title 2"),
                        SettingsGroupModel(settings: CubePressApp.listOfSettings, title: "Test Group Title 3"),
                    ]
            )
        )
    }
}

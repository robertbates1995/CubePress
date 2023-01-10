//
//  SlidersView.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

struct SettingsGroupView: View  {
    @ObservedObject var model: SettingsGroupModel
    
    var body: some View {
        NavigationView{
            List(model.settingsList) { setting in
                SettingView(model: setting)
            }
            .navigationTitle(model.title)
        }
    }
}

struct SlidersView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGroupView(model: SettingsGroupNavigationModel.testSettingsGroups[0])
    }
}

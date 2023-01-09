//
//  SlidersView.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

//small view model for use by SettingsGroupView
class SettingsGroupModel: ObservableObject {
    @Published var settings: [SettingViewModel]
    var title: String
    
    init(settings: [SettingViewModel], title: String) {
        self.settings = settings
        self.title = title
    }
}


struct SettingsGroupView: View  {
    @ObservedObject var model: SettingsGroupModel
    
    var body: some View {
        NavigationView{
            List(model.settings) { setting in
                SettingView(model: setting)
            }
            .navigationTitle(model.title)
        }
    }
}

struct SlidersView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsGroupView(model: SettingsGroupModel(settings: CubePressApp.listOfSettings, title: "Test Settings Group Title"))
    }
}

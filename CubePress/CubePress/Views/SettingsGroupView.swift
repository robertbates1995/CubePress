//
//  SlidersView.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

//small view model for use by SettingsGroupView
class SettingsGroupModel: ObservableObject, Identifiable {
    @Published var settings: [SettingViewModel]
    var title: String
    let id: UUID
    
    init(settings: [SettingViewModel], title: String, id: UUID = UUID()) {
        self.settings = settings
        self.title = title
        self.id = id
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
        SettingsGroupView(model: SettingsGroupModel(settings: CubePressApp.listOfSettings, title: "Test Group Title"))
    }
}

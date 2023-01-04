//
//  SlidersView.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

class SettingsGroupModel: ObservableObject {
    @Published var settings: [SettingViewModel]
    
    init(settings: [SettingViewModel]) {
        self.settings = settings
    }
}

struct SettingsGroup: View  {
    @ObservedObject var model: SettingsGroupModel
    
    var body: some View {
        List(model.settings) { setting in
            SettingView(model: setting)
        }
    }
}

struct SlidersView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsGroup(model: SettingsGroupModel(settings: CubePressApp.listOfSettings))
    }
}

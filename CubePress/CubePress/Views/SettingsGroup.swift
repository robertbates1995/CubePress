//
//  SlidersView.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

struct SettingsGroup: View  {
    let settings: [Setting]
    
    var body: some View {
        List(settings) { setting in
            Setting(title: setting.title, buttonLabel: setting.buttonLabel)
        }
    }
}

struct SlidersView_Previews: PreviewProvider {
    static var listOfSettings = [
        Setting(title: "test 1", buttonLabel: "button test 1"),
        Setting(title: "test 2", buttonLabel: "button test 2"),
        Setting(title: "test 3", buttonLabel: "button test 3")
    ]
    
    static var previews: some View {
        SettingsGroup(settings: listOfSettings)
    }
}

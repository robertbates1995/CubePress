//
//  CubePressApp.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

@main
struct CubePressApp: App {
    static var listOfSettings = [
        SettingViewModel(sliderValue: 10, title: "test 1", buttonLabel: "button test 1"),
        SettingViewModel(sliderValue: 20, title: "test 2", buttonLabel: "button test 2"),
        SettingViewModel(sliderValue: 30, title: "test 3", buttonLabel: "button test 3")
    ]
    
    static var listOfSettingsGroups = [
        SettingsGroupModel(settings: CubePressApp.listOfSettings, title: "Test Group Title 1"),
        SettingsGroupModel(settings: CubePressApp.listOfSettings, title: "Test Group Title 2"),
        SettingsGroupModel(settings: CubePressApp.listOfSettings, title: "Test Group Title 3"),
    ]
    
    var body: some Scene {
        WindowGroup {
            SettingsGroupNavigationView(model: SettingsGroupNavigationModel(settingsGroups: CubePressApp.listOfSettingsGroups))
        }
    }
}

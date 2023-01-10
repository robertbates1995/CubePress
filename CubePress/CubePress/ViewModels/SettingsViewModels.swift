//
//  SettingsViewModels.swift
//  CubePress
//
//  Created by Robert Bates on 1/10/23.
//

import Foundation

//small view model for use by SettingsGroupNavigationView
class SettingsGroupNavigationModel: ObservableObject, Identifiable {
    @Published var settingsGroups: [SettingsGroupModel]
    let id: UUID
    
    init(settingsGroups: [SettingsGroupModel], id: UUID = UUID()) {
        self.settingsGroups = settingsGroups
        self.id = id
    }
}

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

//small view model for use by SettingView
class SettingViewModel: ObservableObject, Identifiable {
    @Published var sliderValue: Double = 0
    let title: String
    let buttonLabel: String
    var showButton: Bool {action != nil}
    var action: (() -> Void)?
    let id: UUID
    
    init(sliderValue: Double, title: String, buttonLabel: String, action: (() -> Void)? = nil, id: UUID = UUID()) {
        self.sliderValue = sliderValue
        self.title = title
        self.buttonLabel = buttonLabel
        self.action = action
        self.id = id
    }
    
    func buttonPressed() {
        action?()
    }
}

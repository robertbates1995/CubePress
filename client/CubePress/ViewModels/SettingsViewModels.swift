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

extension SettingsGroupNavigationModel {
    static var settingsGroups = [
            SettingsGroupModel(settings: SettingsGroupModel.servosSettings, title: "Servos", subTitle: "Pulse width range"),
            SettingsGroupModel(settings: SettingsGroupModel.topCoverSettings, title: "Top cover", subTitle: "servo settings"),
            SettingsGroupModel(settings: SettingsGroupModel.cubeHolderSettings, title: "Cube holder", subTitle: "servo settings"),
            SettingsGroupModel(settings: SettingsGroupModel.webcamSettings, title: "Webcam", subTitle: ""),
    ]
    
    static var testSettingsGroups = [
        SettingsGroupModel(settings: SettingsGroupModel.testSettings, title: "Test Group Title 1", subTitle: "next left blank"),
        SettingsGroupModel(settings: SettingsGroupModel.testSettings, title: "Test Group Title 2", subTitle: ""),
        SettingsGroupModel(settings: SettingsGroupModel.testSettings, title: "Test Group Title 3", subTitle: "prev left blank"),
    ]
}


//small view model for use by SettingsGroupView
class SettingsGroupModel: ObservableObject, Identifiable {
    @Published var settingsList: [SettingModel]
    var title: String
    var subTitle: String
    let id: UUID
    
    init(settings: [SettingModel], title: String, subTitle: String, id: UUID = UUID()) {
        self.settingsList = settings
        self.title = title
        self.subTitle = subTitle
        self.id = id
    }
}

extension SettingsGroupModel {
    static var servosSettings = [
        SettingModel(sliderValue: 10, title: "Top Servo", buttonLabel: "Top Servo"),
        SettingModel(sliderValue: 20, title: "Bottom Servo", buttonLabel: "Bottom Servo"),
        SettingModel(sliderValue: 30, title: "", buttonLabel: "Confirm Changes")
    ]
    
    static var topCoverSettings = [
        SettingModel(sliderValue: 10, title: "PWM flip", buttonLabel: "FLIP (toggle)"),
        SettingModel(sliderValue: 20, title: "PWM open", buttonLabel: "OPEN"),
        SettingModel(sliderValue: 30, title: "PWM Close", buttonLabel: "CLOSE"),
        SettingModel(sliderValue: 30, title: "PWM release from close", buttonLabel: ""),
        SettingModel(sliderValue: 30, title: "TIME: flip > close (ms)", buttonLabel: ""),
        SettingModel(sliderValue: 30, title: "TIME: close > flip (ms)", buttonLabel: ""),
        SettingModel(sliderValue: 30, title: "TIME: flip > open (ms)", buttonLabel: ""),
        SettingModel(sliderValue: 30, title: "TIME: open > close (ms)", buttonLabel: "")
    ]
    
    static var cubeHolderSettings = [
        SettingModel(sliderValue: 10, title: "PWM CCW", buttonLabel: "CCW"),
        SettingModel(sliderValue: 20, title: "PWM home", buttonLabel: "HOME"),
        SettingModel(sliderValue: 30, title: "PWM CW", buttonLabel: "CW"),
        SettingModel(sliderValue: 30, title: "PWM release CW/CCW", buttonLabel: ""),
        SettingModel(sliderValue: 30, title: "PWM release at home", buttonLabel: ""),
        SettingModel(sliderValue: 30, title: "TIME: spin (ms)", buttonLabel: ""),
        SettingModel(sliderValue: 30, title: "TIME: rotate (ms)", buttonLabel: ""),
        SettingModel(sliderValue: 30, title: "TIME: release (ms)", buttonLabel: "")
    ]
    
    static var webcamSettings = [
        SettingModel(sliderValue: 10, title: "test 1", buttonLabel: "button test 1"),
        SettingModel(sliderValue: 20, title: "test 2", buttonLabel: "button test 2"),
        SettingModel(sliderValue: 30, title: "test 3", buttonLabel: "button test 3")
    ]
    
    static var testSettings = [
        SettingModel(sliderValue: 10, title: "test 1", buttonLabel: "button test 1"),
        SettingModel(sliderValue: 20, title: "test 2", buttonLabel: "button test 2"),
        SettingModel(sliderValue: 30, title: "test 3", buttonLabel: "button test 3")
    ]
}


//small view model for use by SettingView
class SettingModel: ObservableObject, Identifiable {
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

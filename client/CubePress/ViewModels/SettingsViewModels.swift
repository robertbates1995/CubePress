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
        //SettingsGroupModel(settings: SettingsGroupModel.armSettings, title: "Arm Settings", subTitle: "servo settings"),
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
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "Top Servo", buttonLabel: "Top Servo"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "Bottom Servo", buttonLabel: "Bottom Servo"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "", buttonLabel: "Confirm Changes")
    ]
    
    static var topCoverSettings = [
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "PWM flip", buttonLabel: "FLIP (toggle)"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "PWM open", buttonLabel: "OPEN"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "PWM Close", buttonLabel: "CLOSE"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "PWM release from close", buttonLabel: ""),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "TIME: flip > close (ms)", buttonLabel: ""),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "TIME: close > flip (ms)", buttonLabel: ""),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "TIME: flip > open (ms)", buttonLabel: ""),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "TIME: open > close (ms)", buttonLabel: "")
    ]
    
    static var cubeHolderSettings = [
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "PWM CCW", buttonLabel: "CCW"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "PWM home", buttonLabel: "HOME"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "PWM CW", buttonLabel: "CW"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "PWM release CW/CCW", buttonLabel: ""),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "PWM release at home", buttonLabel: ""),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "TIME: spin (ms)", buttonLabel: ""),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "TIME: rotate (ms)", buttonLabel: ""),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "TIME: release (ms)", buttonLabel: "")
    ]
    
    static var webcamSettings = [
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "test 1", buttonLabel: "button test 1"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "test 2", buttonLabel: "button test 2"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "test 3", buttonLabel: "button test 3")
    ]
    
    static var testSettings = [
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "test 1", buttonLabel: "button test 1"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "test 2", buttonLabel: "button test 2"),
        SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "test 3", buttonLabel: "button test 3")
    ]
}


//small view model for use by SettingView
class SettingModel: ObservableObject, Identifiable {
    @Published var maxValue: Double
    @Published var minValue: Double
    @Published var value: Double
    let title: String
    let buttonLabel: String
    var showButton: Bool {action != nil}
    var action: (() -> Void)?
    let id: UUID
    
    init(maxSliderValue: Double, minSliderValue: Double, title: String, buttonLabel: String, action: (() -> Void)? = nil, id: UUID = UUID()) {
        self.maxValue = maxSliderValue
        self.minValue = minSliderValue
        self.value = (maxSliderValue - minSliderValue)/2
        self.title = title
        self.buttonLabel = buttonLabel
        self.action = action
        self.id = id
    }
    
    func buttonPressed() {
        action?()
    }
}

extension SettingModel {
    static var testSetting = SettingModel(maxSliderValue: 100, minSliderValue: 0, title: "test setting title", buttonLabel: "test button title")
}

//
//  AppManager.swift
//  CubePress
//
//  Created by Robert Bates on 3/13/23.
//

import Foundation

class AppManager {
    var colorFinder: ColorFinder
    var videoCapture: VideoCapture
    var settingsModel: SettingsModel
    var frameModel: FrameModel
    
    init() {
        self.colorFinder = ColorFinder()
        self.videoCapture = VideoCapture()
        self.settingsModel = SettingsModel()
        self.frameModel = FrameModel()
    }
}

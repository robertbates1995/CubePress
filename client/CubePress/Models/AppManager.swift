//
//  AppManager.swift
//  CubePress
//
//  Created by Robert Bates on 3/13/23.
//

import Foundation

struct AppManager {
    var colorFinder: ColorFinder
    var videoCapture: VideoCapture
    var settingsModel: SettingsModel
    var frameModel: FrameModel
    var cubeMapModel: CubeMapModel //needs to be made observable
    
    init() {
        self.colorFinder = ColorFinder()
        self.videoCapture = VideoCapture()
        self.settingsModel = SettingsModel()
        self.frameModel = FrameModel()
        self.cubeMapModel = CubeMapModel()
    }
    
    func onSolvedTapped() {
        
        //control the robot to map the cube and create a solution from here
    }
}

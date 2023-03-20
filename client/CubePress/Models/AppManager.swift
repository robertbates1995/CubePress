//
//  AppManager.swift
//  CubePress
//
//  Created by Robert Bates on 3/13/23.
//

import Foundation

class AppManager {
    var videoCapture: VideoCapture
    var settingsModel: SettingsModel
    var frameModel: FrameModel
    var cubeMapModel: CubeMapModel //needs to be made observable
    var solver: Solver
    
    init() {
        self.videoCapture = VideoCapture()
        self.settingsModel = SettingsModel()
        self.frameModel = FrameModel()
        self.cubeMapModel = CubeMapModel()
        self.solver = Solver(getter: frameModel, cubeMover: settingsModel)
    }
    
    func onSolvedTapped() {
        solver.solveCube()
        //cubeMapModel = scanCube()
        //control the robot to map the cube and create a solution from here
    }
}

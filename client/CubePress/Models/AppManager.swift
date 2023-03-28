//
//  AppManager.swift
//  CubePress
//
//  Created by Robert Bates on 3/13/23.
//

import Foundation
import KociembaSolver

@MainActor
class AppManager {
    var videoCapture: VideoCapture
    var settingsModel: SettingsModel
    var cubeMapModel: CubeMapModel //needs to be made observable
    var solver: Solver
    
    init() {
        self.videoCapture = VideoCapture()
        self.settingsModel = SettingsModel()
        self.cubeMapModel = CubeMapModel()
        self.solver = Solver(getter: videoCapture.model, cubeMover: settingsModel, cubeMap: cubeMapModel)
    }
    
    func onSolvedTapped() {
        Task{
            try await solver.solveCube()
        }
        //cubeMapModel = scanCube()
        //control the robot to map the cube and create a solution from here
    }
}

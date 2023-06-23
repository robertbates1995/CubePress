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
    var mover: Mover
    
    init() {
        self.videoCapture = VideoCapture()
        self.settingsModel = SettingsModel()
        self.cubeMapModel = CubeMapModel()
        self.mover = Mover(settings: settingsModel)
        self.solver = Solver(getter: videoCapture.model, cubeMover: mover, cubeMap: cubeMapModel)
    }
    
    func onSolvedTapped() {
        Task{
            try await solver.solveCube()
        }
        //cubeMapModel = scanCube()
        //control the robot to map the cube and create a solution from here
    }
}

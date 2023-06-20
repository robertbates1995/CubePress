//
//  mainView.swift
//  CubePress
//
//  Created by Robert Bates on 3/13/23.
//

import SwiftUI

@MainActor
struct MainView: View {
    let model = AppManager()
    
    var body: some View {
        TabView {
            CubeMapView(onScanTapped: {model.onSolvedTapped()}, model: model.cubeMapModel)
                .tabItem {
                    Label("Map", systemImage: "square.grid.3x3.square")
                }
            CameraView(model: model.videoCapture, onScanTapped: {model.onSolvedTapped()})
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
            ControllerView(model: model.mover)
                .tabItem {
                    Label("Controller", systemImage: "dpad.fill")
                }
            SettingsView(model: model.settingsModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

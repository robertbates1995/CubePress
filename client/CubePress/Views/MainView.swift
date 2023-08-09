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
            Group {
                CubeMapView(onScanTapped: {model.onSolvedTapped()}, model: model.cubeMapModel)
                    .tabItem {
                        Label("Map", systemImage: "square.grid.3x3.square")
                    }
                CameraView(model: model.videoCapture, onScanTapped: {model.onScanTapped()})
                    .onAppear() {
                        model.videoCapture.captureSession.startRunning()
                    }
                    .onDisappear() {
                        model.videoCapture.captureSession.stopRunning()
                    }
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
            .toolbarBackground(Color.yellow, for: .tabBar)
            .toolbar(.visible, for: .tabBar)
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

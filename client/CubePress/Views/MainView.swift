//
//  mainView.swift
//  CubePress
//
//  Created by Robert Bates on 3/13/23.
//

import SwiftUI

@MainActor
struct MainView: View {
    @ObservedObject var model = AppManager()
    
    var body: some View {
        TabView(selection: $model.selectedTab) {
            Group {
                CubeMapView(onSolveTapped: {model.onSolvedTapped()}, model: model.cubeMapModel)
                    .tabItem {
                        Label("Map", systemImage: "square.grid.3x3.square")
                    }
                    .tag(1)
                CameraView(model: model.videoCapture, onScanTapped: {model.onScanTapped()})
                    .onAppear() {
                        Task.detached {
                            await model.videoCapture.captureSession.startRunning()
                        }
                    }
                    .onDisappear() {
                        model.videoCapture.captureSession.stopRunning()
                    }
                    .tabItem {
                        Label("Camera", systemImage: "camera")
                    } 
                    .tag(2)
                SettingsView(model: model.settingsModel)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(3)
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

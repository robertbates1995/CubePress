//
//  mainView.swift
//  CubePress
//
//  Created by Robert Bates on 3/13/23.
//

import SwiftUI

struct MainView: View {
    let model = AppManager()
    
    var body: some View {
        TabView {
            CubeMapView(model: model.cubeMapModel)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            SettingsView(model: model.settingsModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            CameraView(model: model.videoCapture, onSolvedTapped: {model.onSolvedTapped()})
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

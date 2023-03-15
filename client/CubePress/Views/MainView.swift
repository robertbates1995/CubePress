//
//  mainView.swift
//  CubePress
//
//  Created by Robert Bates on 3/13/23.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            CubeMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            SettingsView(model: SettingsModel())
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            CameraView()
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

//
//  mainView.swift
//  CubePress
//
//  Created by Robert Bates on 3/13/23.
//

import SwiftUI

struct MainViewModel {
    
}

struct MainView: View {
    let model = MainViewModel()
    
    var body: some View {
        TabView {
            CubeMapView(model: CubeMapModel())
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

//
//  SettingsView.swift
//  CubePress
//
//  Created by Robert Bates on 2/3/23.
//

import SwiftUI

struct SettingsView: View {
    var setting: Moves
    
    var body: some View {
        List {
            ForEach(Moves.allCases) { setting in
                Button("set \(setting.rawValue) value") {
                    Task {
                        await sendSetting()
                    }
                }
            }
        }
    }
    func sendSetting() async {
        guard let url = URL(string: "http://10.0.0.34/setting=\(setting.rawValue)") else { return }
        let _ = try? await URLSession.shared.data(from: url)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(setting: Moves.top)
    }
}

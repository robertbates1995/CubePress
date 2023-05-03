//
//  SettingsView.swift
//  CubePress
//
//  Created by Robert Bates on 2/3/23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: SettingsModel
    
    var body: some View {
        List {
            Section(header: Text("Connected On")){
                TextField("", text: $model.ipAddress)
                if let error = model.errorMessage {
                    Text(error).foregroundColor(.red)
                }
            }
            
            
            Section(header: Text("Arm Servo Settings")){
                SettingRow(move: Move.top, model: model)
                SettingRow(move: Move.mid, model: model)
                SettingRow(move: Move.bot, model: model)
            }
            
            Section(header: Text("Table Servo Settings")){
                SettingRow(move: Move.left, model: model)
                SettingRow(move: Move.center, model: model)
                SettingRow(move: Move.right, model: model)
            }
        }
        .task {
            model.getSetting()
        }
    }
}

struct SettingRow: View {
    let move: Move
    let model: SettingsModel
    
    var body: some View {
        HStack{
            Button("Move \(move.rawValue)") {
                    model.sendSetting(setting: move)
            }
            Spacer()
            TextField(move.rawValue, text: model.binding(for: move))
                .frame(width: 200, alignment: .trailing)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: .init())
    }
}

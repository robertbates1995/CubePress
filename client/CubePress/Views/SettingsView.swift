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
                SettingRow(move: Move.top, model: model, moveString: "Top")
                SettingRow(move: Move.mid, model: model, moveString: "Middle")
                SettingRow(move: Move.bot, model: model, moveString: "Bottom")
            }.disabled(model.settings.isEmpty)
            
            Section(header: Text("Table Servo Settings")){
                SettingRow(move: Move.left, model: model, moveString: "Left")
                SettingRow(move: Move.center, model: model, moveString: "Center")
                SettingRow(move: Move.right, model: model, moveString: "Right")
            }.disabled(model.settings.isEmpty)
        }
        .task {
            model.getSetting()
        }
    }
}

struct SettingRow: View {
    let move: Move
    @ObservedObject var model: SettingsModel
    @FocusState var isFocused: Bool
    let moveString: String
    
    var body: some View {
        HStack{
            Button(moveString){
                model.test(setting: move)
            }
            .frame(width: 80, alignment: .center)
            Spacer()
            TextField(moveString, text: model.binding(for: move))
                .focused($isFocused)
                .frame(width: 80, alignment: .trailing)
                .multilineTextAlignment(.trailing)
                .onChange(of: isFocused) { _ in
                    model.send(setting: move)
                }
        }
    }
}

class SettingsView_Previews: PreviewProvider {
    static var model: SettingsModel {
           let model = SettingsModel()
           model.callServer = {
               print($0)
               try await Task.sleep(for: .seconds(1))
               return Data("""
               {"left": 245,
               "center": 143,
               "bot": 165,
               "mid": 123,
               "top": 70,
               "right": 50}
               """.utf8)
           }
           return model
       }
    
    static var previews: some View {
        SettingsView(model: Self.model)
    }
}

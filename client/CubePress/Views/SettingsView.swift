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
            HStack {
                Text("connected on i.p address:")
                TextField("", text: $model.ipAddress)
            }
            if let error = model.errorMessage {
                Text(error)
            }
            ForEach(Move.allCases) { move in
                HStack{
                    Button("Move \(move.rawValue)") {
                            model.sendSetting(setting: move)
                    }
                    Spacer()
                    TextField(move.rawValue, text: model.binding(for: move))
                        .frame(width: 200, alignment: .trailing)
                }
            }
            ForEach(MacroMove.allCases) { move in
                HStack{
                    Button("Move \(move.rawValue)") {
                            model.macroMoveSetting(setting: move)
                    }
                }
            }
        }
        .task {
            model.getSetting()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: .init())
    }
}

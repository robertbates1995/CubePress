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
            if let error = model.errorMessage {
                Text(error)
            }
            ForEach(Moves.allCases) { move in
                HStack{
                    Button("set \(move.rawValue)") {
                            model.sendSetting(setting: move)
                    }
                    Spacer()
                    TextField(move.rawValue, text: model.binding(setting: move))
                        .frame(width: 200, alignment: .trailing)
                }
            }
            Button("Get Settings") {
                //model.processData()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: .init())
    }
}

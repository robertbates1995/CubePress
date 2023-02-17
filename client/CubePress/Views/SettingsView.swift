//
//  SettingsView.swift
//  CubePress
//
//  Created by Robert Bates on 2/3/23.
//

import SwiftUI

enum Moves: String, CaseIterable, Identifiable {
    var id: String {rawValue}
    
    case top, mid, bot, left, center, right
}

class SettingsModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var value = [Moves:String]()
    
    func binding(setting: Moves) -> Binding<String> {
        Binding(
            get: {self.value[setting] ?? ""},
            set: {newValue in
                self.value[setting] = newValue}
        )
    }
    
    func sendSetting(setting: Moves) {
        Task { @MainActor in
            errorMessage = nil
        }
        guard let url = URL(string: "http://10.0.0.34/settings") else { return }
        Task{
            do{
                let (data, _ ) = try await URLSession.shared.data(from: url)
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                Task { @MainActor in
                    self.errorMessage = error.localizedDescription
                }
            }

        }
    }
}

struct SettingsView: View {
    @ObservedObject var model: SettingsModel
    
    var body: some View {
        List {
            if let error = model.errorMessage {
                Text(error)
            }
            ForEach(Moves.allCases) { setting in
                HStack{
                    Button("set \(setting.rawValue)") {
                            model.sendSetting(setting: setting)
                    }
                    Spacer()
                    TextField("set \(setting.rawValue)", text: model.binding(setting: setting))
                        .frame(width: 200, alignment: .trailing)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: .init())
    }
}

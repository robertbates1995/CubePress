//
//  SettingsView.swift
//  CubePress
//
//  Created by Robert Bates on 2/3/23.
//

import SwiftUI

class SettingsModel: ObservableObject {
    @Published var errorMessage: String?
    
    func sendSetting(setting: Moves) {
        Task { @MainActor in
            errorMessage = nil
        }
        guard let url = URL(string: "http://10.0.0.34/settings") else { return }
        Task{
            do{
                let data = try await URLSession.shared.data(from: url)
                let str = String(decoding: data.0, as: UTF8.self)
                print(str)
                let json = try JSONSerialization.jsonObject(with: data.0, options: []) as? [String: Any]
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
                Button("set \(setting.rawValue) value") {
                        model.sendSetting(setting: setting)
                }
            }
        }
    }
    
}

class JsonParser {
    static func parseJson(jsonData: Data) -> [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return json
        } catch {
            let errorMessage = "Error while parsing JSON: \(error)"
            print(errorMessage)
            showErrorMessage(errorMessage)
            return nil
        }
    }
    
    static func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: .init())
    }
}

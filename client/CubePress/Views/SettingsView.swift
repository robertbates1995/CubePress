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
        SettingsView(setting: Moves.center)
    }
}

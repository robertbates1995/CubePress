//
//  SettingsViewModel.swift
//  CubePress
//
//  Created by Robert Bates on 2/17/23.
//

import Foundation
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
    
    @MainActor
    fileprivate func processData(_ data: Data) {
        do{
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            let decoder = JSONDecoder()
            let json = try decoder.decode(Moves.self.RawValue, from: data)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func sendSetting(setting: Moves) {
        Task { @MainActor in
            errorMessage = nil
        }
        guard let url = URL(string: "http://10.0.0.34/settings") else { return }
        Task{
            do{
                let (data, _ ) = try await URLSession.shared.data(from: url)
                await processData(data)
            } catch {
                Task { @MainActor in
                    self.errorMessage = error.localizedDescription
                }
            }

        }
    }
}

//
//  SettingsViewModel.swift
//  CubePress
//
//  Created by Robert Bates on 2/17/23.
//

import Foundation
import SwiftUI

class SettingsModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var ipAddress: String = "Cubotino.local"
    @Published var settings = [Move:String]()
    @Published var isLoading = false
    weak var cubeMover: CubeMovable?
    var callServer: (URL) async throws -> Data = {
        try await URLSession.shared.data(from: $0).0
    }
    
    func binding(for move: Move) -> Binding<String> {
        Binding(
            get: {self.settings[move] ?? ""},
            set: {newValue in
                self.settings[move] = newValue}
        )
    }
    
    @MainActor
    func processData(_ data: Data) {
        do{
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            let decoder = JSONDecoder()
            let json = try decoder.decode([String:Int].self, from: data)
            for key in json.keys {
                if let move = Move(rawValue: key), let value = json[key] {
                    settings[move] = value.formatted(.number.grouping(.never))
                }
            }
            //TODO copy JSON to model.value
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func send(setting: Move) {
        guard let value = settings[setting] else {return}
        Task { @MainActor in
            errorMessage = nil
        }
        guard let url = URL(string: "http://\(ipAddress)/settings/\(setting.rawValue)/\(value)") else { return }
        Task{
            do{
                let data = try await callServer(url)
                await processData(data)
            } catch {
                Task { @MainActor in
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func test(setting: Move) {
        Task{
            try await cubeMover?.input(move: setting.string)
        }
    }
    
    @MainActor
    func getSetting() {
        errorMessage = nil
        isLoading = true
        guard let url = URL(string: "http://\(ipAddress)/settings") else { return }
        Task {
            do {
                let data = try await callServer(url)
                processData(data)
            } catch {
                Task { @MainActor in
                    self.errorMessage = error.localizedDescription
                }
            }
            Task { @MainActor in
                isLoading = false
            }
        }
    }
}

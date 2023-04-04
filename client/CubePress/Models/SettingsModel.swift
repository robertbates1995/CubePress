//
//  SettingsViewModel.swift
//  CubePress
//
//  Created by Robert Bates on 2/17/23.
//

import Foundation
import SwiftUI

enum Moves: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case top, mid, bot, left, leftOfCenter, center, rightOfCenter, right
}

enum MacroMoves: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case U, D, R, L, F, B
}

let MacroMovesStrings: [MacroMoves: String] = [MacroMoves.U: "LTMTMBXCMLTMCTMLTMC",
                  MacroMoves.D: "LBXCMLTMCTMRTMC",
                  MacroMoves.R: "LTMBXCMRTMCTMTMTM",
                  MacroMoves.L: "LTMTMTMBXCMLTMCTM",
                  MacroMoves.F: "TMLBXCTMRTMC",
                  MacroMoves.B: "TMTMTMLBXCTMRTMC"]

class SettingsModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var ipAddress: String = "10.0.0.51"
    @Published var settings = [Moves:String]()
    @Published var macroSettings = [MacroMoves:String]()
    var callServer: (URL) async throws -> (Data,URLResponse) = {
        try await URLSession.shared.data(from: $0)
    }
    
    func binding(for move: Moves) -> Binding<String> {
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
                if let move = Moves(rawValue: key), let value = json[key] {
                    settings[move] = value.formatted(.number.grouping(.never))
                }
            }
            //TODO copy JSON to model.value
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func sendSetting(setting: Moves) {
        guard let value = settings[setting] else {return}
        Task { @MainActor in
            errorMessage = nil
        }
        guard let url = URL(string: "http://\(ipAddress)/settings/\(setting.rawValue)/\(value)") else { return }
        Task{
            do{
                let (data, _ ) = try await callServer(url)
                await processData(data)
                moveSetting(setting: setting)
            } catch {
                Task { @MainActor in
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func moveSetting(setting: Moves) {
        Task { @MainActor in
            errorMessage = nil
        }
        guard let url = URL(string: "http://\(ipAddress)/\(setting.rawValue)") else { return }
        Task{
            do{
                let _ = try await callServer(url)
            } catch {
                Task { @MainActor in
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func macroMoveSetting(setting: MacroMoves) {
        Task { @MainActor in
            errorMessage = nil
        }
        MacroMovesStrings[setting]?.forEach {foo in
            guard let url = URL(string: "http://\(ipAddress)/\(foo)") else { return }
            Task{
                do{
                    let _ = try await callServer(url)
                } catch {
                    Task { @MainActor in
                        self.errorMessage = error.localizedDescription
                    }
                }
                try await Task.sleep(nanoseconds: 2_000_000_000_0)
            }
            print(url)
        }
        //loop through each letter in the MacroSetting string
            //set url for individual move
            //send url inside Task and do catch block
            //wait a small time to allow the robot to catch up
    }
    
    func getSetting() {
        Task { @MainActor in
            errorMessage = nil
        }
        guard let url = URL(string: "http://\(ipAddress)/settings") else { return }
        Task{
            do {
                let (data, _ ) = try await callServer(url)
                await processData(data)
            } catch {
                Task { @MainActor in
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

extension SettingsModel: CubeMovable {
    //this is where the delay will happen
    func move(to: Moves) async throws {
        //call robot here
        self.moveSetting(setting: to)
        try await Task.sleep(nanoseconds: 2_000_000_000)
    }
}

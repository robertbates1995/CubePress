//
//  SettingsViewModel.swift
//  CubePress
//
//  Created by Robert Bates on 2/17/23.
//

import Foundation
import SwiftUI

enum Move: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case top, mid, bot, left, leftOfCenter, center, rightOfCenter, right
}

enum MacroMove: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case U, D, R, L, F, B
}

let MacroMovesStrings: [MacroMove: String] = [MacroMove.U: "LTMTMBXCMLTMCTMLTMC",
                  MacroMove.D: "LBXCMLTMCTMRTMC",
                  MacroMove.R: "LTMBXCMRTMCTMTMTM",
                  MacroMove.L: "LTMTMTMBXCMLTMCTM",
                  MacroMove.F: "TMLBXCTMRTMCTMTM",
                  MacroMove.B: "TMTMTMLBXCTMRTMC"]

class SettingsModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var ipAddress: String = "10.0.0.50"
    @Published var settings = [Move:String]()
    @Published var macroSettings = [MacroMove:String]()
    var callServer: (URL) async throws -> (Data,URLResponse) = {
        try await URLSession.shared.data(from: $0)
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
    
    func sendSetting(setting: Move) {
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
    
    func moveSetting(setting: Move) {
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
    
    func macroMoveSetting(setting: MacroMove) {
        Task { @MainActor in
            errorMessage = nil
        }
        MacroMovesStrings[setting]?.forEach { step in
            guard let url = URL(string: "http://\(ipAddress)/\(step)") else { return }
            Task {
                do{
                    let _ = try await callServer(url)
                } catch {
                    Task { @MainActor in
                        self.errorMessage = error.localizedDescription
                    }
                }
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
    func move(to: Move) async throws {
        //call robot here
        self.moveSetting(setting: to)
        try await Task.sleep(nanoseconds: 2_000_000_000)
    }
    
    
    func macroMove(to: MacroMove) {
        Task {
            try await macroMoveCycle(to: to) //change this setting later
        }
    }
    
    func macroMoveCycle(to: MacroMove) async throws {
        //call robot here
        //self.macroMoveSetting(setting: to)
        for foo in MacroMovesStrings[to]! {
            switch (foo) {
            case "T":
                self.moveSetting(setting: Move.top)
            case "M":
                self.moveSetting(setting: Move.mid)
            case "B":
                self.moveSetting(setting: Move.bot)
            case "L":
                self.moveSetting(setting: Move.left)
            case "Z":
                self.moveSetting(setting: Move.leftOfCenter)
            case "C":
                self.moveSetting(setting: Move.center)
            case "X":
                self.moveSetting(setting: Move.rightOfCenter)
            case "R":
                self.moveSetting(setting: Move.right)
            default:
                return
            }
            try await Task.sleep(nanoseconds: 1_500_000_000)
        }
    }
}

//
//  Controler.swift
//  CubePress
//
//  Created by Robert Bates on 4/26/23.
//

import Foundation

class Mover: CubeMovable, ObservableObject {
    var errorMessage: String?
    var settings: SettingsModel
    var callServer: (URL) async throws -> (Data,URLResponse) = {
        try await URLSession.shared.data(from: $0)
    }
    
    init(settings: SettingsModel) {
        self.settings = settings
    }
    
    func input(move: String) async throws {
        Task { @MainActor in
            errorMessage = nil
        }
        guard let url = URL(string: "http://\(settings.ipAddress)/\(String(move))") else { return }
        print(url)
        do {
            let _ = try await callServer(url)
        } catch {
            Task { @MainActor in
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func input(moves: [String]) async throws {
        print(#function)
        for move in moves {
            try await input(move: String(move))
            try await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }
}

enum Move: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case top, mid, bot, left, center, right
}



let cubeFace: [String: String] = ["U": "TMTM",
                                   "D": "",
                                   "R": "LTMC",
                                   "L": "RTMC",
                                   "F": "TM",
                                   "B": "TMTMTM"]

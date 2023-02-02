//
//  NetworkButton.swift
//  CubePress
//
//  Created by Robert Bates on 2/1/23.
//

import SwiftUI
import Foundation

struct NetworkButtonView: View {
    var body: some View {
        Button("test arm") {
            Task {
                await sendMove()
            }
        }
    }
    
    func sendMove() async {
        guard let url = URL(string: "http://10.0.0.34/top") else { return }
        let _ = try? await URLSession.shared.data(from: url)
    }
}

struct NetworkButton_Previews: PreviewProvider {
    static var previews: some View {
        NetworkButtonView()
    }
}

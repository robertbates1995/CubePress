//
//  Slider.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

struct Setting: View, Identifiable {
    @State var sliderValue: Double = 0
    let title: String
    let buttonLabel: String
    let showButton: Bool
    var id = UUID()
    
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text("Value: \(sliderValue)")
            }
            Slider(value: $sliderValue, in: 1.0...100)
            if showButton == true {
                Button(action: { }) {
                    Text("\(buttonLabel)")
                }
            }
        }
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        List{
            Setting(title: "Test Title", buttonLabel: "Test Button", showButton: true)
        }
    }
}

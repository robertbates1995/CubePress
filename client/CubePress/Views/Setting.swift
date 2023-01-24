//
//  Slider.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

class SettingModel: ObservableObject, Identifiable {
    @Published var sliderValue: Double = 0
    let title: String
    let buttonLabel: String
    let showButton: Bool
    var id = UUID()
    
    init(sliderValue: Double, title: String, buttonLabel: String, showButton: Bool, id: UUID = UUID()) {
        self.sliderValue = sliderValue
        self.title = title
        self.buttonLabel = buttonLabel
        self.showButton = showButton
        self.id = id
    }
}

struct SettingView: View {
    @ObservedObject var model: SettingModel
    
    var body: some View {
        VStack {
            HStack {
                Text(model.title)
                Spacer()
                Text("Value: \(model.sliderValue)")
            }
            Slider(value: $model.sliderValue, in: 1.0...100)
            if model.showButton == true {
                Button(action: { }) {
                    Text("\(model.buttonLabel)")
                }
            }
        }
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        List{
            SettingView(model: .init(sliderValue: 10, title: "Test Title", buttonLabel: "Test Button", showButton: true))
        }
    }
}

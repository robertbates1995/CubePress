//
//  Slider.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var model: SettingViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(model.title)
                Spacer()
                Text("Value: \(model.sliderValue)")
            }
            Slider(value: $model.sliderValue, in: 1.0...100)
            if model.showButton == true {
                Button(action: {model.buttonPressed()}) {
                    Text("\(model.buttonLabel)")
                }
            }
        }
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        List{
            SettingView(model: .init(sliderValue: 10, title: "Test Title", buttonLabel: "Test Button", action: {}))
        }
    }
}

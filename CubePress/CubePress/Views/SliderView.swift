//
//  Slider.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

struct SliderView: View {
    @State private var sliderValue = 0.0
    
    var body: some View {
        VStack {
            Slider(value: $sliderValue)
        }
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        SliderView()
    }
}

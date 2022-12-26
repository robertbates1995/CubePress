//
//  Slider.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

struct SliderView: View {
    @State var sliderValue:Double = 0
    
    var body: some View {
        Slider(value: $sliderValue, in: 1.0...100) 
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        List{
            SliderView()
        }
    }
}

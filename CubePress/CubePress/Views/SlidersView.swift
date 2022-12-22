//
//  SlidersView.swift
//  CubePress
//
//  Created by Robert Bates on 12/21/22.
//

import SwiftUI

struct SlidersView: View  {
    
    var body: some View {
        List {
            SliderView()
            SliderView()
        }
    }
}

struct SlidersView_Previews: PreviewProvider {
    static var previews: some View {
        SlidersView()
    }
}

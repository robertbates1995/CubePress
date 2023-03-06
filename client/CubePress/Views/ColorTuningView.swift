//
//  colorTuningView.swift
//  CubePress
//
//  Created by Robert Bates on 3/6/23.
//

import SwiftUI

struct ColorTuningView: View {
    let image = UIImage(named: "rubik")!
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ColorTuningView_Previews: PreviewProvider {
    static var previews: some View {
        ColorTuningView()
    }
}

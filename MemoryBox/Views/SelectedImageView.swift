//
//  SelectedImageView.swift
//  MemoryBox
//
//  Created by gunner madsen on 10/29/21.
//

import SwiftUI

struct SelectedImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Button("Press to dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.title)
            .padding()
//            .background(Color.black)
//            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
        }
    }
}

struct SelectedImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedImageView()
    }
}

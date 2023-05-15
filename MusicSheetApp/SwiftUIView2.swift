//
//  SwiftUIView2.swift
//  MusicSheetApp
//
//  Created by Mateus on 10/05/23.
//

import SwiftUI

struct SwiftUIView2: View {
    
    var body: some View {
        VStack {
            // 1
            HStack(alignment: .top, spacing: 0) {
                Button(action: {}) {
                    Rectangle()
                        .stroke(.black)
                        .frame(width: 50, height: 100)
                }
                Button(action: {}) {
                    Rectangle()
                        .stroke(.black)
                        .frame(width: 50, height: 100)
                }
                Button(action: {}) {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 30, height: 75)
                }
                .frame(width: 0)
                .zIndex(1)
                Button(action: {}) {
                    Rectangle()
                        .stroke(.black)
                        .frame(width: 50, height: 100)
                }
            }
        }
    }
    
}

struct SwiftUIView2_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView2()
    }
}

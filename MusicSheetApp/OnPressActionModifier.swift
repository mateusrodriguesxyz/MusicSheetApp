//
//  OnPressActionModifier.swift
//  MusicSheetApp
//
//  Created by Mateus on 18/05/23.
//

import SwiftUI

struct OnPressActionModifier: ViewModifier {
    
    @Binding var isPressed: Bool
    
    let bounds: CGRect
    
    let action: () -> Void
        
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        
                        print("OnPressActionModifier for \(bounds)", value.location)
                        
                        if !isPressed {
                            action()
                            isPressed = true
                        }
                        
                        if !bounds.contains(value.location) {
                            isPressed = false
                        }
                            
                        
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
    }
    
}

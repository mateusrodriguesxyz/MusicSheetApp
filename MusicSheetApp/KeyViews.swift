//
//  KeyViews.swift
//  MusicSheetApp
//
//  Created by Mateus on 18/05/23.
//

import SwiftUI

struct WhiteKey: View {
        
    @Binding var isPressed: Bool
    
    let action: () -> Void
        
    var body: some View {
        ZStack {
            KeyShape(radius: 6)
                .fill(
                    AnyShapeStyle(isPressed ? .white.gradient : .white)
                        .shadow(.inner(color: .black, radius: 2))
                        
                )
            KeyShape(radius: 6)
                .stroke(.black)
            KeyShape(radius: 6)
                .strokeBorder(.black.opacity(0.1).gradient, lineWidth: 2)
        }
        .frame(width: 45, height: 200)
        .brightness(isPressed ? -0.1 : 0)
        .modifier(OnPressActionModifier(isPressed: $isPressed, bounds: CGRect(x: 0, y: 0, width: 45, height: 200), action: action))
    }
    
}

struct BlackKey: View {
    
    @Binding var isPressed: Bool
    
    let action: () -> Void
    
    var body: some View {
        ZStack {
            KeyShape(radius: 4)
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: isPressed ? 2 : 4)
                .padding(.horizontal, -0.5)
            KeyShape(radius: 4)
                .fill(
                    Color(hue: 0, saturation: 0, brightness: 0.1)
                        .gradient
                        .shadow(.inner(color: .black, radius: 2, y: -5))
                )
            KeyShape(radius: 4)
                .strokeBorder(.black.opacity(0.25).gradient, lineWidth: 2)
                .padding(.top, -1)
        }
        .brightness(isPressed ? 0.1 : 0)
        .frame(width: 27, height: 150)
        .modifier(OnPressActionModifier(isPressed: $isPressed, bounds: CGRect(x: 0, y: 0, width: 27, height: 150), action: action))
    }
    
}

struct KeyShape: InsettableShape {
    
    let radius: CGFloat
    
    var inset: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: inset, dy: inset), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
        
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.inset = amount
        return shape
    }
    
}

extension AnyShapeStyle {
    
    static func _open(_ style: some ShapeStyle) -> AnyShapeStyle {
        return AnyShapeStyle(style)
    }
    
    @_disfavoredOverload
    init(_ style: any ShapeStyle) {
        self = AnyShapeStyle._open(style)
    }
    
}

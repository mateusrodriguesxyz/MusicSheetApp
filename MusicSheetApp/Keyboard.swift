//
//  Keyboard.swift
//  MusicSheetApp
//
//  Created by Mateus on 12/05/23.
//

import Foundation
import SwiftUI

extension CGRect: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin.x)
        hasher.combine(origin.y)
        hasher.combine(size.width)
        hasher.combine(size.height)
    }
    
}

struct Keyboard {
    
    struct Key: Hashable {
        
        let note: Note
        var isPressed: Bool
        var rect: CGRect
        
    }
    
    var keys: [Key] = build(from: Note(midi: 24, _note: .c), count: 35).map({ Key(note: $0, isPressed: false, rect: .zero) })
    
}

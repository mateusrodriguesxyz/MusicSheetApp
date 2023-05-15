//
//  Keyboard.swift
//  MusicSheetApp
//
//  Created by Mateus on 12/05/23.
//

import Foundation

struct Keyboard {
    
    struct Key: Hashable {
        
        let note: Note
        var isPressed: Bool
        
    }
    
    var keys: [Key] = build(from: Note(midi: 60, _note: .c), count: 35).map({ Key(note: $0, isPressed: false) })
    
    var keyRects: [Key: CGRect] = [:]
    
        
}

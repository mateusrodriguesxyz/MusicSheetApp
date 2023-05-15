//
//  Note.swift
//  MusicSheetApp
//
//  Created by Mateus on 12/05/23.
//

import Foundation

func build(from note: Note, count: Int) -> [Note] {
    
    var notes: [Note] = []
    
    notes.append(note)
    
    for _ in 1 ... count {
        notes.append(Note(midi: notes.last!.midi + 1, _note: notes.last!._note.next()))
    }
    
    return notes
    
}

struct Note: Hashable {
    
    let midi: Int
    let _note: _Note
    
    var hasAccidental: Bool { _note.hasAccidental }
    
    func next() -> Note {
        return Note(midi: midi + 1, _note: _note.next())
    }
    
}

extension Note: CustomStringConvertible {
    
    var description: String {
        
        let octave = Int(midi / 12)
        
        return _note.description(octave: octave)
        
    }
    
}

enum _Note: Int {
    
    case c = 1
    case c_
    case d
    case d_
    case e
    case f
    case f_
    case g
    case g_
    case a
    case a_
    case b
    
    var hasAccidental: Bool {
        switch self {
            case .c, .d, .e, .f, .g, .a, .b:
                return false
            case .c_, .d_, .f_, .g_, .a_:
                return true
        }
    }
    
    func next() -> _Note {
        if rawValue == 12 {
            return _Note.c
        } else {
            return _Note(rawValue: rawValue + 1)!
        }
    }
    
    func description(octave: Int) -> String {
        switch self {
            case .c:
                return "C\(octave)"
            case .c_:
                return "C\(octave)#"
            case .d:
                return "D\(octave)"
            case .d_:
                return "D\(octave)#"
            case .e:
                return "E\(octave)"
            case .f:
                return "F\(octave)"
            case .f_:
                return "F\(octave)#"
            case .g:
                return "G\(octave)"
            case .g_:
                return "G\(octave)#"
            case .a:
                return "A\(octave)"
            case .a_:
                return "A\(octave)#"
            case .b:
                return "B\(octave)"
        }
    }
    
}

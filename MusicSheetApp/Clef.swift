import Foundation
import AudioToolbox

struct Clef {
    
    enum Placement {
        case line
        case space
    }
    
    let middleNote: Int
    let lowerNote: Int
    let uperNote: Int
    
    let notes: [Int]
    
    static let g = Clef(
        middleNote: 71, lowerNote: 64, uperNote: 77,
        notes: [59, 60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81]
    )
    
    func distance(of note: Int) -> Int {
        guard let indexOfMiddleNote = notes.firstIndex(of: middleNote) else {
            return 0
        }
        guard let indexOfNote = notes.firstIndex(of: note) else {
            return 0
        }
        return indexOfNote - indexOfMiddleNote
    }
    
    func position(of note: Int) -> Placement {
        if distance(of: note).isMultiple(of: 2) {
            return .line
        } else {
            return .space
        }
    }
    
}

struct SheetNote {
    let midi: Int
    let duration: Int
}

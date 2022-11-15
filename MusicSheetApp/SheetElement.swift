import AudioToolbox

enum SheetElement {
    case note(value: Int, duration: Int = 1)
    case rest(duration: Int = 1)
    case space
}

extension [SheetElement] {
    
    func expanded() -> [SheetElement] {
        
        var elements = [SheetElement]()
        
        for element in self {
            elements.append(element)
            switch element {
                case .note(_, let duration):
                    if duration > 1 {
                        elements.append(contentsOf: Array(repeating: .space, count: duration - 1))
                    }
                case .rest(let duration):
                    if duration > 1 {
                        elements.append(contentsOf: Array(repeating: .space, count: duration - 1))
                    }
                case .space:
                    continue
            }
        }
        
        return elements
        
    }
    
}

extension [SheetElement] {
    
    var musicSequence: MusicSequence {
        
        var sequence: MusicSequence!
        
        _ = NewMusicSequence(&sequence)
        
        var track: MusicTrack!
        
        _ = MusicSequenceNewTrack(sequence, &track)
        
        var time: MusicTimeStamp = 0.0
        
        var chanmess: MIDIChannelMessage!
        
        chanmess = MIDIChannelMessage(status: 0xC0, data1: UInt8(40), data2: 0, reserved: 0)
        
        MusicTrackNewMIDIChannelEvent(track!, time, &chanmess)
        
        for element in self {
            switch element {
                case .note(let note, let duration):
                    var message = MIDINoteMessage(
                        channel: 0,
                        note: UInt8(note),
                        velocity: 64,
                        releaseVelocity: 0,
                        duration: Float32(duration)
                    )
                    _ = MusicTrackNewMIDINoteEvent(track, time, &message)
                    time += MusicTimeStamp(duration)
                case .rest(let duration):
                    
                    chanmess = MIDIChannelMessage(status: 0xC0, data1: UInt8(115), data2: 0, reserved: 0)
                    
                    MusicTrackNewMIDIChannelEvent(track!, time, &chanmess)
                    
                    for _ in 1...duration {
                        var message = MIDINoteMessage(
                            channel: 0,
                            note: UInt8(60),
                            velocity: 64,
                            releaseVelocity: 0,
                            duration: 1
                        )
                        _ = MusicTrackNewMIDINoteEvent(track, time, &message)
                        time += 1
                    }
                    
                    chanmess = MIDIChannelMessage(status: 0xC0, data1: UInt8(40), data2: 0, reserved: 0)
                    
                    MusicTrackNewMIDIChannelEvent(track!, time, &chanmess)
                    
                case .space:
                    break
            }
        }
        
        return  sequence
        
    }
    
}

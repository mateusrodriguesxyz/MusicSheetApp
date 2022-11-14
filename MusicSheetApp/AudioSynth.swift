import AVFoundation
import AudioToolbox


class AudioSynth: ObservableObject {
    
    let sampler = AVAudioUnitSampler()
    let engine = AVAudioEngine()
    
    lazy var sequencer = AVAudioSequencer(audioEngine: engine)
    
    init() {
        
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        
        try! engine.start()
        
        let bankURL = Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2")!
        
        sampler.load(.violin, from: bankURL)
        
    }
    
    func play(_ notes: [Int]) {
        
        sequencer.stop()
        
        sequencer.currentPositionInBeats = TimeInterval(0)
        
        let sequence = makeSequence(from: notes)
        
        try! sequencer.load(from: sequence.data, options: AVMusicSequenceLoadOptions())
        
        sequencer.prepareToPlay()
        
        try! sequencer.start()
        
    }
    
    
    
}

public func makeSequence(from notes: [Int]) -> MusicSequence {
    
    var sequence: MusicSequence!
    
    _ = NewMusicSequence(&sequence)
    
    var track: MusicTrack!
    
    _ = MusicSequenceNewTrack(sequence, &track)
    
    var time: MusicTimeStamp = 0.0
    
    var inMessage = MIDIChannelMessage(status: 0xE0, data1: 120, data2: 0, reserved: 0)
    MusicTrackNewMIDIChannelEvent(track, time, &inMessage)
    // set msb to 120 and lsb to 0
    
    inMessage = MIDIChannelMessage(status: 0xC0, data1: 20, data2: 0, reserved: 0)
    MusicTrackNewMIDIChannelEvent(track, time, &inMessage)
    
    for (index, note) in notes.enumerated() {
        var message = MIDINoteMessage(
            channel: 0,
            note: UInt8(note),
            velocity: 64,
            releaseVelocity: 0,
            duration: 1
        )
        _ = MusicTrackNewMIDINoteEvent(track, time, &message)
        
        time += 1
    }
    
    return  sequence
    
}

extension MusicSequence {
    
    public var data: Data {
        
        var outputData: Unmanaged<CFData>?
        
        _ = MusicSequenceFileCreateData(
            self,
            .midiType,
            .eraseFile,
            0,
            &outputData
        )
        
        let data = outputData!.takeUnretainedValue() as Data
        
        outputData?.release()
        
        return data
    }
    
}

extension AVAudioUnitSampler {
    
    public func load(_ instrument: Instrument, from bankURL: URL) {
        try! self.loadSoundBankInstrument(
            at: bankURL,
            program: UInt8(instrument.program),
            bankMSB: UInt8(instrument.msb),
            bankLSB: UInt8(instrument.lsb)
        )
//        try! loadSoundBankInstrument(
//            at: bankURL,
//            program: 0,
//            bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
//            bankLSB: UInt8(kAUSampler_DefaultBankLSB)
//        )
    }
    
}

public struct Instrument {
    var name: String
    var program: Int
    var lsb: Int
    var msb: Int
}

extension Instrument {
    public static var violin = Instrument(name: "Violin", program: 40, lsb: 0, msb: 121)
    public static var woodBlock = Instrument(name: "Wood Block", program: 115, lsb: 0, msb: 121)
}

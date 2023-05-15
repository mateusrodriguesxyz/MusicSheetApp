import SwiftUI

//struct ScoreSheetView: View {
//    
//    let clef: Clef
//    
//    let elements: [SheetElement]
//    
//    let selected: Int
//    
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0) {
//                ForEach(0..<4) { i in
//                    Rectangle()
//                        .stroke(.foreground, lineWidth: 5)
//                }
//            }
//            HStack(spacing: 50) {
//                let indexedElements = Array(elements.expanded().enumerated())
//                ForEach(indexedElements, id: \.offset) { (index, element) in
//                    Group {
//                        switch element {
//                            case .note(let note, let duration):
//                                makeNoteView(note, duration: duration)
//                            case .rest:
//                                makeRestView()
//                            case .space:
//                                Color.clear
//                        }
//                    }
//                    .frame(width: 60)
//                    .frame(maxHeight: .infinity)
//                    .border(selected == index ? .blue : .clear)
//                }
//            }
//        }
//        .frame(height: 200)
//    }
//    
//    func makeNoteView(_ note: Int, duration: Int) -> some View {
//        Group {
//            let dx = -25 * CGFloat(clef.distance(of: note))
//            let position = clef.position(of: note)
//            Group {
//                if dx > 0 {
//                    ScoreNoteWithTopStem(duration: duration)
//                } else {
//                    ScoreNoteWithBottomStem(duration: duration)
//                }
//            }
//            .overlay {
//                if  position == .line, note < clef.lowerNote || note > clef.uperNote {
//                    Rectangle()
//                        .fill(.foreground)
//                        .frame(width: 100, height: 5)
//                }
//            }
//            .offset(y: dx)
//            .compositingGroup()
//        }
//    }
//    
//    func makeRestView() -> some View {
//        Rectangle()
//            .frame(height: 25)
//            .alignmentGuide(VerticalAlignment.center) { $0[.bottom] }
//    }
//    
//}
//
//struct ContentView: View {
//    
//    @State var selected = -1
//    
//    @StateObject var synth = AudioSynth()
//    
//    @State var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
//    
//    let elements: [SheetElement] = [
//        .note(value: 64, duration: 2),
//        .rest(duration: 2),
//        .note(value: 71, duration: 1),
//        .note(value: 72, duration: 1),
//    ]
//    
//    var body: some View {
//        VStack {
//            ScoreSheetView(clef: .g, elements: elements, selected: selected)
//                .padding(.vertical, 100)
//            Button("Play Sequence") {
//                selected = 0
//                timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
//                synth.play(elements.musicSequence)
//            }
//            .buttonStyle(.borderedProminent)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear() {
//            timer.upstream.connect().cancel()
//        }
//        .onReceive(timer) { _ in
//            if selected >= 0 {
//                selected += 1
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

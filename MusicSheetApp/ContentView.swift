import SwiftUI

struct SheetView: View {
    
    @StateObject var synth = AudioSynth()
    
    @State var highlighted = -1
    
    let clef: Clef
    
    let elements: [SheetElement]
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 50) {
            
            let indexedElements = Array(elements.expanded().enumerated())

            ForEach(indexedElements, id: \.offset) { (index, element) in
                Group {
                    switch element {
                        case .note(let note, _):
                            makeNoteView(note)
                        case .rest:
                            makeRestView()
                        case .space:
                            Color.clear
                                .frame(width: 50)
                    }
                }
                .frame(maxHeight: .infinity)
                .border(index == highlighted  ? .blue : .clear)
            }
        }
//        .onReceive(timer) { _ in
//            if highlighted == -1 {
//                let notes = elements.compactMap { element in
//                    if case let .note(value, _) = element {
//                        return value
//                    } else {
//                        return nil
//                    }
//                }
//                synth.play(notes)
//            }
//            if highlighted == elements.expanded().count - 1 {
//                highlighted = -1
//            } else {
//                highlighted += 1
//            }
//        }
    }
    
    func makeNoteView(_ note: Int) -> some View {
        Group {
            let dx = -25 * CGFloat(clef.distance(of: note))
            
            let position = clef.position(of: note)
            
            Button {
//                synth.play([note])
            } label: {
                Rectangle()
                    .fill(.clear)
                    .overlay {
                        Image("QuarterNote")
                            .resizable()
                            .overlay(alignment: .trailing) {
                                Rectangle()
                                    .fill(.foreground)
                                    .frame(width: 10, height: 165)
                                    .alignmentGuide(VerticalAlignment.center) {
                                        $0[.bottom] + 10
                                    }
                            }
                    }
                    .compositingGroup()
                    .frame(width: 50, height: 50)
            }
            .buttonStyle(.plain)
            .overlay {
                if  position == .line, note < clef.lowerNote || note > clef.uperNote {
                    Rectangle()
                        .fill(.foreground)
                        .frame(width: 100, height: 1)
                }
            }
            .offset(y: dx)
        }
    }
    
    func makeRestView() -> some View {
        Rectangle()
            .fill(.foreground)
            .frame(width: 50, height: 25)
            .alignmentGuide(VerticalAlignment.center) { $0[.bottom] }
    }
    
}

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<4) { i in
                    Color.clear
                        .frame(height: 50)
                        .overlay(alignment: .bottom) {
                            if i != 3 {
                                Rectangle()
                                    .fill(.foreground)
                                    .frame(height: 1)
                            }
                        }
                }
            }
            SheetView(clef: .g, elements: [
                .note(value: 60, duration: 1),
                .note(value: 62, duration: 1),
                .note(value: 64, duration: 1),
                .note(value: 65, duration: 1),
                .note(value: 67, duration: 1),
                .note(value: 69, duration: 1),
                .note(value: 71, duration: 1),
                .note(value: 72, duration: 1),
            ])
        }
        .frame(height: 200)
        .border(.foreground)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

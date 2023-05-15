//
//  MusicSheetAppApp.swift
//  MusicSheetApp
//
//  Created by Mateus Rodrigues on 12/11/22.
//

import SwiftUI

@main
struct MusicSheetAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    
    @StateObject var synth = AudioSynth()
    
    @State var recordedNotes: [Note] = []
        
    @State var isRecording = false
    
    @State var keyboard = Keyboard()
    
    @State var currentPressedNote: Note?
    
    let keyWidth: CGFloat = 45
    
    var body: some View {
        VStack {
            
//            HStack {
//                Button {
//                    isRecording.toggle()
//                } label: {
//                    Image(systemName: isRecording ? "stop.circle.fill" : "record.circle.fill")
//                        .foregroundColor(isRecording ? .red : .green)
//                }
//                Button {
//                    synth.play(recordedNotes.map(\.midi))
//                } label: {
//                    Image(systemName: "play.circle.fill")
//                }
//
//            }
//            .font(.largeTitle)
//
//            ScrollView(.horizontal) {
//                HStack {
//                    ForEach(Array(recordedNotes.enumerated()), id: \.offset) { (_, note) in
//                        Text(note.description)
//                    }
//                    if !recordedNotes.isEmpty {
//                        Button {
//                            recordedNotes.removeLast()
//                        } label: {
//                            Image(systemName: "delete.left.fill")
//                        }
//                    }
//
//                }
//            }
//            .frame(height: 50)
//            .padding()
            
//            Picker(selection: $synth.instrument) {
//                ForEach(synth.instruments) { instrument in
//                    Text(instrument.name)
//                        .tag(instrument)
//                }
//            } label: {
//                EmptyView()
//            }
//            .font(.callout)
            
            HStack(alignment: .top, spacing: 0) {
                ForEach(keyboard.keys, id: \.note.midi) { key in
                    
                    Group {
                        if key.note.hasAccidental {
                            makeBlackKey(for: key.note)
                        } else {
                            makeWhiteKey(for: key.note)
                        }
                    }
                    .overlay {
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    keyboard.keyRects[key] = proxy.frame(in: .named("keyboard"))
//                                    frames.append(NoteFramePair(note: key.note.midi, frame: proxy.frame(in: .named("keyboard"))))
                                }
                        }
                    }
                    
                }
            }
            .coordinateSpace(name: "keyboard")
            .simultaneousGesture(
                DragGesture(minimumDistance: 5)
                    .onChanged { value in
                                  
                        guard value.location.y >= 150 else { return }
                        
                        for (key, rect) in keyboard.keyRects where key.note.hasAccidental == false {
                            
                            if rect.contains(value.location), key.note != currentPressedNote {
                                currentPressedNote = key.note
                                synth.play([key.note.midi])
                            }
                            
                        }
                    }
                    .onEnded { _ in
                        currentPressedNote = nil
                    }
            )
//            .padding(.top, 150)
            .overlay(alignment: .top) {
                Color.black.frame(height: 2)
                    .padding(.horizontal, -0.5)
                    .offset(y: -1)
            }
            .background {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .padding(.all, -4)
            }
        }
    }
    
    func makeWhiteKey(for note: Note) -> some View {
        WhiteKey(externalIsPressed: currentPressedNote == note) {
//            currentPressedNote = nil
            print("TapGesture")
            play(note)
        }
        .overlay(alignment: .bottom) {
            Text(note.description)
                .font(.caption2)
                .monospaced()
                .foregroundStyle(.gray.gradient)
                .padding(.bottom)
        }
    }
    
    func makeBlackKey(for note: Note) -> some View {
        BlackKey {
            print("TapGesture")
            play(note)
        }
        .overlay(alignment: .bottom) {
            Text(note.description)
                .font(.caption2)
                .monospaced()
                .foregroundStyle(.gray.gradient)
                .padding(.bottom)
        }
        .frame(width: 0)
        .zIndex(1)
    }
    
    private func play(_ note: Note) {
        synth.play([note.midi])
        if isRecording {
            recordedNotes.append(note)
        }
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
        var key = self
        key.inset = amount
        return key
    }
    
}

struct WhiteKey: View {
    
    let externalIsPressed: Bool
    
    @State private var isPressed = false
    
    let action: () -> Void
    
    private var __isPressed: Bool { (externalIsPressed || isPressed) }
    
    var body: some View {
        ZStack {
            KeyShape(radius: 6)
                .fill(
                    AnyShapeStyle(__isPressed ? .white.gradient : .white)
                        .shadow(.inner(color: .black, radius: 2))
                        
                )
            KeyShape(radius: 6)
                .stroke(.black)
            KeyShape(radius: 6)
                .strokeBorder(.black.opacity(0.1), lineWidth: 2)
        }
        .frame(width: 45, height: 200)
        .brightness(__isPressed ? -0.1 : 0)
        .modifier(OnPressActionModifier(isPressed: $isPressed, bounds: CGRect(x: 0, y: 0, width: 45, height: 200), action: action))
        .overlay(alignment: .bottom) {
            HStack {
                Image(systemName: "i.circle.fill")
                    .foregroundColor(isPressed ? .green : .red)
                Image(systemName: "e.circle.fill")
                    .foregroundColor(externalIsPressed ? .green : .red)
            }
            .font(.caption)
            .offset(y: 50)
        }
    }
    
}

struct BlackKey: View {
    
    @State private var isPressed = false
    
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
                .strokeBorder(.black.opacity(0.25), lineWidth: 2)
                .padding(.top, -1)
        }
        .brightness(isPressed ? 0.1 : 0)
        .frame(width: 27, height: 150)
        .modifier(OnPressActionModifier(isPressed: $isPressed, bounds: CGRect(x: 0, y: 0, width: 27, height: 150), action: action))
    }
    
}

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

extension AnyShapeStyle {
    
    static func _open(_ style: some ShapeStyle) -> AnyShapeStyle {
        return AnyShapeStyle(style)
    }
    
    @_disfavoredOverload
    init(_ style: any ShapeStyle) {
        self = AnyShapeStyle._open(style)
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            HStack {
                WhiteKey(externalIsPressed: false, action: {})
                WhiteKey(externalIsPressed: true, action: {})
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewInterfaceOrientation(.landscapeLeft)
        
    }
}

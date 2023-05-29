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

struct Glissando {
    
    var lastPressedKey: Binding<Keyboard.Key>?
    
    var allKeys: Binding<[Keyboard.Key]>!
    
    mutating func handle(_ location: CGPoint) {
               
        release()
        
        guard let keyForLocation = allKeys.first(where: { $key in
            key.rect.contains(location) && key.note.hasAccidental == false
        }) else {
            return
        }
        
        print(keyForLocation.wrappedValue.note.description)
        
        keyForLocation.wrappedValue.isPressed = true
        
        lastPressedKey = keyForLocation
        
    }
    
    mutating func release() {
        lastPressedKey?.wrappedValue.isPressed = false
    }
    
}

struct ContentView: View {
    
    @StateObject var synth = AudioSynth()
    
    @State var isRecording = false
    
    @State var keyboard = Keyboard()
    
    @State var glissando = Glissando()
    
    @State var glissandos = [Int: Glissando]()
            
    var body: some View {
        VStack {
            
            HStack {
                
                Button {
                    if isRecording {
                        synth.stopRecording()
                    } else {
                        synth.startRecording()
                    }
                    isRecording.toggle()

                } label: {
                    Image(systemName: isRecording ? "stop.circle.fill" : "record.circle.fill")
                }
                
                Button {
                    synth.playRecording()
                } label: {
                    Image(systemName: "play.circle.fill")
                }
                .disabled(isRecording)

            }
            .font(.largeTitle)
            
            Picker(selection: $synth.instrument) {
                ForEach(synth.instruments) { instrument in
                    Text(instrument.name)
                        .tag(instrument)
                }
            } label: {
                EmptyView()
            }
            .font(.callout)
            
            HStack(alignment: .top, spacing: 0) {
                ForEach($keyboard.keys, id: \.note.midi) { $key in
                    
                    Group {
                        if key.note.hasAccidental {
                            makeBlackKey(for: $key)
                        } else {
                            makeWhiteKey(for: $key)
                        }
                    }
                    .onChange(of: key.isPressed) {
                        switch $0 {
                            case true:
                                synth.start(key.note.midi)
                            case false:
                                synth.stop(key.note.midi)
                        }
                    }
                    .overlay {
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    key.rect = proxy.frame(in: .named("keyboard"))
                                }
                        }
                    }
                    
                }
            }
            .coordinateSpace(name: "keyboard")
            .overlay(alignment: .top) {
                Color.black.frame(height: 2)
                    .padding(.horizontal, -0.5)
                    .offset(y: -1)
            }
            .background {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemBackground.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))).gradient)
                    .padding(.all, -8)
            }
            .onAppear {
                glissando.allKeys = $keyboard.keys
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
    
    func makeWhiteKey(for key: Binding<Keyboard.Key>) -> some View {
        WhiteKey(isPressed: key.isPressed, action: {})
            .simultaneousGesture(
                DragGesture(minimumDistance: 5, coordinateSpace: .named("keyboard"))
                    .onChanged { value in
                        guard value.location.y >= 150 else { return }
                        
                        let id = key.wrappedValue.note.midi
                        
                        if glissandos[id] == nil {
                            glissandos[id] = Glissando()
                            glissandos[id]?.allKeys = $keyboard.keys
                        }
                        
                        glissandos[id]?.handle(value.location)
                    }
                    .onEnded { _ in
                        
                        let id = key.wrappedValue.note.midi
                        
                        glissandos[id]?.release()
                    }
            )
            .overlay(alignment: .bottom) {
                Text(key.wrappedValue.note.description)
                    .font(.caption2)
                    .monospaced()
                    .foregroundStyle(.gray.gradient)
                    .padding(.bottom)
            }
    }
    
    func makeBlackKey(for key: Binding<Keyboard.Key>) -> some View {
        BlackKey(isPressed: key.isPressed, action: {})
            .overlay(alignment: .bottom) {
                Text(key.wrappedValue.note.description)
                    .font(.caption2)
                    .monospaced()
                    .foregroundStyle(.gray.gradient)
                    .padding(.bottom)
            }
            .frame(width: 0)
            .zIndex(1)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
            .previewInterfaceOrientation(.landscapeLeft)
            
    }
}

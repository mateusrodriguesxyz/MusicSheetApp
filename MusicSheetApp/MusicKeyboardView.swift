//
//  MusicKeyboardView.swift
//  MusicSheetApp
//
//  Created by Mateus Rodrigues on 01/05/23.
//

import SwiftUI

//struct WhiteKeyView: View {
//    
//    var body: some View {
//        Rectangle()
//            .stroke(.black)
//            .frame(width: 50, height: 200)
//            .contentShape(Rectangle())
//    }
//    
//}
//
//struct BlackKeyView: View {
//    
//    var body: some View {
//        Rectangle()
//            .fill(.black)
//            .frame(width: 50, height: 150)
//            .offset(x: 25)
//    }
//    
//}
//
//struct MusicKeyboardView: View {
//    
//    @StateObject var synth = AudioSynth()
//    
//    let elements: [SheetElement] = [
//        .note(value: 64, duration: 1),
////        .rest(duration: 2),
////        .note(value: 71, duration: 1),
////        .note(value: 72, duration: 1),
//    ]
//    
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            HStack(spacing: 0) {
//                WhiteKeyView()
//                    .onTapGesture {
//                        synth.play([64])
//                    }
//                WhiteKeyView()
//                    .onTapGesture {
//                        synth.play([66])
//                    }
//                WhiteKeyView()
//                    .onTapGesture {
//                        synth.play([68])
//                    }
//                WhiteKeyView()
//                    .onTapGesture {
//                        synth.play([69])
//                    }
//                WhiteKeyView()
//                    .onTapGesture {
//                        synth.play([71])
//                    }
//                WhiteKeyView()
//                    .onTapGesture {
//                        synth.play([73])
//                    }
//                WhiteKeyView()
//                    .onTapGesture {
//                        synth.play([75])
//                    }
//                WhiteKeyView()
//                    .onTapGesture {
//                        synth.play([76])
//                    }
//            }
//            HStack(spacing: 0) {
//                BlackKeyView()
//            }
//        }
//        
//    }
//}
//
//struct MusicKeyboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MusicKeyboardView()
//    }
//}

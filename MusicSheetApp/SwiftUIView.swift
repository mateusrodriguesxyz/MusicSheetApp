//
//  SwiftUIView.swift
//  MusicSheetApp
//
//  Created by Mateus Rodrigues on 14/11/22.
//

import SwiftUI
import Charts

struct ScoreNoteWithTopStem: View {
    
    let duration: Int
    
    var body: some View {
        Image("note\(duration).top.stem")
            .resizable()
            .scaledToFit()
            .overlay(alignment: .topTrailing) {
                GeometryReader { proxy in
                    Rectangle()
                        .frame(width: proxy.size.height/10, height: 3*proxy.size.height)
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                }
                .alignmentGuide(.top) {
                    $0[.bottom]
                }
            }
    }
    
}

struct ScoreNoteWithBottomStem: View {
    
    let duration: Int
    
    var body: some View {
        Image("note\(duration).bottom.stem")
            .resizable()
            .scaledToFit()
            .overlay(alignment: .bottomLeading) {
                GeometryReader { proxy in
                    Rectangle()
                        .frame(width: proxy.size.height/10, height: 3*proxy.size.height)
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
                }
                .alignmentGuide(.bottom) {
                    $0[.top]
                }
            }
    }
    
}

struct ScoreNote: View {
    
    enum StemPosition {
        case top
        case bottom
    }
    
    var stemPosition: StemPosition = .top
    
    var body: some View {
        switch stemPosition {
            case .top:
                ScoreNoteWithTopStem(duration: 1)
            case .bottom:
                ScoreNoteWithBottomStem(duration: 1)
        }
    }
    
}

struct SwiftUIView: View {
    
    let noteHeadWidth: CGFloat = 120
    let noteHeadHeight: CGFloat = 100

    
    @State var noteHeadSize = CGSize.zero
    @State var noteStemSize = CGSize.zero
    
    var body: some View {
        
        VStack(spacing: 0) {
            Rectangle()
                .stroke(.black, lineWidth: 5)
                .overlay {
                    ScoreNote(stemPosition: .top)
                        .offset(x: 100)
                }
            Rectangle()
                .stroke(.black, lineWidth: 5)
            Rectangle()
                .stroke(.black, lineWidth: 5)
                .overlay {
                    ScoreNote(stemPosition: .bottom)
                }
            Rectangle()
                .stroke(.black, lineWidth: 5)
        }
        .frame(height: 200)
    }
    
    func makeNoteTopStem() -> some View {
        Image("quarter.note.top.stem")
            .resizable()
            .scaledToFit()
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            noteHeadSize = proxy.size
                        }
                }
            }
            .overlay(alignment: .topTrailing) {
                GeometryReader { proxy in
                    Rectangle()
                        .overlay {
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        noteStemSize = proxy.size
                                    }
                            }
                        }
                        .frame(width: proxy.size.height/10, height: 3*proxy.size.height)
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                }
                .alignmentGuide(.top) { $0[.bottom] }
            }
    }
    
    func makeNoteBottomStem() -> some View {
        Image("quarter.note.bottom.stem")
            .resizable()
            .scaledToFit()
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            noteHeadSize = proxy.size
                        }
                }
            }
            .overlay(alignment: .bottomLeading) {
                GeometryReader { proxy in
                    Rectangle()
                        .fill(.black)
                        .overlay {
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        noteStemSize = proxy.size
                                    }
                            }
                        }
                        .frame(width: proxy.size.height/10, height: 3*proxy.size.height)
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
                }
                .alignmentGuide(.bottom) { $0[.top] }
            }
    }
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

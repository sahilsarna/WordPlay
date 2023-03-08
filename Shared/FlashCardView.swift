//
//  FlashCardView.swift
//  GREWordPlay
//
//  Created by Sahil Sarna on 3/4/23.
//

import SwiftUI
import AVFoundation

struct CardWordView: View{
    let word: String
    let definition: String
    let color: Color
    let type: String
    let example: String
    @Binding var degree : Double
    
    init(_ word: String, definition: String, type: String, example: String, color: Color, degree: Binding<Double>){
        self.word = word
        self.definition = definition
        self.type = type
        self.color = color
        self.example = example
        self._degree = degree
    }
    
//    init(_ word: Int, color: Color){
//        self.content = String(content)
//        self.color = color
//    }
    
    var body: some View{
        Text(word)
            .font(.system(size:50))
            .fontWeight(.semibold)
            .minimumScaleFactor(0.02)
            .padding(15)
            .scaledToFit()
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 300, maxHeight: 350)
            .background(color)
            .cornerRadius(16)
            .shadow(color: .gray, radius: 20, x:0, y: 0)
            .rotation3DEffect(Angle(degrees: degree), axis: (x:0, y:1, z:0))

//        VStack{
//            Text(type.uppercased())
//                .font(.title2)
//                .frame(maxWidth: 300)
//            Text(word)
//                .font(.system(size:50))
//                .fontWeight(.semibold)
//                .minimumScaleFactor(0.02)
//                .padding(15)
//                .scaledToFit()
//                .lineLimit(1)
//                .multilineTextAlignment(.center)
//                .frame(maxWidth: 300, maxHeight: 350)
//                .background(color)
//                .cornerRadius(16)
//                .shadow(color: .gray, radius: 20, x:0, y: 0)
//            Text(definition.capitalized)
//                .font(.title2)
//                .multilineTextAlignment(.center)
//                .frame(maxWidth: 300)
//        }
//        .padding(20.0)
//        .multilineTextAlignment(.center)
        
    }
}

struct CardExampleView: View{
    let example: String
    let color: Color
    @Binding var degree : Double
    
    init(example: String, color: Color, degree: Binding<Double>) {
        self.example = example
        self.color = color
        self._degree = degree
    }
    
    var body: some View{
        Text(example)
            .font(.title2)
            .padding(20)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 300, maxHeight: 350)
            .background(color)
            .cornerRadius(16)
            .shadow(color: .gray, radius: 2, x:0, y: 0)
            .rotation3DEffect(Angle(degrees: degree), axis: (x:0, y:1, z:0))
    }

}

struct FlashCardView: View {
    
    var words = readCSV(from: "1000 GRE Words")
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    
    let durationAndDelay : CGFloat = 0.2
    
    let synth = AVSpeechSynthesizer()
    
    //let numbers: [Int] = Array(1...30)
    func flipCard(){
        isFlipped = !isFlipped
        if isFlipped{
            withAnimation(.linear(duration: durationAndDelay)){
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        }else{
            withAnimation(.linear(duration: durationAndDelay)){
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    
    private func readOut(text: String){
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        
        synth.speak(utterance)
    }
    
    var body: some View {
        TabView{
            ForEach(words.shuffled(), id: \.id){i in
                VStack{
                    Text(i.partOfSpeech.uppercased())
                        .font(.title2)
                        .frame(maxWidth: 300)
                    ZStack{
                        CardExampleView(example: i.example, color: .yellow, degree: $frontDegree)
                        CardWordView(i.word, definition: i.definition, type: i.partOfSpeech, example: i.example, color: .yellow, degree: $backDegree)
                    }.onTapGesture {
                        flipCard()
                    }
                    Text(i.definition.capitalized)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                    Button("Pronounce"){
                        readOut(text: i.word)
//                        let utterance = AVSpeechUtterance(string: "Hello")
//                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//                        utterance.rate = 0.3
//
////                        let synth = AVSpeechSynthesizer()
//                        synth.speak(utterance)
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never) )
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView()
    }
}

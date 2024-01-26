//
//  ContentView.swift
//  SentimentAnalysis
//
//  Created by Adrien CHENU on 1/26/24.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var modelOutput: Sentiment? = nil
    
    enum Sentiment: String {
        case positive = "POSITIVE"
        case negative = "NEGATIVE"
        case mixed = "MIXED"
        case neutral = "NEUTRAL"


        func getEmoji() -> String{
            switch self{
            case .positive:
                return "😃"
            case .negative:
                return "😡"
            case .mixed:
                return "🤔"
            case .neutral:
                return "😑"
            }
        }
    }

    
    private func backgroundColor(for sentiment: Sentiment) -> Color {
        switch sentiment {
        case .positive:
            return Color.green
        case .negative:
            return Color.red
        case .mixed:
            return Color.orange
        case .neutral:
            return Color.gray
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Entrez une phrase, l'IA va deviner votre sentiment")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                
                TextEditor(text: $inputText)
                    .padding()
                    .frame(height:200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button("Deviner le sentiment") {
                    classify()
                }
                .font(.headline)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8.0)
                
                Spacer()
                
                                
                if let sentiment = modelOutput{
                    Text("\(sentiment.rawValue) \(sentiment.getEmoji())")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(backgroundColor(for: sentiment))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom))
            .navigationTitle(" 🧠 IA du futur")
            .navigationBarTitleTextColor(Color.white)
        }
    }
    
    func classify() {
        do {
            let model = try SentimentAnalysis_1(configuration: .init())
            let prediction = try model.prediction(text: inputText)
            modelOutput = Sentiment(rawValue: prediction.label)
        } catch {
            print("Something went wrong")
        }
    }
}

#Preview {
    ContentView(
    )
}


extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}

//
//  ContentView.swift
//  MultiTables
//
//  Created by Dmitrii Vlasov on 22/01/2024.
//

import SwiftUI

struct Question {
    let x: Int
    let y: Int
    var questionText: String {
        "\(x) x \(y) = "
    }
    var result: Int {
        x * y
    }
}

struct SettingsView: View {
    let startGame: ([Question]) -> Void

    @State private var difficulty = 0
    @State private var numberOfQuestions = 5
    let availableNumberOfQuestions = [5, 10, 20]
    
    @State private var questions = [Question]()
    
    init(startGame: @escaping ([Question]) -> Void) {
        self.startGame = startGame
    }
    var body: some View {
        Form {
            Picker("Difficulty level", selection: $difficulty) {
                ForEach(2..<13) {
                    Text("\($0)")
                }
            }
            
            Text("How many questions would you like to answer?")
            Picker("Select number of questions", selection: $numberOfQuestions) {
                ForEach(availableNumberOfQuestions, id: \.self) {
                    Text("\($0)")
                }
            }
            .pickerStyle(.segmented)
            
            
            Button("Start") {
                questions = generateQuestions(difficulty: difficulty, numberOfQuestions: numberOfQuestions)
                startGame(questions)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.bordered)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 20))
        }
    }
    
    func generateQuestions(difficulty: Int, numberOfQuestions: Int) -> [Question] {
        var questions = [Question]()
        for _ in 0..<numberOfQuestions {
            questions.append(Question(x: Int.random(in: 1...(difficulty + 2)), y: Int.random(in: 1...(difficulty + 2))))
        }
        return questions
    }
}

struct GameView: View {
    @State private var currentQuestion = 0
    @State private var answer = 0
    @State private var score = 0
    @State private var showResults = false
    
    let questions: [Question]
    var numberOfQuestions: Int {
        questions.count
    }
    
    let reset: () -> Void
    
    init(questions: [Question], reset: @escaping () -> Void) {
        print("inside init")
        self.questions = questions
        self.reset = reset        
    }
    
    var body: some View {
        Spacer()
        Spacer()
        
        Text(questions[currentQuestion].questionText)
            .font(.title)
        TextField("Answer", value: $answer, format: .number)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
        
        Spacer()
        
        Button("Next question") {
            questionAnswered()
        }
        .alert("That's it!", isPresented: $showResults) {
            Button("Start over") {
                reset()
            }
        } message: {
            Text("Your score is: \(score)")
        }
        
        Spacer()
        Spacer()
    }
    
    func questionAnswered() {
        score = checkAnswer() ? score + 1 : score - 1
        
        if currentQuestion < numberOfQuestions - 1 {
            currentQuestion += 1
            answer = 0
            print(questions[currentQuestion].questionText)
        } else {
            showResults = true
        }
    }
    
    func checkAnswer() -> Bool {
        let question = questions[currentQuestion]
        return answer == question.result
    }
}

struct ContentView: View {
    @State private var gameActive = false
    @State private var questions = [Question]()
    
    var body: some View {
        
        NavigationStack {
            VStack {
                if !gameActive {
                    SettingsView { generatedQuestions in
                        print("here")
                        questions = generatedQuestions
                        gameActive = true
                    }
                } else {
                    GameView(questions: questions) {
                        gameActive = false
                    }
                }
            }
            .navigationTitle("MultiTable")
        }
    }
    
}

#Preview {
    ContentView()
}

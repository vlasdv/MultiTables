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

struct ContentView: View {
    @State private var difficulty = 0
    @State private var numberOfQuestions = 5
    
    @State private var questions = [Question]()
    @State private var gameActive = false
    @State private var currentQuestion = 0
    @State private var answer = 0
    @State private var score = 0
        
    @State private var showResults = false
    
    let availableNumberOfQuestions = [5, 10, 20]
    
    var body: some View {
        if !gameActive {
            NavigationStack {
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
                        gameActive = true
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 20))
                    
                    
                }
                .navigationTitle("MultiTable")
            }
        } else {
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
    
    func reset() {
        gameActive = false
        difficulty = 0
        numberOfQuestions = 5
        questions = [Question]()
        currentQuestion = 0
        answer = 0
        score = 0
    }
    
    func generateQuestions(difficulty: Int, numberOfQuestions: Int) -> [Question] {
        var questions = [Question]()
        for _ in 0..<numberOfQuestions {
            questions.append(Question(x: Int.random(in: 1...(difficulty + 2)), y: Int.random(in: 1...(difficulty + 2))))
        }
        return questions
    }
    
    
}

#Preview {
    ContentView()
}

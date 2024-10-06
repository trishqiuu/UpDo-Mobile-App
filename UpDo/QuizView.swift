import SwiftUI
struct QuizQuestion {
    let id: Int
    let question: String
    let answers: [String]
    var selectedAnswerIndex: Int?
}
struct CustomProgressBar: View {
    var value: Double
    var total: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 0.347, green: 0.239, blue: 0.173).opacity(0.3))
                    .cornerRadius(10)
                
                Rectangle()
                    .fill(Color(red: 0.347, green: 0.239, blue: 0.173))
                    .cornerRadius(10)
                    .frame(width: min(CGFloat(self.value / self.total) * geometry.size.width, geometry.size.width))
                    .animation(.linear, value: value)
                
                HStack {
                    Spacer()
                    ForEach(0..<Int(total), id: \.self) { index in
                        Circle()
                            .fill(index < Int(value) ? Color.white : Color.clear)
                            .frame(width: 10, height: 10)
                        Spacer()
                    }
                }
                .padding(.horizontal, 5)
            }
        }
    }
}
struct QuizView: View {
    @State private var questions: [QuizQuestion] = [
        QuizQuestion(id: 0, question: "What is your hair type?", answers: ["Straight", "Wavy", "Curly", "Coily"]),
        QuizQuestion(id: 1, question: "How would you describe your hair's porosity?", answers: ["Low (Water beads on hair)", "Medium (Water absorbs slowly)", "High (Water absorbs quickly)"]),
        QuizQuestion(id: 2, question: "What is your main hair concern?", answers: ["Dryness", "Breakage", "Frizz", "Lack of volume", "Oiliness"]),
        QuizQuestion(id: 3, question: "How often do you wash your hair?", answers: ["Daily", "Every other day", "Twice a week", "Once a week", "Less than once a week"]),
        QuizQuestion(id: 4, question: "Have you chemically treated your hair in the last 6 months?", answers: ["Yes", "No"]),
        QuizQuestion(id: 5, question: "How often do you use heat styling tools?", answers: ["Daily", "A few times a week", "Once a week", "Rarely", "Never"])
    ]
    
    @State private var currentQuestionIndex = 0
    @Binding var quizComplete: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(height: geometry.size.height * 0.05)
                
                VStack {
                    Text("How's Your Hair?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                    
                    CustomProgressBar(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                        .frame(height: 20)
                        .padding(.horizontal)
                }
                
                Spacer()
                    .frame(height: geometry.size.height * 0.1)
                
                VStack(alignment: .leading) {
                    Text(questions[currentQuestionIndex].question)
                        .font(.title2)
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    ForEach(0..<questions[currentQuestionIndex].answers.count, id: \.self) { index in
                        Button(action: {
                            questions[currentQuestionIndex].selectedAnswerIndex = index
                        }) {
                            Text(questions[currentQuestionIndex].answers[index])
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(questions[currentQuestionIndex].selectedAnswerIndex == index ? Color(red: 0.347, green: 0.239, blue: 0.173) : Color.white)
                                .foregroundColor(questions[currentQuestionIndex].selectedAnswerIndex == index ? .white : Color(red: 0.347, green: 0.239, blue: 0.173))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 0.347, green: 0.239, blue: 0.173), lineWidth: 2)
                                )
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                }
                
                Spacer()
                
                HStack {
                    if currentQuestionIndex > 0 {
                        Button("Previous") {
                            currentQuestionIndex -= 1
                        }
                        .buttonStyle(QuizButtonStyle())
                    }
                    
                    Spacer()
                    
                    Button(currentQuestionIndex == questions.count - 1 ? "Finish" : "Next") {
                        if currentQuestionIndex == questions.count - 1 {
                            finishQuiz()
                        } else {
                            currentQuestionIndex += 1
                        }
                    }
                    .buttonStyle(QuizButtonStyle())
                    .disabled(questions[currentQuestionIndex].selectedAnswerIndex == nil)
                    .opacity(questions[currentQuestionIndex].selectedAnswerIndex == nil ? 0.5 : 1)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.953, green: 0.878, blue: 0.749))
        }
    }
    
    private func finishQuiz() {
        saveQuizResults()
        withAnimation {
            quizComplete = true
        }
    }
    
    private func saveQuizResults() {
        let results = questions.reduce(into: [String: String]()) { (dict, question) in
            if let selectedIndex = question.selectedAnswerIndex {
                dict[question.question] = question.answers[selectedIndex]
            }
        }
        UserDefaults.standard.set(results, forKey: "QuizResults")
    }
}
struct QuizButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .padding()
            .background(Color(red: 0.347, green: 0.239, blue: 0.173))
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

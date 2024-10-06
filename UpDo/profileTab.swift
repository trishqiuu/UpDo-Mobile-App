import SwiftUI

struct profileTab: View {
    @Binding var quizComplete: Bool
    @State private var quizResults: [String: String] = [:]
    
    private let questionOrder = [
        "What is your hair type?",
        "How would you describe your hair's porosity?",
        "What is your main hair concern?",
        "How often do you wash your hair?",
        "Have you chemically treated your hair in the last 6 months?",
        "How often do you use heat styling tools?"
    ]
    
    private let displayNames = [
        "What is your hair type?": "Hair Type",
        "How would you describe your hair's porosity?": "Hair Porosity",
        "What is your main hair concern?": "Main Concern",
        "How often do you wash your hair?": "Wash Frequency",
        "Have you chemically treated your hair in the last 6 months?": "Chemical Treatment",
        "How often do you use heat styling tools?": "Heat Styling Frequency"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(quizResultsToDisplay, id: \.0) { item in
                        HStack {
                            Text(item.0)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(item.1)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    }

                    
                    ProminentSectionHeader(title: "Hair Care Tips")
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Based on your hair type and concerns, here are some tips:")
                        
                        Text("• Use a sulfate-free shampoo to prevent dryness")
                        Text("• Deep condition your hair weekly")
                        Text("• Avoid heat styling tools when possible")
                    }
                    .padding(.horizontal)
                    
                    ProminentSectionHeader(title: "Account Settings")
                    
                    VStack(alignment: .leading, spacing: 15) {
                        NavigationLink(destination: Text("Edit Profile View")) {
                            Text("Edit Profile")
                        }
                        NavigationLink(destination: Text("Notification Settings View")) {
                            Text("Notification Settings")
                        }
                        NavigationLink(destination: Text("Privacy Settings View")) {
                            Text("Privacy Settings")
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button("Retake Hair Assessment") {
                        quizComplete = false
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.347, green: 0.239, blue: 0.173))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(red: 0.953, green: 0.878, blue: 0.749))
            .navigationTitle("Your Profile")
            .navigationBarTitleTextColor(Color(red: 0.347, green: 0.239, blue: 0.173))
            .onAppear(perform: loadQuizResults)
        }
    }
    
    private var quizResultsToDisplay: [(String, String)] {
            return questionOrder.compactMap { question in
                guard let answer = quizResults[question],
                      let displayName = displayNames[question] else { return nil }
                return (displayName, answer)
            }
        }
    
    private func loadQuizResults() {
        if let savedResults = UserDefaults.standard.dictionary(forKey: "QuizResults") as? [String: String] {
                    self.quizResults = savedResults
        }
    }
}

struct ProminentSectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 10)
    }
}

extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor]
        return self
    }
}

struct profileTab_Previews: PreviewProvider {
    static var previews: some View {
        profileTab(quizComplete: .constant(true))
    }
}

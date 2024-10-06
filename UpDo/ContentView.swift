// Light Brown Color: Color(red: 0.953, green: 0.878, blue: 0.749)
// Dark Brown Color: Color(red:0.347, green:0.239, blue:0.173))
// Darkest Brown Color: Color(red:0.347, green:0.239, blue:0.173)

import SwiftUI
struct ContentView: View {
    @State private var isActive = false
    @AppStorage("quizComplete") private var quizComplete = false
    @State private var selectedTab = 1  // Default to routineTab (index 1)
    
    var body: some View {
        Group {
            if isActive {
                if !quizComplete {
                    QuizView(quizComplete: $quizComplete)
                        .transition(.opacity)
                } else {
                    TabView(selection: $selectedTab) {
                        exploreTab()
                            .tabItem {
                                Image(systemName: "magnifyingglass")
                                Text("Explore")
                            }
                            .tag(0)
                        
                        routineTab()
                            .tabItem {
                                Image(systemName: "checklist")
                                Text("Routine")
                            }
                            .tag(1)
                        
                        profileTab(quizComplete: $quizComplete)
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("Profile")
                            }
                            .tag(2)
                    }
                    .accentColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                }
            } else {
                LaunchScreenView()
            }
        }
        .animation(.easeOut(duration: 0.5), value: isActive)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isActive = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color("Color")
                .ignoresSafeArea()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
        }
    }
}

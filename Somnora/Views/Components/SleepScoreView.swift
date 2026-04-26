import SwiftUI

struct SleepScoreView: View {
    let score: Int
    
    var body: some View {
        ZStack {
            // Background Glow
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blur(radius: 20)
                .frame(width: 180, height: 180)
            
            // Progress Ring
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 12)
                .frame(width: 150, height: 150)
            
            Circle()
                .trim(from: 0, to: CGFloat(score) / 100.0)
                .stroke(
                    LinearGradient(
                        colors: [.cyan, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 4) {
                Text("\(score)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("睡眠评分")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        SleepScoreView(score: 85)
    }
}

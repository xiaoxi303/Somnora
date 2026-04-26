import SwiftUI

struct PermissionView: View {
    @ObservedObject var manager: HealthKitManager
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Background Glows
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: -100, y: -200)
            
            VStack(spacing: 40) {
                Spacer()
                
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 20)
                
                VStack(spacing: 16) {
                    Text("欢迎使用 Somnora")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("为了生成专业的睡眠分析和建议，我们需要访问您的“健康”睡眠数据。")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                Button {
                    manager.requestAuthorization { _ in }
                } label: {
                    Text("开启健康访问")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 40)
                }
                
                Text("您的隐私对我们至关重要。数据仅在本地处理，绝不上传。")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    PermissionView(manager: HealthKitManager())
}

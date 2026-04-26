import SwiftUI

struct SettingsView: View {
    @ObservedObject var manager: HealthKitManager
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Text("设置")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // HealthKit Status
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "heart.text.square.fill")
                            .foregroundColor(.red)
                        Text("健康数据权限")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Text(manager.isAuthorized ? "已授权" : "未授权")
                            .font(.subheadline)
                            .foregroundColor(manager.isAuthorized ? .green : .orange)
                    }
                    
                    if !manager.isAuthorized {
                        Button {
                            manager.requestAuthorization { _ in }
                        } label: {
                            Text("立即授权")
                                .font(.subheadline.bold())
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text("Somnora 需要读取您的睡眠分析数据。您可以在系统“设置 > 隐私与安全性 > 健康”中管理权限。")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(24)
                .liquidGlassCard()
                .padding(.horizontal)
                
                // About
                VStack(spacing: 0) {
                    settingRow(title: "App 名称", value: "Somnora", icon: "info.circle")
                    Divider().background(Color.white.opacity(0.1)).padding(.horizontal)
                    settingRow(title: "版本信息", value: "v\(version)", icon: "number")
                }
                .liquidGlassCard()
                .padding(.horizontal)
                
                // Privacy
                VStack(alignment: .leading, spacing: 12) {
                    Text("隐私说明")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("您的睡眠数据存储在 Apple 健康应用中。Somnora 仅在本地读取并进行分析，绝不会将您的任何健康数据上传到服务器。")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                        .lineSpacing(4)
                }
                .padding(24)
                .liquidGlassCard()
                .padding(.horizontal)
                
                Text("Designed with Liquid Glass Concept")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.top, 20)
            }
            .padding(.bottom, 30)
        }
    }
    
    private func settingRow(title: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.6))
                .frame(width: 24)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(20)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        SettingsView(manager: HealthKitManager.mock)
    }
}

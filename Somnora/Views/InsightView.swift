import SwiftUI

struct InsightView: View {
    @ObservedObject var manager: HealthKitManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Text("睡眠建议")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                if let night = manager.lastNightSleep {
                    let score = SleepCalculator.calculateScore(
                        totalDuration: night.totalDuration,
                        deepSleepDuration: night.stageBreakdown[.deep] ?? 0,
                        awakeDuration: night.stageBreakdown[.awake] ?? 0
                    )
                    
                    let insight = SleepCalculator.generateInsight(
                        score: score,
                        totalDuration: night.totalDuration,
                        deepSleepDuration: night.stageBreakdown[.deep] ?? 0
                    )
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                            Text("核心建议")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        Text(insight)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(6)
                    }
                    .padding(24)
                    .liquidGlassCard()
                    .padding(.horizontal)
                    
                    // Logic based secondary insights
                    if (night.stageBreakdown[.rem] ?? 0) < night.totalDuration * 0.2 {
                        insightCard(
                            title: "快速眼动 (REM) 偏少",
                            content: "REM 睡眠对于记忆巩固和情绪调节至关重要。过量饮酒或睡前压力可能抑制 REM 阶段。",
                            icon: "brain.headset",
                            color: .cyan
                        )
                    }
                    
                    insightCard(
                        title: "改善睡眠环境",
                        content: "研究表明，18-22摄氏度的凉爽环境最适合深度睡眠。确保卧室黑暗且安静。",
                        icon: "thermometer.snowflake",
                        color: .blue
                    )
                    
                    insightCard(
                        title: "规律性是关键",
                        content: "尝试在周末也保持相同的入睡和起床时间，这有助于稳定你的生物钟。",
                        icon: "clock.arrow.2.circlepath",
                        color: .purple
                    )
                    
                } else {
                    Text("获取睡眠数据后，我们将为您提供个性化建议。")
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)
                }
            }
            .padding(.bottom, 30)
        }
    }
    
    private func insightCard(title: String, content: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .lineSpacing(4)
        }
        .padding(24)
        .liquidGlassCard()
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        InsightView(manager: HealthKitManager.mock)
    }
}

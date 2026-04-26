import SwiftUI

struct TrendView: View {
    @ObservedObject var manager: HealthKitManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Text("最近趋势")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                if manager.recentSleepRecords.isEmpty {
                    Text("暂无趋势数据")
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 50)
                } else {
                    // Average Card
                    let avgDuration = manager.recentSleepRecords.reduce(0) { $0 + $1.totalDuration } / Double(manager.recentSleepRecords.count)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("平均睡眠时长")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                        Text(DateFormatters.formatDuration(seconds: avgDuration))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .liquidGlassCard()
                    .padding(.horizontal)
                    
                    // Simple Bar Chart
                    VStack(alignment: .leading, spacing: 20) {
                        Text("最近 7 天记录")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        let maxDuration = manager.recentSleepRecords.prefix(7).map { $0.totalDuration }.max() ?? 1
                        
                        HStack(alignment: .bottom, spacing: 12) {
                            ForEach(manager.recentSleepRecords.prefix(7).reversed()) { night in
                                VStack(spacing: 8) {
                                    ZStack(alignment: .bottom) {
                                        Capsule()
                                            .fill(Color.white.opacity(0.1))
                                            .frame(width: 30, height: 150)
                                        
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [.blue, .cyan],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .frame(width: 30, height: 150 * (night.totalDuration / maxDuration))
                                    }
                                    
                                    Text(DateFormatters.shortWeekdayFormatter.string(from: night.id))
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(24)
                    .liquidGlassCard()
                    .padding(.horizontal)
                    
                    // List
                    VStack(spacing: 12) {
                        ForEach(manager.recentSleepRecords.prefix(14)) { night in
                            HStack {
                                Text(DateFormatters.dayMonthFormatter.string(from: night.id))
                                    .foregroundColor(.white)
                                Spacer()
                                Text(DateFormatters.formatDuration(seconds: night.totalDuration))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.vertical, 4)
                            if night.id != manager.recentSleepRecords.last?.id {
                                Divider().background(Color.white.opacity(0.1))
                            }
                        }
                    }
                    .padding(24)
                    .liquidGlassCard()
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TrendView(manager: HealthKitManager.mock)
    }
}

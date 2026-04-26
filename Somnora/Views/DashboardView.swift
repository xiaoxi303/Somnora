import SwiftUI

struct DashboardView: View {
    @ObservedObject var manager: HealthKitManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(DateFormatters.dayMonthFormatter.string(from: Date()))
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                    
                    Button {
                        manager.fetchRecentSleep()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                if let night = manager.lastNightSleep {
                    let score = SleepCalculator.calculateScore(
                        totalDuration: night.totalDuration,
                        deepSleepDuration: night.stageBreakdown[.deep] ?? 0,
                        awakeDuration: night.stageBreakdown[.awake] ?? 0
                    )
                    
                    // Main Score Card
                    VStack(spacing: 20) {
                        SleepScoreView(score: score)
                            .padding(.top, 10)
                        
                        HStack(spacing: 40) {
                            statItem(title: "入睡时间", value: DateFormatters.timeFormatter.string(from: night.startTime), icon: "bed.double.fill")
                            statItem(title: "醒来时间", value: DateFormatters.timeFormatter.string(from: night.endTime), icon: "sun.max.fill")
                        }
                        
                        Divider().background(Color.white.opacity(0.1))
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("总睡眠时长")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                                Text(DateFormatters.formatDuration(seconds: night.totalDuration))
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                    }
                    .padding(24)
                    .liquidGlassCard()
                    .padding(.horizontal)
                    
                    // Stages Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("睡眠阶段")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        let total = night.records.reduce(0) { $0 + $1.duration }
                        
                        ForEach(SleepStage.allCases.filter { $0 != .unspecified }) { stage in
                            let duration = night.stageBreakdown[stage] ?? 0
                            SleepStageRow(stage: stage, duration: duration, percentage: duration / total)
                        }
                    }
                    .padding(24)
                    .liquidGlassCard()
                    .padding(.horizontal)
                    
                } else if manager.isLoading {
                    ProgressView()
                        .tint(.white)
                        .padding(50)
                } else {
                    emptyState
                }
            }
            .padding(.bottom, 30)
        }
        .background(Color.clear)
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "早上好" }
        if hour < 18 { return "下午好" }
        return "晚上好"
    }
    
    private func statItem(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.cyan)
                .font(.system(size: 20))
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.2))
            
            Text("没有睡眠数据")
                .font(.title3.bold())
                .foregroundColor(.white)
            
            Text("请确保您在睡觉时佩戴了 Apple Watch，或者在“健康”应用中手动添加了睡眠数据。")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                manager.fetchRecentSleep()
            } label: {
                Text("刷新数据")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .clipShape(Capsule())
            }
        }
        .padding(.top, 100)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        DashboardView(manager: HealthKitManager.mock)
    }
}

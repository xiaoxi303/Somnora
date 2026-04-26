import SwiftUI

struct SleepStageRow: View {
    let stage: SleepStage
    let duration: TimeInterval
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(colorForStage(stage).opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: stage.symbol)
                    .foregroundColor(colorForStage(stage))
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stage.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(DateFormatters.formatDuration(seconds: duration))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(percentage * 100))%")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white.opacity(0.8))
                
                // Mini bar
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 60, height: 4)
                    Capsule()
                        .fill(colorForStage(stage))
                        .frame(width: 60 * CGFloat(percentage), height: 4)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func colorForStage(_ stage: SleepStage) -> Color {
        switch stage {
        case .awake: return .orange
        case .rem: return .cyan
        case .core: return .blue
        case .deep: return .purple
        case .unspecified: return .gray
        }
    }
}

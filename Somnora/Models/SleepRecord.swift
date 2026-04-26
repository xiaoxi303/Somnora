import Foundation
import HealthKit

enum SleepStage: String, CaseIterable, Identifiable {
    case awake = "清醒"
    case rem = "快速眼动"
    case core = "核心睡眠"
    case deep = "深度睡眠"
    case unspecified = "未分类"
    
    var id: String { self.rawValue }
    
    var symbol: String {
        switch self {
        case .awake: return "sun.max.fill"
        case .rem: return "eye.fill"
        case .core: return "moon.fill"
        case .deep: return "moon.stars.fill"
        case .unspecified: return "questionmark.circle.fill"
        }
    }
    
    var colorName: String {
        switch self {
        case .awake: return "orange"
        case .rem: return "cyan"
        case .core: return "blue"
        case .deep: return "indigo"
        case .unspecified: return "gray"
        }
    }
}

struct SleepRecord: Identifiable, Equatable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let stage: SleepStage
    
    var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }
    
    init(id: UUID = UUID(), startDate: Date, endDate: Date, stage: SleepStage) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.stage = stage
    }
    
    static func from(sample: HKCategorySample) -> SleepRecord {
        let stage: SleepStage
        if #available(iOS 16.0, *) {
            switch sample.value {
            case HKCategoryValueSleepAnalysis.awake.rawValue: stage = .awake
            case HKCategoryValueSleepAnalysis.asleepREM.rawValue: stage = .rem
            case HKCategoryValueSleepAnalysis.asleepCore.rawValue: stage = .core
            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue: stage = .deep
            default: stage = .unspecified
            }
        } else {
            stage = .unspecified
        }
        return SleepRecord(startDate: sample.startDate, endDate: sample.endDate, stage: stage)
    }
}

struct NightlySleep: Identifiable {
    let id: Date // Using the end date or a reference date
    let records: [SleepRecord]
    
    var totalDuration: TimeInterval {
        records.filter { $0.stage != .awake }.reduce(0) { $0 + $1.duration }
    }
    
    var startTime: Date {
        records.map { $0.startDate }.min() ?? Date()
    }
    
    var endTime: Date {
        records.map { $0.endDate }.max() ?? Date()
    }
    
    var stageBreakdown: [SleepStage: TimeInterval] {
        var breakdown: [SleepStage: TimeInterval] = [:]
        for record in records {
            breakdown[record.stage, default: 0] += record.duration
        }
        return breakdown
    }
}

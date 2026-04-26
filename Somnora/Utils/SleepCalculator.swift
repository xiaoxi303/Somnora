import Foundation

struct SleepCalculator {
    /// 计算睡眠评分 (0-100)
    /// 规则：
    /// - 总时长 7-9 小时为满分点
    /// - 深度睡眠 1-2 小时为满分点
    /// - 清醒次数和时长越少越好
    static func calculateScore(totalDuration: TimeInterval, deepSleepDuration: TimeInterval, awakeDuration: TimeInterval) -> Int {
        var score: Double = 0
        
        // 1. 时长得分 (50分)
        let hours = totalDuration / 3600
        if hours >= 7 && hours <= 9 {
            score += 50
        } else if hours > 4 && hours < 7 {
            score += (hours / 7.0) * 50
        } else if hours > 9 {
            score += 40 // 睡太多也不是最好
        } else {
            score += 20
        }
        
        // 2. 深度睡眠得分 (30分)
        let deepHours = deepSleepDuration / 3600
        if deepHours >= 1.5 && deepHours <= 2.5 {
            score += 30
        } else if deepHours > 0.5 && deepHours < 1.5 {
            score += 20
        } else {
            score += 10
        }
        
        // 3. 清醒扣分 (20分起始)
        let awakeMinutes = awakeDuration / 60
        var awakeScore = 20.0
        if awakeMinutes > 30 {
            awakeScore -= min(20, (awakeMinutes - 30) / 5)
        }
        score += awakeScore
        
        return Int(min(100, max(0, score)))
    }
    
    static func generateInsight(score: Int, totalDuration: TimeInterval, deepSleepDuration: TimeInterval) -> String {
        if score >= 90 {
            return "昨晚你的睡眠质量非常棒！继续保持规律的作息。"
        } else if score >= 75 {
            return "你的睡眠质量良好，但深度睡眠还可以再提升一点。建议睡前减少电子设备使用。"
        } else if totalDuration < 6 * 3600 {
            return "昨晚睡眠时间不足 6 小时。长期睡眠不足会影响精力和免疫力，建议今晚早点休息。"
        } else if deepSleepDuration < 1 * 3600 {
            return "深度睡眠比例偏低。建议优化睡眠环境，保持卧室凉爽和安静。"
        } else {
            return "睡眠质量一般。尝试建立固定的睡前仪式，如冥想或热水澡。"
        }
    }
}

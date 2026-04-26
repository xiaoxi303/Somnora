import Foundation

enum AppTab: Int, CaseIterable, Identifiable {
    case dashboard = 0
    case trend = 1
    case insight = 2
    case settings = 3
    
    var id: Int { self.rawValue }
    
    var title: String {
        switch self {
        case .dashboard: return "首页"
        case .trend: return "趋势"
        case .insight: return "建议"
        case .settings: return "设置"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard: return "house.fill"
        case .trend: return "chart.bar.fill"
        case .insight: return "lightbulb.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

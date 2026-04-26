import SwiftUI

struct ContentView: View {
    @StateObject private var manager = HealthKitManager()
    @State private var selectedTab: AppTab = .dashboard
    
    var body: some View {
        Group {
            if manager.isAuthorized {
                mainInterface
            } else {
                PermissionView(manager: manager)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            manager.fetchRecentSleep()
        }
    }
    
    private var mainInterface: some View {
        ZStack(alignment: .bottom) {
            // Background
            Color.black.ignoresSafeArea().glassBackground()
            
            // Content Switcher
            Group {
                switch selectedTab {
                case .dashboard:
                    DashboardView(manager: manager)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.95)), removal: .opacity))
                case .trend:
                    TrendView(manager: manager)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.95)), removal: .opacity))
                case .insight:
                    InsightView(manager: manager)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.95)), removal: .opacity))
                case .settings:
                    SettingsView(manager: manager)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.95)), removal: .opacity))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedTab)
            .padding(.bottom, 120) // Bottom padding to avoid overlap
            
            // Custom Floating Tab Bar
            FloatingTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 34) // Adjust for home indicator
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}

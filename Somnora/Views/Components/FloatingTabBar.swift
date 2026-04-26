import SwiftUI

struct FloatingTabBar: View {
    @Binding var selectedTab: AppTab
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    private let tabs = AppTab.allCases
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let tabWidth = totalWidth / CGFloat(tabs.count)
            
            ZStack(alignment: .leading) {
                // Background Capsule (Outer Bar)
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
                
                // Sliding Highlight Capsule (Inner)
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .clear, .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .background(
                        #available(iOS 26.0, *) {
                            // AnyView(EmptyView().glassEffect()) // iOS 26 Placeholder
                            AnyView(Capsule().fill(.white.opacity(0.05)))
                        } else {
                            AnyView(EmptyView())
                        }
                    )
                    .frame(width: tabWidth - 8, height: 48) // Slightly smaller than tab area to fit inside padding
                    .offset(x: CGFloat(selectedTab.rawValue) * tabWidth + 4 + dragOffset)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // Tab Items
                HStack(spacing: 0) {
                    ForEach(tabs) { tab in
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                                selectedTab = tab
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 20, weight: .medium))
                                Text(tab.title)
                                    .font(.system(size: 10, weight: .medium))
                            }
                            .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.4))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                        }
                    }
                }
            }
            .frame(height: 64)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = tabWidth / 2
                        let translation = value.translation.width
                        let moveCount = Int((translation / tabWidth).rounded())
                        
                        var newIndex = selectedTab.rawValue + moveCount
                        
                        // Refined check for partial drags
                        if abs(translation).truncatingRemainder(dividingBy: tabWidth) > threshold {
                            newIndex += translation > 0 ? 1 : -1
                        }
                        
                        let finalIndex = max(0, min(tabs.count - 1, newIndex))
                        
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                            selectedTab = AppTab(rawValue: finalIndex) ?? .dashboard
                            dragOffset = 0
                        }
                        isDragging = false
                    }
            )
        }
        .frame(width: 340, height: 64) // Fixed width for centered capsule
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FloatingTabBar(selectedTab: .constant(.dashboard))
    }
}

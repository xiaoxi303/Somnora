import SwiftUI

struct LiquidGlassModifier: ViewModifier {
    var opacity: Double = 0.2
    var cornerRadius: CGFloat = 24
    
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) { // iOS 26 context, but mapping to actual current/near-future APIs
            content
                .background(.ultraThinMaterial)
                .modifier(GlassEffectModifier())
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.3), .clear, .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        } else {
            content
                .background(
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                        Color.white.opacity(0.05)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
    }
}

extension View {
    func liquidGlassCard(cornerRadius: CGFloat = 24) -> some View {
        self.modifier(LiquidGlassModifier(cornerRadius: cornerRadius))
    }
    
    func glassBackground() -> some View {
        ZStack {
            Color(red: 0.02, green: 0.02, blue: 0.05).ignoresSafeArea()
            
            // Dynamic Gradients
            Circle()
                .fill(Color(red: 0.39, green: 0.4, blue: 0.95).opacity(0.4))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(x: -150, y: -250)
            
            Circle()
                .fill(Color(red: 0.66, green: 0.33, blue: 0.97).opacity(0.3))
                .frame(width: 350, height: 350)
                .blur(radius: 70)
                .offset(x: 150, y: 150)
        }
    }
}

struct GlassEffectModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content // Placeholder for future glassEffect()
        } else {
            content.background(Color.white.opacity(0.05))
        }
    }
}

import SwiftUI

struct LiquidGlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 24
    let content: () -> Content
    
    init(cornerRadius: CGFloat = 24, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    var body: some View {
        content()
            .liquidGlassCard(cornerRadius: cornerRadius)
    }
}

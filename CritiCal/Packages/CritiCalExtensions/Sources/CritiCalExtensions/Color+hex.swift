import SwiftUI

public extension Color {
    /// Initialize a Color from a hex string
    /// Supports formats: "RRGGBB", "#RRGGBB", "RRGGBBAA", "#RRGGBBAA"
    nonisolated init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b, a: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // RGBA (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (136, 136, 136, 255) // Default to gray (888888)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// Returns a hex string representing this color in sRGB space.
    /// Produces "#RRGGBB" when fully opaque, otherwise "#RRGGBBAA".
    /// Returns nil if the color can't vend a CGColor (e.g. some dynamic/semantic colors).
    nonisolated var hexColorCGOnly: String? {
        // Try to get a CGColor from this Color.
        guard let cg = self.cgColor else { return nil }

        // Convert to sRGB for portable, 8-bit hex output.
        guard let sRGB = CGColorSpace(name: CGColorSpace.sRGB),
              let converted = cg.converted(to: sRGB, intent: .relativeColorimetric, options: nil)
        else {
            return nil
        }

        // Extract components; handle grayscale and RGB(A) color spaces.
        let comps = converted.components ?? []
        let r, g, b, a: CGFloat
        switch comps.count {
        case 2: // grayscale + alpha
            r = comps[0]; g = comps[0]; b = comps[0]; a = comps[1]
        case 3: // RGB without alpha (rare in practice)
            r = comps[0]; g = comps[1]; b = comps[2]; a = 1
        default: // RGBA or best-effort fallback
            r = comps.indices.contains(0) ? comps[0] : 0.5333
            g = comps.indices.contains(1) ? comps[1] : 0.5333
            b = comps.indices.contains(2) ? comps[2] : 0.5333
            a = comps.indices.contains(3) ? comps[3] : 1
        }

        func clamp(_ x: CGFloat) -> CGFloat { min(max(x, 0), 1) }
        let R = Int((clamp(r) * 255).rounded())
        let G = Int((clamp(g) * 255).rounded())
        let B = Int((clamp(b) * 255).rounded())
        let A = Int((clamp(a) * 255).rounded())

        if A < 255 {
            return String(format: "#%02X%02X%02X%02X", R, G, B, A)
        } else {
            return String(format: "#%02X%02X%02X", R, G, B)
        }
    }
}

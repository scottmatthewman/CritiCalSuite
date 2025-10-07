//
//  Array+utilities
//  CritiCalExtensions
//
//  Created by Scott Matthewman on 05/10/2025.
//

// Convenience: chunk array into rows of n elements
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

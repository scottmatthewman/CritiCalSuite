//
//  FullFilterScope.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 01/10/2025.
//

import SwiftUI

enum GenreScope {
    case anyOrAll
    case none
    case some(Set<String>)
}

enum PublicationScope {
    case anyOrAll
    case none
    case some(Set<String>)
}

struct FullFilterScope: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    NavigationStack {
        FullFilterScope()
    }
}

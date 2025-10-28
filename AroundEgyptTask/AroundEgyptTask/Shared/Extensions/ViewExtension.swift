//
//  ViewExtension.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import SwiftUICore

// MARK: - View Modifier for Hex Background
extension View {
    func hexBackground(_ hex: String, opacity: Double = 1.0, cornerRadius: CGFloat = 0) -> some View {
        self.background(
            Color(hex: hex, opacity: opacity)
                .cornerRadius(cornerRadius)
        )
    }
    
    func hexForeground(_ hex: String, opacity: Double = 1.0) -> some View {
           self.foregroundColor(Color(hex: hex, opacity: opacity))
       }
}

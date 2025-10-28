//
//  Theme.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Foundation
import UIKit

struct Theme {
    struct Colors {
        static let colorFFFFFF = "#FFFFFF"
        static let color000000 = "#000000"
        static let colorDDDDDD = "#DDDDDD"
        static let colorF18757 = "#F18757"
        static let color555555 = "#555555"
        static let color8E8E93 = "#8E8E93"
    }
    
    struct Sizes {
        static let pt2: CGFloat = getDimen(size: 2.0)
        static let pt4: CGFloat = getDimen(size: 4.0)
        static let pt7: CGFloat = getDimen(size: 7.0)
        static let pt8: CGFloat = getDimen(size: 8.0)
        static let pt10: CGFloat = getDimen(size: 10.0)
        static let pt14: CGFloat = getDimen(size: 14.0)
        static let pt16: CGFloat = getDimen(size: 16.0)
        static let pt20: CGFloat = getDimen(size: 20.0)
        static let pt22: CGFloat = getDimen(size: 22.0)
        static let pt25: CGFloat = getDimen(size: 25.0)
        static let pt30: CGFloat = getDimen(size: 30.0)
        static let pt46: CGFloat = getDimen(size: 46.0)
        static let pt120: CGFloat = getDimen(size: 120.0)
        static let pt152: CGFloat = getDimen(size: 152.0)
        static let pt154: CGFloat = getDimen(size: 154.0)
        static let pt185: CGFloat = getDimen(size: 185.0)
        static let pt285: CGFloat = getDimen(size: 285.0)
    }
    
    static func getDimen(size: CGFloat) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return size * 1.2
        } else {
            return size
        }
    }
}

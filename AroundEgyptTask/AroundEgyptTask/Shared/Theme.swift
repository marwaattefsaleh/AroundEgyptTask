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

    }
    
    struct Sizes {
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

//
//  Haptic.swift
//  Haptica
//
//  Created by Lasha Efremidze on 4/7/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import UIKit

public enum HapticFeedbackStyle: Int {
    case light, medium, heavy
    
    @available(iOS 13.0, *)
    case soft, rigid
}

@available(iOS 10.0, *)
extension HapticFeedbackStyle {
    var value: UIImpactFeedbackGenerator.FeedbackStyle {
        return UIImpactFeedbackGenerator.FeedbackStyle(rawValue: rawValue)!
    }
}

public enum HapticFeedbackType: Int {
    case success, warning, error
}

@available(iOS 10.0, *)
extension HapticFeedbackType {
    var value: UINotificationFeedbackGenerator.FeedbackType {
        return UINotificationFeedbackGenerator.FeedbackType(rawValue: rawValue)!
    }
}

public enum Haptic {
    case impact(HapticFeedbackStyle, CGFloat = 1.0)
    case notification(HapticFeedbackType)
    case selection
    
    // trigger
    public func generate() {
        guard #available(iOS 10, *) else { return }
        
        switch self {
        case .impact(let style, let _intensity):
            let generator = UIImpactFeedbackGenerator(style: style.value)
            generator.prepare()
            if #available(iOS 13.0, *) {
                var intensity = _intensity
                if _intensity > 1 {
                    intensity = 1
                } else if _intensity < 0 {
                    intensity = 0
                }
                generator.impactOccurred(intensity: intensity)
            } else {
                generator.impactOccurred()
            }
        case .notification(let type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type.value)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}

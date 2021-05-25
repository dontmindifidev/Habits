//
//  Haptics.swift
//  Habits
//
//  Created by Adam Fisher on 24/05/2021.
//

import UIKit

class Haptics {

    static func hapticTap(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func hapticNotification(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(feedbackType)
    }
}



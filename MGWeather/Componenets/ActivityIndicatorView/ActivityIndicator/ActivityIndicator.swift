//
//  ActivityIndicator.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit
import Lottie

class ActivityIndicator: UIView {
    @IBOutlet private weak var animationView: LottieAnimationView!
    
    override func removeFromSuperview() {
        animationView.stop()
        super.removeFromSuperview()
    }
    
    func setAnimation() {
        self.animationView.animation = LottieAnimation.named("loaderAnimation.json")
        animationView.animationSpeed = 1
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.contentMode = .scaleAspectFit
        self.animationView.play()
    }
}


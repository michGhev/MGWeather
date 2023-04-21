//
//  ActivityIndicatorView.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit

class ActivityIndicatorView: UIView {
    static let shared = ActivityIndicatorView(frame: UIScreen.main.bounds)
    
    var animationView: ActivityIndicator?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func loadViewFromNib() {
        guard let animView = Bundle.main.loadNibNamed("ActivityIndicator",
                                                      owner: self)?.first as? ActivityIndicator else {
            return
        }
        animationView = animView
        addSubview(animationView!)
        animationView!.frame = bounds
        animationView!.setAnimation()
    }
    
    func startAnimating() {
        guard let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) else {
            //stopAnimating()
            return
        }
        setNeedsLayout()
        layoutIfNeeded()
        alpha = 0
        window.addSubview(self)
        window.bringSubviewToFront(self)
        self.frame = window.bounds
        loadViewFromNib()
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
    }
    
    func stopAnimating(finished: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { (_) in
            self.animationView?.removeFromSuperview()
            self.removeFromSuperview()
            guard finished != nil else {return}
            finished!()
        }
    }
}


//
//  WikiProgressView.swift
//  WikipediaApp
//
//  Created by Ramakrishna on 9/24/18.
//  Copyright © 2018 Mindtree. All rights reserved.
//

import UIKit

class WikiProgressView: UIView {
    @IBOutlet weak var imgProgressIndicator: UIImageView!
    
    static let sharedProgressView:WikiProgressView = UINib(nibName: "WikiProgressView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WikiProgressView
    
    class func showWaitingDialog(_ text: String) {
        let progressView: WikiProgressView? = self.sharedProgressView
        let window: UIWindow? = UIApplication.shared.keyWindow
        progressView?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat((window?.bounds.width)!), height: CGFloat((window?.bounds.height)!))
        window?.addSubview(progressView!)
        var rotationAnimation: CABasicAnimation?
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation?.toValue = Int(.pi * 2.0 * 2 * 0.6)
        rotationAnimation?.duration = 1
        rotationAnimation?.isCumulative = true
        rotationAnimation?.repeatCount = MAXFLOAT
        progressView?.imgProgressIndicator?.layer.add(rotationAnimation!, forKey: "rotationAnimation")
    }
    
    class func stopWaitingDialog() {
        let progressView: WikiProgressView? = sharedProgressView
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            progressView?.alpha = 0
        }, completion: {(_ finished: Bool) -> Void in
            progressView?.removeFromSuperview()
            progressView?.alpha = 1
        })
    }
    
}

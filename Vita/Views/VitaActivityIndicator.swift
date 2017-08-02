//
//  VitaActivityIndicator.swift
//  Vita
//
//  Created by Shemona.Puri on 01/08/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class VitaActivityIndicator: UIView {

    
    static let sharedInsntance  : VitaActivityIndicator = VitaActivityIndicator()
    
    let imgLoading : UIImageView = {

    let image = UIImageView(image: #imageLiteral(resourceName: "Common_activityIndicator"))
    image.frame.size.width = 48
    image.frame.size.height = 48
    image.contentMode = .scaleAspectFit
        return image
    }()
    
    let messageView : UILabel = {
    let label = UILabel()
    return label
    }()
    
    lazy var activityView : UIView = {
    let View = UIView()
    View.backgroundColor = .clear
    View.frame.size.width = 90
    View.frame.size.height = 90
    return View
    }()
    
   lazy var activityIndicator : UIView = {
    let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIWindow().bounds)
        self.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        self.addSubview(activityView)
        activityView.addSubview(activityIndicator)
        activityView.addSubview(messageView)
        activityIndicator.addSubview(imgLoading)
        imgLoading.center = activityView.center
        activityView.center = self.center
        activityView.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func showIndicatorWithMessage(message : String , containerView : UIView) {
         let activityIndicator = self.sharedInsntance
        activityIndicator.activityView.frame.size.height = 120
        activityIndicator.activityView.frame.size.width = 120
        activityIndicator.activityView.center = activityIndicator.center
        activityIndicator.imgLoading.frame = CGRect(x: 40, y: 30, width: 45, height: 45)
      let attributedtext = activityIndicator.getAttributedString(message: message)
        activityIndicator.messageView.attributedText = attributedtext
        activityIndicator.messageView.frame = CGRect(x: 28, y: 85, width: 90, height: 20)

        containerView.addSubview(activityIndicator)
        activityIndicator.animate()

    }
    
    class func showIndicator(containerView : UIView) {
    
        let activityIndicator = self.sharedInsntance
        activityIndicator.center = containerView.center
        activityIndicator.frame.origin.x = 0
        containerView.addSubview(activityIndicator)
        activityIndicator.animate()

    
    }
    
    
    func animate() {
        self.activityView.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping:  CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.activityView.transform = CGAffineTransform.identity
            
        }) { (animate) in
        
        }
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * M_PI
        rotation.duration = 1.1
        rotation.repeatCount = Float.infinity
        self.imgLoading.layer.add(rotation, forKey: "Spin")

    }
    
    class func hideIndicator() {
        
    let activityIndicator = self.sharedInsntance
    activityIndicator.removeFromSuperview()
        
    
    }
    
    
    func getAttributedString(message :String) -> NSMutableAttributedString {
        let myAttribute = [ NSForegroundColorAttributeName: UIColor(red: 208/256, green: 60/256, blue: 40/256, alpha: 1) , NSFontAttributeName: UIFont(name: "OpenSans", size: 17.0)! ]
        let attributedString = NSMutableAttributedString(string: message, attributes: myAttribute)
      
    return attributedString
    }
    
    
}

//
//  UIViewExtension.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    static func loadFromXib<T>(withOwner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> T where T: UIView
        {
            let bundle = Bundle(for: self)
            let nib = UINib(nibName: "\(self)", bundle: bundle)

            guard let view = nib.instantiate(withOwner: withOwner, options: options).first as? T else {
                fatalError("Could not load view from nib file.")
            }
            return view
        }
    
    
      func fadeTo(_ alpha: CGFloat, duration: TimeInterval = 0.3) {
        DispatchQueue.main.async {
          UIView.animate(withDuration: duration) {
            self.alpha = alpha
          }
        }
      }

      func fadeIn(_ duration: TimeInterval = 0.3) {
        fadeTo(1.0, duration: duration)
      }

      func fadeOut(_ duration: TimeInterval = 0.3) {
        fadeTo(0.0, duration: duration)
      }
    
    
}

//
//  UIBarExtension.swift
//  PangeaIO
//
//  Created by Felon on 30/1/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func hideBottomHairline() {
        self.hairlineImageView?.isHidden = true
    }
    
    func showBottomHairline() {
        self.hairlineImageView?.isHidden = false
    }
}

extension UIToolbar {
    func hideBottomHairline() {
        self.hairlineImageView?.isHidden = true
    }
    
    func showBottomHairline() {
        self.hairlineImageView?.isHidden = false
    }
}

extension UIView {
    fileprivate var hairlineImageView: UIImageView? {
        return hairlineImageView(in: self)
    }
    
    fileprivate func hairlineImageView(in view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView, imageView.bounds.height <= 1.0 {
            return imageView
        }
        
        for subview in view.subviews {
            if let imageView = self.hairlineImageView(in: subview) { return imageView }
        }
        
        return nil
    }
}

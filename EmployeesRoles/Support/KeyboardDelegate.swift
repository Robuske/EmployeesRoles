//
//  KeyboardDelegate.swift
//
//  Created by Bruno Fulber Wide on 09/08/17.
//  Copyright © 2017 BW. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func keyboardUpdateHandler(for notification: Notification)
    /** This is the constraint that will animate with the keyboard */
	var bottomLayoutConstraint: NSLayoutConstraint! { get set } // swiftlint:disable:this implicitly_unwrapped_optional
}

extension KeyboardDelegate where Self: UIViewController {
    
    func keyboardUpdateHandler(for notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect) {
                
                let animationDuration =
                    (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
                let rawAnimationCurve =
                    (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
                let animationCurve = UIViewAnimationOptions.RawValue(UInt(rawAnimationCurve))
                
                /** did this so there is only one method fot both keyboard up and down */
                bottomLayoutConstraint.constant +=
                    keyboardSize.height > bottomLayoutConstraint.constant ? keyboardSize.height : -keyboardSize.height
                
                UIView.animate(withDuration: animationDuration,
                               delay: 0.0,
                               options: [.beginFromCurrentState, UIViewAnimationOptions(rawValue: animationCurve)],
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            }
        }
    }
    
    /** call this on viewWillAppear */
    func loadNotifications() {
		// swiftlint:disable discarded_notification_center_observer
		NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow,
		                                       object: nil,
		                                       queue: nil) { self.keyboardUpdateHandler(for: $0) }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide,
                                               object: nil,
                                               queue: nil) { self.keyboardUpdateHandler(for: $0) }
		// swiftlint:enable discarded_notification_center_observer
    }
	
    /** call this on viewWillDissapear */
    func unloadNotifications() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setHideKeyboardOnTap() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard) )
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
}

extension UIViewController {
    @objc
	func dismissKeyboard() {
        view.endEditing(true)
    }
}

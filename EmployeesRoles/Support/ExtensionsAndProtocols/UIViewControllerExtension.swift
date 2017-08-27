//
//  UIViewControllerExtension.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 27/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func setHideKeyboardOnTap() {
		let tap: UITapGestureRecognizer =
			UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard) )
		tap.cancelsTouchesInView = false
		
		view.addGestureRecognizer(tap)
	}
	
	@objc
	func dismissKeyboard() {
		self.view.endEditing(true)
	}
}

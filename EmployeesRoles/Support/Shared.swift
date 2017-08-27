//
//  Shared.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 27/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

protocol ReloadMasterViewDelegate: class {
	func reloadData()
}

protocol NewOrEditProtocol: class {
	var edit: Bool { get set }
	
	var newTitle: String { get }
	var editTitle: String { get }
	
	var newUnwindSegue: String { get }
	var editUnwindSegue: String { get }
	
	func newOrEdit(_ editObject: Any?)
	func performCorrectSegue()
}

extension NewOrEditProtocol where Self: UIViewController {
	
	func newOrEdit(_ editObject: Any?) {
		if editObject == nil {
			self.edit = false
			self.navigationItem.title = self.newTitle
			
		} else {
			self.edit = true
			self.navigationItem.title = self.editTitle
			
		}
	}
	
	func performCorrectSegue() {
		if self.edit {
			self.performSegue(withIdentifier: self.editUnwindSegue, sender: self)
		} else {
			self.performSegue(withIdentifier: self.newUnwindSegue, sender: self)
		}
	}
	
}

//
//  EditEmployeeTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 26/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EditEmployeeTableViewController: UITableViewController {

	var employee: Employee?
	
	private var edit = false
	
	private let newEmployeeUnwindSegue = ""
	private let editEmployeeUnwindSegue = ""
	
	// MARK: - View Methods
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.setHideKeyboardOnTap()
		
		self.editOrNew()
		self.refillData()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.employee = nil
	}
	

    // MARK: - Private Methods
	
	private func editOrNew() {
		if self.employee == nil {
			self.edit = false
			
			self.navigationItem.title = NSLocalizedString("newEmployee", tableName: "Localizable", bundle: Bundle.main, value: "New Employee", comment: "Title for the new employee screen")
		} else {
			self.edit = true
			
			self.navigationItem.title = NSLocalizedString("editEmployee", tableName: "Localizable", bundle: Bundle.main, value: "Edit Employee", comment: "Title for the edit employee screen")
		}
	}
	
	private func refillData() {
		// TODO: here
	}
	
	private func setHideKeyboardOnTap() {
		let tap: UITapGestureRecognizer =
			UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard) )
		tap.cancelsTouchesInView = false
		
		view.addGestureRecognizer(tap)
	}
	
	@objc
	private func dismissKeyboard() {
		view.endEditing(true)
	}
	
	private func testFilledFields() -> Bool {
		return false // TODO: here
	}

    // MARK: - Navigation

	@IBAction func cancelRole(_ sender: UIBarButtonItem) {
		self.performCorrectSegue()
	}
	
	@IBAction func saveRole(_ sender: UIBarButtonItem) {
		if self.testFilledFields() {
			
			// TODO: Here
			
		}
	}
	
	private func performCorrectSegue() {
		if self.edit {
			self.performSegue(withIdentifier: self.editEmployeeUnwindSegue, sender: self)
		} else {
			self.performSegue(withIdentifier: self.newEmployeeUnwindSegue, sender: self)
		}
	}
	
	
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

}

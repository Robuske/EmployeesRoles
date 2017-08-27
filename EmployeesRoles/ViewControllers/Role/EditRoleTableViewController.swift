//
//  EditRoleTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 25/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EditRoleTableViewController: UITableViewController, NewOrEditProtocol, UITextFieldDelegate {
	
	var role: Role?

	var edit = false
	
	let newTitle = NSLocalizedString("newRole", tableName: "Localizable", bundle: Bundle.main, value: "New Role", comment: "Title for the new role screen")
	
	let editTitle = NSLocalizedString("editRole", tableName: "Localizable", bundle: Bundle.main, value: "Edit Role", comment: "Title for the edit role screen")
	
	let newUnwindSegue = "newRoleUnwind"
	let editUnwindSegue = "editRoleUnwind"
	
	@IBOutlet private weak var roleTextField: UITextField!
	@IBOutlet private weak var salaryTextField: UITextField!
	
	// MARK: - View Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.roleTextField.delegate = self
		self.salaryTextField.delegate = self
		
		self.setHideKeyboardOnTap()
		
		self.newOrEdit(with: self.role)
		self.refillData()
	}
	
	// MARK: - Private Methods
	
	private func refillData() {
		if let currentRole = self.role {
			
			self.roleTextField.text = currentRole.name
			self.salaryTextField.text = String(currentRole.salary)
			
		} else {
			
			self.roleTextField.text = ""
			self.salaryTextField.text = ""
			
		}
	}
	
	private func testFilledFields() -> Bool {
		return self.roleTextField.text != "" && self.salaryTextField.text != ""
	}
	
	// MARK: - Other Methods
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.dismissKeyboard()
		return true
	}
	
	// MARK: - Navigation
	
	@IBAction func cancelRole(_ sender: UIBarButtonItem) {
		self.performCorrectSegue()
	}
	
	@IBAction func saveRole(_ sender: UIBarButtonItem) {
		if self.testFilledFields() {
			
			var company = DataLayer.instance.loadCompany()
			
			let newRoleName = self.roleTextField.text!
			let newSalary = UInt(self.salaryTextField.text!.stripToInt())
			
			if self.role != nil {
				self.role!.name = newRoleName
				self.role!.salary = newSalary
				
				company.edit(self.role!)
			
			} else {
				
				let newRole = Role(name: newRoleName, salary: newSalary)
				
				company.add(newRole)
				
			}
			
			_ = DataLayer.instance.save(company)
			
			self.performCorrectSegue()
		}
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let roleTableViewController = segue.destination as? RoleTableViewController {
			roleTableViewController.role = self.role
		}
    }
	
}

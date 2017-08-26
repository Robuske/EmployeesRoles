//
//  EditRoleTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 25/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EditRoleTableViewController: UITableViewController {

	private let newRoleUnwindSegue = "fromNewRoleToRoles"
	private let editRoleUnwindSegue = "fromNewRoleToRole"
	
	var role: Role?
	
	@IBOutlet private weak var roleTextField: UITextField!
	@IBOutlet private weak var salaryTextField: UITextField!
	
	private var edit = false
	
	// MARK: - View Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.setHideKeyboardOnTap()
		
		self.setUpEdit()
		self.fillTextFields()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.role = nil
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// MARK: - General Methods
	
	private func setUpEdit() {
		if self.role == nil {
			self.edit = false
			self.navigationItem.title = NSLocalizedString("newRole", tableName: "Localizable", bundle: Bundle.main, value: "New Role", comment: "Title for the new role screen")
		} else {
			self.edit = true
			self.navigationItem.title = NSLocalizedString("editRole", tableName: "Localizable", bundle: Bundle.main, value: "Edit Role", comment: "Title for the edit role screen")
		}
	}
	
	private func fillTextFields() {
		if let currentRole = self.role {
			self.roleTextField.text = currentRole.name
			self.salaryTextField.text = String(currentRole.salary)
		} else {
			self.roleTextField.text = ""
			self.salaryTextField.text = ""
		}
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
		return self.roleTextField.text != "" && self.salaryTextField.text != ""
	}
	
	// MARK: - Navigation
	
	private func performCorrectSegue() {
		if self.edit {
			self.performSegue(withIdentifier: self.editRoleUnwindSegue, sender: self)
		} else {
			self.performSegue(withIdentifier: self.newRoleUnwindSegue, sender: self)
		}
	}
	
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

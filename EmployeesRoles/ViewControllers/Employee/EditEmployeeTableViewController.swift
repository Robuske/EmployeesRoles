//
//  EditEmployeeTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 26/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EditEmployeeTableViewController: UITableViewController, NewOrEditProtocol, UITextFieldDelegate {

	var employee: Employee?
	var employeeRole: Role?
	
	var edit = false
	
	let newTitle = NSLocalizedString("newEmployee", tableName: "Localizable", bundle: Bundle.main, value: "New Employee", comment: "Title for the new employee screen")
	let editTitle = NSLocalizedString("editEmployee", tableName: "Localizable", bundle: Bundle.main, value: "Edit Employee", comment: "Title for the edit employee screen")
	
	let newUnwindSegue = "newEmployeeUnwind"
	let editUnwindSegue = "editEmployeeUnwind"
	
	@IBOutlet private weak var nameField: UITextField!
	@IBOutlet private weak var salaryField: UITextField!
	
	@IBOutlet private weak var birthdatePicker: UIDatePicker!
	
	@IBOutlet private weak var birthdateLabel: UILabel!
	@IBOutlet private weak var roleNameLabel: UILabel!
	
	// MARK: - View Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.nameField.delegate = self
		self.salaryField.delegate = self
		
		self.birthdatePicker.maximumDate = Date()
		
		self.setHideKeyboardOnTap()
		
		self.newOrEdit(self.employee)
		self.refillData()
	}
	

    // MARK: - Private Methods
	
	private func refillData() {
		if let currentEmployee = self.employee {
			
			self.nameField.text = currentEmployee.name
			self.salaryField.text = String(currentEmployee.salary)
			
			self.birthdatePicker.date = currentEmployee.birthdate
			
			//self.updateBirthdateLabel()
			self.roleNameLabel.text = currentEmployee.role.name
			
		} else {
			
			self.nameField.text = ""
			self.salaryField.text = ""
			
			self.birthdatePicker.date = Date()
			
			//self.updateBirthdateLabel()
			self.roleNameLabel.text = ""
			
		}
	}
	
	private func updateBirthdateLabel() {
		self.birthdateLabel.text = DateFormatter.localizedString(from: self.birthdatePicker.date, dateStyle: .short, timeStyle: .none)
	}
	
	private func testFilledFields() -> Bool {
		let nameTest = self.nameField.text != ""
		let salaryTest = self.salaryField.text != ""
		let roleTest = self.employeeRole != nil
		
		return nameTest && salaryTest && roleTest
	}
	
	// MARK: - Other Methods
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.dismissKeyboard()
		return true
	}
	
	
	@IBAction func birthdateDidChange(_ sender: UIDatePicker) {
		self.updateBirthdateLabel()
	}

    // MARK: - Navigation

	@IBAction func cancelEmployee(_ sender: UIBarButtonItem) {
		self.performCorrectSegue()
	}
	
	@IBAction func saveEmployee(_ sender: UIBarButtonItem) {
		if self.testFilledFields() {
			
			// TODO: Here
			
		}
	}
	
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let employeeTableViewController = segue.destination as? EmployeeTableViewController {
			employeeTableViewController.employee = self.employee
		}
    }

}

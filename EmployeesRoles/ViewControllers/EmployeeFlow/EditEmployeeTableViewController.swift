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
		
		self.newOrEdit(with: self.employee)
		self.refillData()
	}

    // MARK: - Private Methods
	
	private func refillData() {
		if let currentEmployee = self.employee {
			
			self.nameField.text = currentEmployee.name
			self.salaryField.text = String(currentEmployee.salary)
			
			self.birthdatePicker.date = currentEmployee.birthdate
			
			self.updateBirthdateLabel()
			
			self.employeeRole = currentEmployee.role
			
		} else {
			
			self.nameField.text = ""
			self.salaryField.text = ""
			
			self.birthdatePicker.date = Date()
			
			self.updateBirthdateLabel()
			
		}
		
		self.refillRoleData()
	}
	
	private func refillRoleData() {
		if let currentEmployeeRole = self.employeeRole {
			self.roleNameLabel.text = currentEmployeeRole.name
			self.salaryField.text = String(currentEmployeeRole.salary)
		} else {
			self.roleNameLabel.text = ""
			self.salaryField.text = ""
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
			
			var company = DataLayer.instance.loadCompany()
			
			let newEmployeeName = self.nameField.text!
			let newEmployeeBirthdate = self.birthdatePicker.date
			let newEmployeeSalary = UInt(self.salaryField.text!.stripToInt())
			let newEmployeeRole = self.employeeRole!
			
			if self.employee != nil {
				self.employee!.name = newEmployeeName
				self.employee!.birthdate = newEmployeeBirthdate
				self.employee!.salary = newEmployeeSalary
				self.employee!.role = newEmployeeRole
				
				company.edit(self.employee!)
			} else {
				let newEmployee = Employee(name: newEmployeeName,
				                           birthdate: newEmployeeBirthdate,
				                           salary: newEmployeeSalary,
				                           role: newEmployeeRole)
				
				company.add(newEmployee)
			}
			
			_ = DataLayer.instance.save(company)
			
			self.performCorrectSegue()
		}
	}
	
	@IBAction func unwindToEditEmployee(with unwindSegue: UIStoryboardSegue) {
		self.refillRoleData()
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let employeeTableViewController = segue.destination as? EmployeeTableViewController {
			
			employeeTableViewController.employee = self.employee
			
		} else if let roleSelectorController = segue.destination as? RoleSelectorTableViewController {
			
			roleSelectorController.selectedRole = self.employeeRole
			
		}
    }

}

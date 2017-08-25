//
//  EditRoleTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 25/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EditRoleTableViewController: UITableViewController {

	private let unwindSegue = "unwindFromNewRole"
	
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
			self.salaryTextField.text = NumberFormatter.localizedString(from: NSNumber(value: currentRole.salary), number: .currency)
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
	
	@IBAction func saveRole(_ sender: UIBarButtonItem) {
		if self.testFilledFields() {
			
			var company = DataLayer.instance.loadCompany()
			
			let newRoleName = self.roleTextField.text!
			let newSalary = UInt(self.salaryTextField.text!)!
			
			if var oldRole = self.role {
				oldRole.name = newRoleName
				oldRole.salary = newSalary
				
				company.edit(oldRole)
			
			} else {
				
				let newRole = Role(name: newRoleName, salary: newSalary)
				
				company.add(newRole)
				
			}
			
			_ = DataLayer.instance.save(company)
			
			self.performSegue(withIdentifier: self.unwindSegue, sender: self)
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

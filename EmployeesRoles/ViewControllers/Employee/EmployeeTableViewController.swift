//
//  EmployeeTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 26/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EmployeeTableViewController: UITableViewController {

	var employee: Employee?
	
	weak var delegate: ReloadMasterViewDelegate?
	
	private let editEmployeeSegue = "editEmployee"
	
	@IBOutlet weak var employeeName: UILabel!
	@IBOutlet weak var employeeBirthdate: UILabel!
	@IBOutlet weak var employeeRole: UILabel!
	@IBOutlet weak var employeeSalary: UILabel!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.testIfShouldShow()
		self.refillData()
    }
	
	// MARK: - Private Methods
	
	private func refillData() {
		if let currentEmployee = self.employee {
			self.title = currentEmployee.name
			// TODO: here
		}
	}
	
	private func testIfShouldShow() {
		let employeeIsNil = self.employee == nil
		
		self.view.isHidden = employeeIsNil
		self.title = ""
		
		if employeeIsNil {
			self.navigationItem.rightBarButtonItem = nil
		} else {
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editEmployee))
		}
	}

    // MARK: - Navigation

	@objc
	private func editEmployee() {
		self.performSegue(withIdentifier: self.editEmployeeSegue, sender: self)
	}
	
	@IBAction func unwindToEmployee(with unwindSegue: UIStoryboardSegue) {
		self.refillData()
		self.delegate?.reloadData()
	}
	
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

}

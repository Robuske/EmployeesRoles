//
//  EmployeeTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 26/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EmployeeTableViewController: UITableViewController, ShowDetailProtocol {

	weak var delegate: ReloadMasterViewDelegate?
	
	var employee: Employee?
	
	let editSegue = "editEmployee"
	
	@IBOutlet private weak var employeeName: UILabel!
	@IBOutlet private weak var employeeBirthdate: UILabel!
	@IBOutlet private weak var employeeRole: UILabel!
	@IBOutlet private weak var employeeSalary: UILabel!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.testIfShouldShow(with: self.employee)
		self.refillData()
    }
	
	// MARK: - Private Methods
	
	private func refillData() {
		if let currentEmployee = self.employee {
			//self.title = currentEmployee.name
			
			self.employeeName.text = currentEmployee.name
			self.employeeBirthdate.text = DateFormatter.localizedString(from: currentEmployee.birthdate, dateStyle: .short, timeStyle: .none)
			self.employeeRole.text = currentEmployee.role.name
			self.employeeSalary.text = NumberFormatter.localizedString(from: NSNumber(value: currentEmployee.salary), number: .currency)
		}
	}

    // MARK: - Navigation
	
	@IBAction func unwindToEmployee(with unwindSegue: UIStoryboardSegue) {
		self.refillData()
		self.delegate?.reloadData()
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let destinationNavigationController = segue.destination as? UINavigationController,
			let editEmployeeTableViewController = destinationNavigationController.topViewController as? EditEmployeeTableViewController {
			
			editEmployeeTableViewController.employee = self.employee
			
		}
		
    }

}

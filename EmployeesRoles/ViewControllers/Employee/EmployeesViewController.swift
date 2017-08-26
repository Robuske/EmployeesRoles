//
//  EmployeesViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 22/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EmployeesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReloadMasterViewDelegate {

	private let employeeCellIdentifier = "employeeCell"
	private var employees = [Employee]()
	
	@IBOutlet private weak var table: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.reloadData()
    }
	
	func reloadData() {
		let company = DataLayer.instance.loadCompany()
		self.employees = company.employees.sorted { $0.name < $1.name }
		
		self.table.reloadSections(IndexSet([0]), with: .automatic)
	}
	
	
	// MARK: - Table view data source
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.employees.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.employeeCellIdentifier, for: indexPath)
		
		let employee = self.employees[indexPath.row]
		
		cell.textLabel?.text = employee.name
		cell.detailTextLabel?.text = employee.role.name
		
		return cell
	}

    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
	
}

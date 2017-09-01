//
//  EmployeesViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 22/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EmployeesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReloadMasterViewDelegate, DataLayerUpdate {

	private let employeeCellIdentifier = "employeeCell"
	private var employees = [Employee]()
	
	@IBOutlet private weak var table: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		DataLayer.instance.insertAsDelegate(self)
		
		self.reloadData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
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
	
	// MARK: - Table view delegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

    // MARK: - Navigation
	
	@IBAction func unwindToEmployees(with unwindSegue: UIStoryboardSegue) {
		self.reloadData()
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destinationNavigationController = segue.destination as? UINavigationController,
			let employeeController = destinationNavigationController.topViewController as? EmployeeTableViewController {
			
			if let selectedRow = self.table.indexPathForSelectedRow?.row {
				employeeController.employee = self.employees[selectedRow]
				employeeController.delegate = self
			}
		}
    }
	
}

//
//  RoleSelectorTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 27/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class RoleSelectorTableViewController: UITableViewController, RolesDataProtocol {

	var selectedRole: Role?
	var roles = [Role]()
	
	private let roleCellIdentifier = "roleCell"
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.reloadData(in: self.tableView)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.roleCellIdentifier, for: indexPath)

		let role = roles[indexPath.row]
		
        self.format(cell, with: role)
		
		if self.selectedRole == role {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}

        return cell
    }
	
	// MARK: - Table view delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedRole = self.roles[indexPath.row]
		
		self.reloadData(in: self.tableView)
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let editEmployeeController = segue.destination as? EditEmployeeTableViewController {
			
			editEmployeeController.employeeRole = self.selectedRole
			
		}
    }

}

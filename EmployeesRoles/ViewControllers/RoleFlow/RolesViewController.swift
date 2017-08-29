//
//  RolesViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 22/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class RolesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReloadMasterViewDelegate, RolesDataProtocol {

	var roles = [Role]()

	private let roleCellIdentifier = "roleCell"
	
	@IBOutlet private weak var table: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.reloadData()
    }
	
	func reloadData() {
		self.reloadData(in: table)
		
	}
	
	// MARK: - Table view data source
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.roles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.roleCellIdentifier, for: indexPath)
		
		let role = self.roles[indexPath.row]
		
		self.format(cell, with: role)
		
		return cell
	}
	
	// MARK: - Table view delegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - Navigation

	@IBAction func unwindToRoles(with unwindSegue: UIStoryboardSegue) {
		self.reloadData()
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destinationNavigationController = segue.destination as? UINavigationController,
			let roleTableViewController = destinationNavigationController.topViewController as? RoleTableViewController {
			if let selectedRow = self.table.indexPathForSelectedRow?.row {
				roleTableViewController.role = self.roles[selectedRow]
				roleTableViewController.delegate = self
			}
		}
    }

}

//
//  RoleTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 25/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class RoleTableViewController: UITableViewController, ShowDetailProtocol {
	
	weak var delegate: ReloadMasterViewDelegate?

	var role: Role?
	
	let editSegue = "editRole"
	
	@IBOutlet private weak var roleName: UILabel!
	@IBOutlet private weak var roleSalary: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.testIfShouldShow(with: self.role)
		self.refillData()
    }
	
	// MARK: - Private Methods
	
	private func refillData() {
		if let currentRole = self.role {
			//self.title = currentRole.name
			
			self.roleName.text = currentRole.name
			self.roleSalary.text = NumberFormatter.localizedString(from: NSNumber(value: currentRole.salary), number: .currency)
		}
	}
	
    // MARK: - Navigation
	
	@IBAction func unwindToRole(with unwindSegue: UIStoryboardSegue) {
		self.refillData()
		self.delegate?.reloadData()
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let destinationNavigationController = segue.destination as? UINavigationController,
			let editRoleTableViewController = destinationNavigationController.topViewController as? EditRoleTableViewController {
			
			editRoleTableViewController.role = self.role
			
		}
    }

}

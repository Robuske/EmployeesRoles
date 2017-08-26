//
//  RoleTableViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 25/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class RoleTableViewController: UITableViewController {

	var role: Role?
	
	
	@IBOutlet private weak var roleName: UILabel!
	@IBOutlet private weak var roleSalary: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.refillData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	private func refillData() {
		if let currentRole = self.role {
			self.roleName.text = currentRole.name
			self.roleSalary.text = NumberFormatter.localizedString(from: NSNumber(value: currentRole.salary), number: .currency)
		}
	}
	
	@IBAction func unwindToRole(with unwindSegue: UIStoryboardSegue) {
		self.refillData()
	}
	
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let destinationNavigationController = segue.destination as? UINavigationController,
			let editRoleTableViewController = destinationNavigationController.topViewController as? EditRoleTableViewController {
			editRoleTableViewController.role = self.role
		}
    }

}

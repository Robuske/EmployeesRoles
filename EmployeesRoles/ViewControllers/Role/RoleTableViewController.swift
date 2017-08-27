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
	
	weak var delegate: ReloadMasterViewDelegate?
	
	private let editRoleSegue = "editRole"
	
	@IBOutlet private weak var roleName: UILabel!
	@IBOutlet private weak var roleSalary: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.testIfShouldShow()
		self.refillData()
    }
	
	// MARK: - Private Methods
	
	private func refillData() {
		if let currentRole = self.role {
			self.title = currentRole.name
			
			self.roleName.text = currentRole.name
			self.roleSalary.text = NumberFormatter.localizedString(from: NSNumber(value: currentRole.salary), number: .currency)
		}
	}
	
	private func testIfShouldShow() {
		let roleIsNil = self.role == nil
		
		self.view.isHidden = roleIsNil
		self.title = ""
		
		if roleIsNil {
			self.navigationItem.rightBarButtonItem = nil
		} else {
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editRole))
		}
	}
	
    // MARK: - Navigation

	@objc
	private func editRole() {
		self.performSegue(withIdentifier: self.editRoleSegue, sender: self)
	}
	
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

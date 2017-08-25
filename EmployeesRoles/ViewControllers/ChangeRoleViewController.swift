//
//  RoleViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 24/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class ChangeRoleViewController: UIViewController, KeyboardDelegate {
	
	var role: Role?
	
	@IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint! // swiftlint:disable:this private_outlet
	@IBOutlet private weak var roleTextField: UITextField!
	@IBOutlet private weak var salaryTextField: UITextField!
	
	private var edit = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.loadNotifications()
		
		self.setUpEdit()
		self.fillTextFields()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.unloadNotifications()
		
		self.role = nil
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
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
	
	
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

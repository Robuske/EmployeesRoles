//
//  RoleViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 24/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class ChangeRoleViewController: UIViewController {

	var role: Role?
	
	@IBOutlet private weak var roleTextField: UITextField!
	@IBOutlet private weak var salaryTextField: UITextField!
	
	private var edit = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if self.role == nil {
			self.edit = false
			self.navigationItem.title = NSLocalizedString("newRole", comment: "Title for the new role screen")
		} else {
			self.edit = true
			self.navigationItem.title = NSLocalizedString("editRole", comment: "Title for the edit role screen")
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.role = nil
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

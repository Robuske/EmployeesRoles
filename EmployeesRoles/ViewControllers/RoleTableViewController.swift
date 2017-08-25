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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	
	private func reloadData() {
		
	}
	
	@IBAction func unwindToRole(with unwindSegue: UIStoryboardSegue) {
		self.reloadData()
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

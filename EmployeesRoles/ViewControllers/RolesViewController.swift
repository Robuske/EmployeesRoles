//
//  RolesViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 22/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class RolesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	private let roleCellIdentifier = "roleCell"
	private var roles: [Role]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let oldCompany = DataLayer.instance.loadCompanies().first {
			
			self.roles = oldCompany.roles.sorted { $0.name > $1.name }
			
		} else {
			let newCompany = Company(name: "Awesome Inc")
			
			let allCompanies = Set([newCompany])
			_ = DataLayer.instance.save(allCompanies)
			
			self.roles = []
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.roles?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.roleCellIdentifier, for: indexPath)
		
		if let role = self.roles?[indexPath.row] {
			cell.textLabel?.text = role.name
			cell.detailTextLabel?.text = String(role.salary)
		}
		
		return cell
	}
	
	@IBAction func unwindToRoles(with unwindSegue: UIStoryboardSegue) {
		
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

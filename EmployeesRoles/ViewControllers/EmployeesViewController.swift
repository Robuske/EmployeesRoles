//
//  EmployeesViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 22/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class EmployeesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	private let employeeCellIdentifier = "employeeCell"
	private var employees = [Employee]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let oldCompany = DataLayer.instance.loadCompanies().first {
			
			self.employees = oldCompany.employees.sorted { $0.name > $1.name }
			
		} else {
			let newCompany = Company(name: "Awesome Inc")
			
			let allCompanies = Set([newCompany])
			_ = DataLayer.instance.save(allCompanies)
			
			self.employees = []
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

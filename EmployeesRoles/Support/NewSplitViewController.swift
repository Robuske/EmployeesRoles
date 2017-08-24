//
//  NewSplitViewController.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 24/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

class NewSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.delegate = self
	}
	
	public func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return true
	}
}

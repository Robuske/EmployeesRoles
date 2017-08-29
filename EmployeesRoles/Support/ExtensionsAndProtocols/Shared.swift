//
//  Shared.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 27/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import UIKit

protocol ReloadMasterViewDelegate: class {
	func reloadData()
}

// MARK: RolesDataProtocol

protocol RolesDataProtocol: class {
	var roles: [Role] { get set }
	
	func reloadData(in tableView: UITableView)
	func format(_ cell: UITableViewCell, with role: Role)
}

extension RolesDataProtocol where Self: UIViewController {
	
	func reloadData(in tableView: UITableView) {
		let company = DataLayer.instance.loadCompany()
		self.roles = company.roles.sorted { $0.name < $1.name }
		
		tableView.reloadSections(IndexSet([0]), with: .automatic)
	}
	
	func format(_ cell: UITableViewCell, with role: Role) {
		
		cell.textLabel?.text = role.name
		cell.detailTextLabel?.text = NumberFormatter.localizedString(from: NSNumber(value: role.salary), number: .currency)
		
	}
}

// MARK: NewOrEditProtocol

protocol NewOrEditProtocol: class {
	var edit: Bool { get set }
	
	var newTitle: String { get }
	var editTitle: String { get }
	
	var newUnwindSegue: String { get }
	var editUnwindSegue: String { get }
	
	func newOrEdit(with editObject: Any?)
	func performCorrectSegue()
}

extension NewOrEditProtocol where Self: UIViewController {
	
	func newOrEdit(with editObject: Any?) {
		if editObject == nil {
			self.edit = false
			self.navigationItem.title = self.newTitle
			
		} else {
			self.edit = true
			self.navigationItem.title = self.editTitle
			
		}
	}
	
	func performCorrectSegue() {
		if self.edit {
			self.performSegue(withIdentifier: self.editUnwindSegue, sender: self)
		} else {
			self.performSegue(withIdentifier: self.newUnwindSegue, sender: self)
		}
	}
	
}

// MARK: ShowDetailProtocol

// swiftlint:disable:next strict_fileprivate
fileprivate final class ShowDetailWrapper {
	
	static let instance = ShowDetailWrapper()
	
	weak var delegate: ShowDetailProtocol?
	
	private init() {}
	
	// Protocol Extensions can't have @objc methods
	@objc
	func editObject() {
		if let viewController = delegate as? UIViewController {
			viewController.performSegue(withIdentifier: self.delegate!.editSegue, sender: self.delegate)
		}
	}
	
}

protocol ShowDetailProtocol: class {
	
	var editSegue: String { get }
	
	func testIfShouldShow(with testObject: Any?)
}

extension ShowDetailProtocol where Self: UIViewController {
	
	func testIfShouldShow(with testObject: Any?) {
		let objectIsNil = testObject == nil
		
		self.view.isHidden = objectIsNil
		//self.title = ""
		
		if objectIsNil {
			self.navigationItem.rightBarButtonItem = nil
		} else {
			ShowDetailWrapper.instance.delegate = self
			
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: ShowDetailWrapper.instance, action: #selector(ShowDetailWrapper.editObject))
		}
	}
	
}

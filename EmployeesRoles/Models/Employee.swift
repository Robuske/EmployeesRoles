//
//  Employee.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

struct Employee: Codable, Equatable, Hashable {
	
	let employeeId: UInt
	var name: String
	var birthdate: Date
	var salary: UInt
	
	var role: Role {
		get {
			let company = DataLayer.instance.loadCompany()
			return company.roles.first { $0.roleId == self.roleId }!
		}
		set {
			self.roleId = newValue.roleId
		}
	}
	
	private var roleId: UInt
	
	var hashValue: Int {
		return Int(self.employeeId)
	}
	
	init(name: String, birthdate: Date, salary: UInt, role: Role) {
		self.employeeId = IdProvider.instance.newEmployeeId()
		self.name = name
		self.birthdate = birthdate
		self.salary = salary
		self.roleId = role.roleId
	}
	
	static func == (lhs: Employee, rhs: Employee) -> Bool {
		return lhs.employeeId == rhs.employeeId
	}
}

//
//  Company.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 22/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

struct Company: Codable, Equatable, Hashable {
	let companyId: UInt
	let name: String
	
	var hashValue: Int {
		return Int(self.companyId)
	}
	
	private(set) var roles = Set<Role>()
	private(set) var employees = Set<Employee>()
	
	init(name: String) {
		self.companyId = IdProvider.instance.newCompanyId()
		self.name = name
	}
	
	static func == (lhs: Company, rhs: Company) -> Bool {
		return lhs.companyId == rhs.companyId
	}
	
	mutating func add(_ role: Role) {
		self.roles.insert(role)
	}
	
	mutating func add(_ employee: Employee) {
		self.employees.insert(employee)
	}
	
	mutating func edit(_ role: Role) {
		self.roles.update(with: role)
	}
	
	mutating func edit(_ employee: Employee) {
		self.employees.update(with: employee)
	}
	
}

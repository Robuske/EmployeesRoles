//
//  Role.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

struct Role: Codable, Equatable, Hashable {
	let roleId: UInt
	var name: String
	var salary: UInt
	
	var hashValue: Int {
		return Int(self.roleId)
	}
	
	init(name: String, salary: UInt) {
		self.roleId = IdProvider.instance.newRoleId()
		self.name = name
		self.salary = salary
	}
	
	static func == (lhs: Role, rhs: Role) -> Bool {
		return lhs.roleId == rhs.roleId
	}
}

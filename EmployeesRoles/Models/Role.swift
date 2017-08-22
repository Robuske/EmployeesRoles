//
//  Role.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

struct Role: Codable, Equatable {
	let roleId: UInt
	let name: String
	let salary: UInt
	
	init(name: String, salary: UInt) {
		self.roleId = IdProvider.instance.newRoleId()
		self.name = name
		self.salary = salary
	}
	
	static func == (lhs: Role, rhs: Role) -> Bool {
		return lhs.roleId == rhs.roleId
	}
}

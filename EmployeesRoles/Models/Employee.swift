//
//  Employee.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

struct Employee: Codable, Equatable {
	let employeeId: UInt
	let name: String
	let birthdate: Date
	let salary: UInt
	let role: Role
	
	
	
	static func == (lhs: Employee, rhs: Employee) -> Bool {
		return lhs.employeeId == rhs.employeeId
	}
}

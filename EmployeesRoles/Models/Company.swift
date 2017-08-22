//
//  Company.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 22/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

struct Company: Codable, Equatable {
	let companyId: UInt
	let name: String
	
	var roles = [Role]()
	var employees = [Employee]()
	
	init(name: String) {
		self.companyId = IdProvider.instance.newCompanyId()
		self.name = name
	}
	
	static func == (lhs: Company, rhs: Company) -> Bool {
		return lhs.companyId == rhs.companyId
	}
}

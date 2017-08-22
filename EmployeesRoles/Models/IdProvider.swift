//
//  IdProvider.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

class IdProvider: Codable {
	
	static let instance = IdProvider()
	
	private var nextCompanyId: UInt = 0
	private var nextRoleId: UInt = 0
	private var nextEmployeeId: UInt = 0
	
	private init() {}
	
	func newCompanyId() -> UInt {
		let old = self.nextCompanyId
		self.nextCompanyId += 1
		
		return old
	}
	
	func newRoleId() -> UInt {
		let old = self.nextRoleId
		self.nextRoleId += 1
		
		return old
	}
	
	func newEmployeeId() -> UInt {
		let old = self.nextEmployeeId
		self.nextEmployeeId += 1
		
		return old
	}
}

//
//  IdProvider.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

struct IdProvider: Codable, Equatable {
	
	static let instance = IdProvider()
	
	private var nextEmployeeId: UInt = 0
	private var nextRoleId: UInt = 0
	
	mutating func newEmployeeId() -> UInt {
		let old = self.nextEmployeeId
		self.nextEmployeeId += 1
		
		return old
	}
	
	mutating func newRoleId() -> UInt {
		let old = self.nextRoleId
		self.nextRoleId += 1
		
		return old
	}
	
	static func == (lhs: IdProvider, rhs: IdProvider) -> Bool {
		return lhs.nextEmployeeId == rhs.nextEmployeeId && lhs.nextRoleId == rhs.nextRoleId
	}
}

//
//  Employee.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import CloudKit
import Foundation

struct Employee: Codable, Equatable, Hashable {
	
	let typeName = "Employee"
	
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

extension Employee {
	
	private func intoRecord() -> CKRecord {
		let recordId = CKRecordID(recordName: String(self.employeeId))
		
		let record = CKRecord(recordType: self.typeName, recordID: recordId)
		
		record[Employee.CodingKeys.name.stringValue] = NSString(string: self.name)
		record[Employee.CodingKeys.birthdate.stringValue] = self.birthdate as NSDate
		record[Employee.CodingKeys.salary.stringValue] = NSString(string: String(self.salary))
		record[Employee.CodingKeys.roleId.stringValue] = NSString(string: String(self.roleId))
		
		return record
	}
	
	func intoReference() -> CKReference {
		let reference = CKReference(record: self.intoRecord(), action: .none)
		
		return reference
	}
	
}

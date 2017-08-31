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
	
	private init(employeeId: UInt, name: String, birthdate: Date, salary: UInt, roleId: UInt) {
		self.employeeId = employeeId
		self.name = name
		self.birthdate = birthdate
		self.salary = salary
		self.roleId = roleId
	}
	
	init(name: String, birthdate: Date, salary: UInt, role: Role) {
		self.init(employeeId: IdProvider.instance.newEmployeeId(), name: name, birthdate: birthdate, salary: salary, roleId: role.roleId)
	}
	
	static func == (lhs: Employee, rhs: Employee) -> Bool {
		return lhs.employeeId == rhs.employeeId
	}
}

extension Employee: CloudLayerProtocol {
	init?(_ record: CKRecord) {
		guard let name = record[Employee.CodingKeys.name.stringValue] as? String,
		let birthdate = record[Employee.CodingKeys.birthdate.stringValue] as? Date,
		let salary = record[Employee.CodingKeys.salary.stringValue] as? UInt,
		let roleId = record[Employee.CodingKeys.roleId.stringValue] as? UInt else {
			print("Couldn't decode Employee record")
			return nil
		}
		
		let employeeId = UInt(record.recordID.recordName.stripToInt())
		
		self.init(employeeId: employeeId, name: name, birthdate: birthdate, salary: salary, roleId: roleId)
	}
	
	func getRecordId() -> CKRecordID {
		return CKRecordID(recordName: "\(self.typeName)\(self.employeeId)")
	}
	
	func setRecordValues(for record: CKRecord) -> CKRecord {
		
		record[Employee.CodingKeys.name.stringValue] = self.name as CKRecordValue
		record[Employee.CodingKeys.birthdate.stringValue] = self.birthdate as CKRecordValue
		record[Employee.CodingKeys.salary.stringValue] = self.salary as CKRecordValue
		record[Employee.CodingKeys.roleId.stringValue] = self.roleId as CKRecordValue
		
		return record
	}
	
	func getReference() -> CKReference {
		let reference = CKReference(recordID: self.getRecordId(), action: .none)
		
		return reference
	}
	
}

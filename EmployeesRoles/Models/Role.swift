//
//  Role.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import CloudKit
import Foundation

struct Role: Codable, Equatable, Hashable {
	
	let typeName = "Role"
	
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

extension Role {
	func intoRecord() -> CKRecord {
		let recordId = CKRecordID(recordName: "\(self.typeName)\(self.roleId)")
		
		let record = CKRecord(recordType: self.typeName, recordID: recordId)
		
		record[Role.CodingKeys.name.stringValue] = NSString(string: self.name)
		record[Role.CodingKeys.salary.stringValue] = NSString(string: String(self.salary))
		
		return record
	}
	
	func intoReference() -> CKReference {
		let reference = CKReference(record: self.intoRecord(), action: .none)
		
		return reference
	}
}

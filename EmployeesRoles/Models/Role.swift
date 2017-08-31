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
	
	private init(roleId: UInt, name: String, salary: UInt) {
		self.roleId = roleId
		self.name = name
		self.salary = salary
	}
	
	init(name: String, salary: UInt) {
		self.init(roleId: IdProvider.instance.newRoleId(), name: name, salary: salary)
	}
	
	static func == (lhs: Role, rhs: Role) -> Bool {
		return lhs.roleId == rhs.roleId
	}
}

extension Role: CloudLayerProtocol {
	init?(_ record: CKRecord) {
		guard let name = record[Role.CodingKeys.name.stringValue] as? String,
			let salary = record[Role.CodingKeys.salary.stringValue] as? UInt else {
				print("Couldn't decode Role record")
				return nil
		}
		
		let roleId = UInt(record.recordID.recordName.stripToInt())
		
		self.init(roleId: roleId, name: name, salary: salary)
	}
	
	func getRecordId() -> CKRecordID {
		return CKRecordID(recordName: "\(self.typeName)\(self.roleId)")
	}
	
	func setRecordValues(for record: CKRecord) -> CKRecord {
		
		record[Role.CodingKeys.name.stringValue] = self.name as CKRecordValue
		record[Role.CodingKeys.salary.stringValue] = self.salary as CKRecordValue
		
		return record
	}
	
	func getReference() -> CKReference {
		let reference = CKReference(recordID: self.getRecordId(), action: .none)
		
		return reference
	}
	
}

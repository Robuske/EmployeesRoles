//
//  IdProvider.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import CloudKit
import Foundation

class IdProvider: Codable {
	
	static let instance: IdProvider = {
		if let oldInstance = DataLayer.instance.loadIdProvider() {
			return oldInstance
		}
		
		return IdProvider()
	}()
	
	let idProviderType = "IdProvider"
	
	private var nextCompanyId: UInt
	private var nextEmployeeId: UInt
	private var nextRoleId: UInt
	
	private init(nextCompanyId: UInt, nextEmployeeId: UInt, nextRoleId: UInt) {
		self.nextCompanyId = nextCompanyId
		self.nextEmployeeId = nextEmployeeId
		self.nextRoleId = nextRoleId
	}
	
	convenience private init() {
		self.init(nextCompanyId: 0, nextEmployeeId: 0, nextRoleId: 0)
	}
	
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

extension IdProvider {
	
	func intoRecord() -> CKRecord {
		let recordId = CKRecordID(recordName: self.idProviderType)
		
		let idProviderRecord = CKRecord(recordType: self.idProviderType, recordID: recordId)
		
		idProviderRecord[IdProvider.CodingKeys.nextCompanyId.stringValue] = NSString(string: String(self.nextCompanyId))
		idProviderRecord[IdProvider.CodingKeys.nextEmployeeId.stringValue] = NSString(string: String(self.nextEmployeeId))
		idProviderRecord[IdProvider.CodingKeys.nextRoleId.stringValue] = NSString(string: String(self.nextRoleId))
		
		return idProviderRecord
	}
	
	convenience init(record: CKRecord) {
		
		guard let companyId = record["nextCompanyId"] as? Int,
			let employeeId = record["nextEmployeeId"] as? Int,
			let roleId = record["nextRoleId"] as? Int else {
			fatalError("Couldn't decode IdProvider record")
		}
		
		self.init(nextCompanyId: UInt(companyId), nextEmployeeId: UInt(employeeId), nextRoleId: UInt(roleId))
	}
	
}

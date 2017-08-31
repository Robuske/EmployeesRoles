//
//  IdProvider.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 21/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import CloudKit
import Foundation

final class IdProvider: Codable {
	
	static let instance: IdProvider = {
		if let oldInstance = DataLayer.instance.loadIdProvider() {
			return oldInstance
		}
		
		return IdProvider()
	}()
	static let typeName = "IdProvider"
	
	var typeName: String {
		return IdProvider.typeName
	}
	
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

extension IdProvider: CloudLayerProtocol {
	convenience init?(_ record: CKRecord) {
		
		guard let companyId = record[IdProvider.CodingKeys.nextCompanyId.stringValue] as? UInt,
			let employeeId = record[IdProvider.CodingKeys.nextEmployeeId.stringValue] as? UInt,
			let roleId = record[IdProvider.CodingKeys.nextRoleId.stringValue] as? UInt else {
				print("Couldn't decode IdProvider record")
				return nil
		}
		
		self.init(nextCompanyId: companyId, nextEmployeeId: employeeId, nextRoleId: roleId)
	}
	
	func getRecordId() -> CKRecordID {
		return CKRecordID(recordName: self.typeName)
	}
	
	func setRecordValues(for record: CKRecord) -> CKRecord {
		
		record[IdProvider.CodingKeys.nextCompanyId.stringValue] = self.nextCompanyId as CKRecordValue
		record[IdProvider.CodingKeys.nextEmployeeId.stringValue] = self.nextEmployeeId as CKRecordValue
		record[IdProvider.CodingKeys.nextRoleId.stringValue] = self.nextRoleId as CKRecordValue
		
		return record
	}
	
	static func reload(with newObject: IdProvider) {
		instance.nextCompanyId = newObject.nextCompanyId
		instance.nextEmployeeId = newObject.nextEmployeeId
		instance.nextRoleId = newObject.nextRoleId
	}
	
}

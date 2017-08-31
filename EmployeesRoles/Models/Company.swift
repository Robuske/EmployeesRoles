//
//  Company.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 22/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import CloudKit
import Foundation

struct Company: Codable, Equatable, Hashable {
	
	static let typeName = "Company"
	
	let companyId: UInt
	let name: String
	
	var hashValue: Int {
		return Int(self.companyId)
	}
	
	private(set) var roles: Set<Role>
	private(set) var employees: Set<Employee>
	
	private init(companyId: UInt, name: String, roles: Set<Role>, employees: Set<Employee>) {
		self.companyId = companyId
		self.name = name
		self.roles = roles
		self.employees = employees
	}
	
	init(name: String) {
		self.init(companyId: IdProvider.instance.newCompanyId(), name: name, roles: Set(), employees: Set())
	}
	
	static func == (lhs: Company, rhs: Company) -> Bool {
		return lhs.companyId == rhs.companyId
	}
	
	mutating func add(_ role: Role) {
		self.roles.insert(role)
	}
	
	mutating func add(_ employee: Employee) {
		self.employees.insert(employee)
	}
	
	mutating func edit(_ role: Role) {
		self.roles.update(with: role)
	}
	
	mutating func edit(_ employee: Employee) {
		self.employees.update(with: employee)
	}
	
}

extension Company: CloudLayerRecords {

	static func loadCompany(_ record: CKRecord, completed: @escaping (Company?) -> Void) {
		
		guard let name = record[Company.CodingKeys.name.stringValue] as? String,
			let rolesReferences = record[Company.CodingKeys.roles.stringValue] as? [CKReference],
			let employeesReferences = record[Company.CodingKeys.employees.stringValue] as? [CKReference] else {
				print("Couldn't decode Company record")
				completed(nil)
				return
		}
		
		let companyId = UInt(record.recordID.recordName.stripToInt())
		
		CloudLayer.instance.load(rolesReferences + employeesReferences) { employees, roles in
			if let roles = roles, let employees = employees {
				
				completed(Company(companyId: companyId, name: name, roles: roles, employees: employees))
				
			} else {
				completed(nil)
			}
			
		}
		
	}
	
	func getRecordId() -> CKRecordID {
		return CKRecordID(recordName: "\(Company.typeName)\(self.companyId)")
	}
	
	func setRecordValues(for record: CKRecord) -> CKRecord {
		
		record[Company.CodingKeys.name.stringValue] = self.name as CKRecordValue
		
		var roleReferences = [CKReference]()
		
		for role in self.roles {
			roleReferences.append(role.getReference())
		}
		
		record[Company.CodingKeys.roles.stringValue] = roleReferences as CKRecordValue
		
		var employeeReferences = [CKReference]()
		
		for employee in self.employees {
			employeeReferences.append(employee.getReference())
		}
		
		record[Company.CodingKeys.employees.stringValue] = employeeReferences as CKRecordValue
		
		return record
	}
	
}

//
//  CloudLayer.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 29/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import CloudKit

protocol CloudKitProtocol {
	var typeName: String { get }
	
	func getRecordId() -> CKRecordID
	func getNewRecord(from recordId: CKRecordID) -> CKRecord
	func setRecordValues(for record: CKRecord) -> CKRecord
}

extension CloudKitProtocol {
	
	func getNewRecord(from recordId: CKRecordID) -> CKRecord {
		let newRecord = CKRecord(recordType: self.typeName, recordID: recordId)
		
		return self.setRecordValues(for: newRecord)
	}
	
}

class CloudLayer {
	
	static let instance = CloudLayer()
	
	let container: CKContainer
	let publicDB: CKDatabase
	
	private init() {
		self.container = CKContainer.default()
		self.publicDB = self.container.publicCloudDatabase
	}
	
	private func createOrUpdate(_ object: CloudKitProtocol) {
		self.publicDB.fetch(withRecordID: object.getRecordId()) { record, error in
			
			if let existingRecord = record {
				self.publicDB.save(object.setRecordValues(for: existingRecord)) { record, error in
					
					if let error = error {
						print(error)
						return
					}
					
					print("Updated\n\(record!)")
				}
				
			} else {
				
				self.publicDB.save(object.getNewRecord(from: object.getRecordId())) { record, error in
					
					if let error = error {
						print(error)
						return
					}
					
					print("Saved\n\(record!)")
					
				}
				
			}
			
		}
	}
	
	private func save(_ idProvider: IdProvider) {
		self.createOrUpdate(idProvider)
	}
	
	private func save(_ employee: Employee) {
		self.createOrUpdate(employee)
	}
	
	private func save(_ role: Role) {
		self.createOrUpdate(role)
	}
	
	private func save(_ company: Company) {
		for role in company.roles {
			self.save(role)
		}
		
		for employee in company.employees {
			self.save(employee)
		}
		
		self.createOrUpdate(company)
		
	}
	
	func save(_ idProvider: IdProvider, and companies: Set<Company>) {

		self.save(idProvider)
		
//		for company in companies {
//			self.save(company)
//		}
		
		self.createOrUpdate(companies.first!)
	}
}

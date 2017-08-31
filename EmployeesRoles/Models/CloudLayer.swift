//
//  CloudLayer.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 29/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import CloudKit

protocol CloudLayerProtocol {
	var typeName: String { get }
	
	init?(_ record: CKRecord)
	
	func getRecordId() -> CKRecordID
	func getNewRecord(from recordId: CKRecordID) -> CKRecord
	func setRecordValues(for record: CKRecord) -> CKRecord
}

extension CloudLayerProtocol {
	
	func getNewRecord(from recordId: CKRecordID) -> CKRecord {
		let newRecord = CKRecord(recordType: self.typeName, recordID: recordId)
		
		return self.setRecordValues(for: newRecord)
	}
	
}

class CloudLayer {
	
	static let instance = CloudLayer()
		
	private let container: CKContainer
	private let publicDB: CKDatabase
	
	private init() {
		self.container = CKContainer.default()
		self.publicDB = self.container.publicCloudDatabase
	}
	
	// MARK: - Saving
	
	private func createOrUpdate(_ object: CloudLayerProtocol) {
		self.publicDB.fetch(withRecordID: object.getRecordId()) { [weak self] record, error in
			
			if let existingRecord = record {
				self?.publicDB.save(object.setRecordValues(for: existingRecord)) { record, error in
					
					if let error = error {
						print(error)
						return
					}
					
					print("Updated:\n\(record!)\n")
				}
				
			} else {
				
				self?.publicDB.save(object.getNewRecord(from: object.getRecordId())) { record, error in
					
					if let error = error {
						print(error)
						return
					}
					
					print("Saved:\n\(record!)\n")
					
				}
				
			}
			
		}
	}
	
//	private func save(_ idProvider: IdProvider) {
//		self.createOrUpdate(idProvider)
//	}
	
//	private func save(_ employee: Employee) {
//		self.createOrUpdate(employee)
//	}
	
//	private func save(_ role: Role) {
//		self.createOrUpdate(role)
//	}
	
	private func save(_ company: Company) {
		for role in company.roles {
			self.createOrUpdate(role)
		}
		
		for employee in company.employees {
			self.createOrUpdate(employee)
		}
		
		self.createOrUpdate(company)
		
	}
	
	func save(_ idProvider: IdProvider, and companies: Set<Company>) {

		self.createOrUpdate(idProvider)
		
		for company in companies {
			self.save(company)
		}
		
	}
	
	// MARK: - Loading
	
	private func load(_ typeName: String, with completed: @escaping ([CKRecord]?) -> Void) {
		let query = CKQuery(recordType: typeName, predicate: NSPredicate(value: true))
		
		self.publicDB.perform(query, inZoneWith: nil) { results, error in
			if let error = error {
				print(error)
				return
			}
			
			completed(results)
		}
	}
	
	func load(with completed: @escaping (IdProvider?, Set<Company>?) -> Void) {
		self.load(IdProvider.typeName) { records in
			if let idProviderRecord = records?.first {
				let idProvider = IdProvider(idProviderRecord)
				
				completed(idProvider, nil)
			} else {
				completed(nil, nil)
			}
		}
	}
}

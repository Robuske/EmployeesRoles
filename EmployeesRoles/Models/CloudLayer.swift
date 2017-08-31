//
//  CloudLayer.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 29/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import CloudKit

protocol CloudLayerRecords {
	static var typeName: String { get }
	
	//init?(_ record: CKRecord)
	
	func getRecordId() -> CKRecordID
	func getNewRecord(from recordId: CKRecordID) -> CKRecord
	func setRecordValues(for record: CKRecord) -> CKRecord
}

extension CloudLayerRecords {
	
	func getNewRecord(from recordId: CKRecordID) -> CKRecord {
		let newRecord = CKRecord(recordType: type(of: self).typeName, recordID: recordId)
		
		return self.setRecordValues(for: newRecord)
	}
	
}

protocol CloudLayerReferences {
	func getReference() -> CKReference
}

extension CloudLayerReferences where Self: CloudLayerRecords {
	func getReference() -> CKReference {
		let reference = CKReference(recordID: self.getRecordId(), action: .none)
		
		return reference
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
	
	private func createOrUpdate(_ object: CloudLayerRecords) {
		self.publicDB.fetch(withRecordID: object.getRecordId()) { [weak self] record, error in
			
			if let existingRecord = record {
				self?.publicDB.save(object.setRecordValues(for: existingRecord)) { record, error in
					
					if let error = error {
						print("Got error:\n\(error)\n")
						return
					}
					
					print("Updated:\n\(record!)\n")
				}
				
			} else {
				
				self?.publicDB.save(object.getNewRecord(from: object.getRecordId())) { record, error in
					
					if let error = error {
						print("Got error:\n\(error)\n")
						return
					}
					
					print("Saved:\n\(record!)\n")
					
				}
				
			}
			
		}
	}
	
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
	
	private func load(_ typeName: String, with predicate: NSPredicate, and completed: @escaping ([CKRecord]?) -> Void) {
		let query = CKQuery(recordType: typeName, predicate: predicate)
		
		self.publicDB.perform(query, inZoneWith: nil) { results, error in
			if let error = error {
				print("Got error:\n\(error)\n")
				completed(nil)
				return
			}
			
			print("Loaded:\n\(results!)\n")
			completed(results)
		}
	}
	
	private func load(with references: [CKReference], completed: @escaping ([CKRecord]?) -> Void) {
		var recordIDs = [CKRecordID]()
		
		
		for reference in references {
			recordIDs.append(reference.recordID)
		}
		
		let fetchAllRecords = CKFetchRecordsOperation(recordIDs: recordIDs)
		fetchAllRecords.fetchRecordsCompletionBlock = { recordDic, error in
			if let error = error {
				print("Got error:\n\(error)\n")
				completed(nil)
				return
			}
			
			if let recordDic = recordDic {
				var records = [CKRecord]()
				
				for (_, value: recordEntry) in recordDic {
					records.append(recordEntry)
				}
				
				completed(records)
			}
		}
		
	}
	
	func load(_ references: [CKReference], with completed: @escaping (Set<Employee>?, Set<Role>?) -> Void) {
		self.load(with: references) { records in
			if let records = records {
				
				var employees = Set<Employee>()
				var roles = Set<Role>()
				
				for record in records {
					if record.recordType == Employee.typeName {
						
						if let employee = Employee(record) {
							employees.insert(employee)
						}
						
					} else if record.recordType == Role.typeName {
						
						if let role = Role(record) {
							roles.insert(role)
						}
						
					}
				}
				
				completed(employees, roles)
				
			} else {
				completed(nil, nil)
			}
		}
	}
	
	func load(with completed: @escaping (IdProvider?, Set<Company>?) -> Void) {
		
		self.load(IdProvider.typeName, with: NSPredicate(value: true)) { [weak self] records in
			
			if let idProviderRecord = records?.first {
				let idProvider = IdProvider(idProviderRecord)
				
				self?.load(Company.typeName, with: NSPredicate(value: true)) { records in
					
					
					if let companiesRecords = records {
						var companies = Set<Company>()
						
						for companieRecord in companiesRecords {
							
							Company.loadCompany(companieRecord) { company in
								if let company = company {
									companies.insert(company)
								}
							}
							
						}
						
						completed(idProvider, companies)
						
						
					} else {
						
						completed(idProvider, nil)
						
					}
				}
				
			} else {
				
				completed(nil, nil)
				
			}
		}
	}
}

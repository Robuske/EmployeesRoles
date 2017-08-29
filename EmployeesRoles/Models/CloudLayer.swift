//
//  CloudLayer.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 29/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import CloudKit

class CloudLayer {
	
	static let instance = CloudLayer()
	
	let container: CKContainer
	let publicDB: CKDatabase
	
	private init() {
		self.container = CKContainer.default()
		self.publicDB = self.container.publicCloudDatabase
	}
	
	private func save(_ idProvider: IdProvider) {
		self.publicDB.save(idProvider.intoRecord()) { record, error in
			print("Saving\n\(idProvider)")
			
			if let error = error {
				print(error)
				return
			}
			
			print("Saved\n\(record!)")
		}
	}
	
	private func save(_ employee: Employee) {
		self.publicDB.save(employee.intoRecord()) { record, error in
			print("Saving\n\(employee)")
			
			if let error = error {
				print(error)
				return
			}
			
			print("Saved\n\(record!)")
		}
	}
	
	private func save(_ role: Role) {
		self.publicDB.save(role.intoRecord()) { record, error in
			print("Saving \(role)")
			
			if let error = error {
				print(error)
				return
			}
			
			print("Saved\n\(record!)")
		}
	}
	
	private func save(_ company: Company) {
		for role in company.roles {
			self.save(role)
		}
		
		for employee in company.employees {
			self.save(employee)
		}
		
		self.publicDB.fetch(withRecordID: company.getRecordId()) { record, error in
			
			self.publicDB.save(company.setRecordValues(record: record!)) { record, error in
				print("Saving\n\n\(company)")
				
				if let error = error {
					print(error)
					return
				}
				
				print("Saved\n\(record!)")
			}
			
		}
		
	}
	
	func save(_ idProvider: IdProvider, and companies: Set<Company>) {

		self.save(idProvider)
		
		for company in companies {
			self.save(company)
		}
		
	}
}

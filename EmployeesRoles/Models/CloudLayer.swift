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
			if let error = error {
				print(error)
				return
			}
			
			print("Saved \(record!)")
		}
	}
	
	private func save(_ company: Company) {
		self.publicDB.save(company.intoRecord()) { record, error in
			if let error = error {
				print(error)
				return
			}
			
			print("Saved \(record!)")
		}
	}
	
	func save(_ idProvider: IdProvider, and companies: Set<Company>) {
		self.save(idProvider)
		
		for company in companies {
			self.save(company)
		}
		
	}
}

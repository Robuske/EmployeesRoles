//
//  DataLayer.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 24/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

class DataLayer {
	static let instance = DataLayer()
	
	private let idProviderKey = "idProvider"
	private let companiesKey = "companies"
	
	private init() {}
	
	func save(_ companies: Set<Company>) -> Bool {
		let encoder = PropertyListEncoder()
		
		do {
			
			let companiesData = try encoder.encode(companies)
			let idProviderData = try encoder.encode(IdProvider.instance)
			
			UserDefaults.standard.set(companiesData, forKey: self.companiesKey)
			UserDefaults.standard.set(idProviderData, forKey: self.idProviderKey)
			
			CloudLayer.instance.save(IdProvider.instance, and: companies)
			
		} catch {
			print("Could not encode, got error:")
			print(error)
			return false
		}
		
		return true
	}
	
	func save(_ company: Company) -> Bool {
		var companies = self.loadCompanies()
		companies.update(with: company)
		
		return self.save(companies)
	}
	
	func loadCompanies() -> Set<Company> {
		let decoder = PropertyListDecoder()
		
		guard let companiesData = UserDefaults.standard.object(forKey: self.companiesKey) as? Data,
			let companies = try? decoder.decode(Set<Company>.self, from: companiesData)
			else {
				return Set<Company>()
		}
		
		return companies
	}
	
	func loadCompany() -> Company {
		if let oldCompany = self.loadCompanies().first {
			
			return oldCompany
			
		} else {
			let newCompany = Company(name: "Awesome Inc")
			
			let allCompanies = Set([newCompany])
			_ = self.save(allCompanies)
			
			return newCompany
		}
	}
	
	func loadIdProvider() -> IdProvider? {
		let decoder = PropertyListDecoder()
		
		guard let idProviderData = UserDefaults.standard.object(forKey: self.idProviderKey) as? Data,
			let idProvider = try? decoder.decode(IdProvider.self, from: idProviderData)
			else {
				return nil
		}
		
		return idProvider
	}
}

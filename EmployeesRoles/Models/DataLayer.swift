//
//  DataLayer.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 24/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

protocol DataLayerUpdate: class {
	func reloadData()
}

class DataLayer {
	static let instance = DataLayer()
	
	weak var delegate: DataLayerUpdate?
	
	private let idProviderKey = "idProvider"
	private let companiesKey = "companies"
	
	private init() {}
	
	// MARK: - Saving
	private func save(_ idProvider: IdProvider) throws {
		let encoder = PropertyListEncoder()
		
		let idProviderData = try encoder.encode(idProvider)
		
		UserDefaults.standard.set(idProviderData, forKey: self.idProviderKey)
	}
	
	private func save(_ companies: Set<Company>) -> Bool {
		
		do {
			try self.save(IdProvider.instance)
			
			let encoder = PropertyListEncoder()
			
			let companiesData = try encoder.encode(companies)
			
			UserDefaults.standard.set(companiesData, forKey: self.companiesKey)
			
			CloudLayer.instance.save(IdProvider.instance, and: companies)
			
		} catch {
			print("Could not encode, got error:\n\(error)\n")
			return false
		}
		
		return true
	}
	
	func save(_ company: Company) -> Bool {
		var companies = self.loadCompanies()
		companies.update(with: company)
		
		return self.save(companies)
	}
	
	// MARK: - Loading
	
	private func loadCompanies() -> Set<Company> {
		
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
	
	func firstLoad() {
		CloudLayer.instance.load { [weak self] idProvider, companies in
			if let idProvider = idProvider {
				IdProvider.reload(with: idProvider)
				_ = try? self?.save(IdProvider.instance)
				print("Loaded and saved IdProvider")
				
				if let companies = companies {
					_ = self?.save(companies)
					print("Loaded and saved companies")
					
					self?.delegate?.reloadData()
				}
			}
		}
		
	}
}

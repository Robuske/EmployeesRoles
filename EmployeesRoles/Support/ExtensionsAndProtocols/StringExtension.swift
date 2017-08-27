//
//  StringExtension.swift
//  EmployeesRoles
//
//  Created by Rodrigo Cardoso Buske on 26/08/17.
//  Copyright © 2017 Buske Org. All rights reserved.
//

import Foundation

extension String {
	func stripToInt() -> Int {
		let notNumbers = CharacterSet.decimalDigits.inverted
		
		let stringComponentsArray = self.components(separatedBy: notNumbers)
		let stringComponentsJoined = stringComponentsArray.joined()
		
		return Int(stringComponentsJoined) ?? 0
	}
}

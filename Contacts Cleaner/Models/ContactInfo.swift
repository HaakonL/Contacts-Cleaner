//
//  ContactInfo.swift
//  Contacts Cleaner
//
//  Created by Haakon Langaas Lageng on 23/07/2022.
//

import Foundation

struct ContactInfo: Identifiable {
	let id = UUID()
	let identifier: String
	let firstName: String
	let lastName: String
}

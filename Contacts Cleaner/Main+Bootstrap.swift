//
//  Cleaner+Bootstrap.swift
//  Contacts Cleaner
//
//  Created by Haakon Langaas Lageng on 15/08/2022.
//

import Resolver

extension Resolver: ResolverRegistering {
	public static func registerAllServices() {
		register { ContactsViewModel() }
	}
}

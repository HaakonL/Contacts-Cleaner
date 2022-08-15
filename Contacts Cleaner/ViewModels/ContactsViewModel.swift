//
//  ContentViewModel.swift
//  Contacts Cleaner
//
//  Created by Haakon Langaas Lageng on 23/07/2022.
//

import Foundation
import Contacts

class ContactsViewModel: ObservableObject {
	
	private let keys: [CNKeyDescriptor] = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
	
	@Published var contacts: [ContactInfo]?
	
	func deleteContact(with identifier: String) {
		do {
			let index = contacts?.firstIndex(where: { $0.identifier == identifier })
			if let index = index {
				let store = CNContactStore()
				let contact = try store.unifiedContact(withIdentifier: identifier, keysToFetch: keys)
				if let mutableContact = contact.mutableCopy() as? CNMutableContact {
					let request = CNSaveRequest()
					request.delete(mutableContact)
					try store.execute(request)
					contacts?.remove(at: index)
				}
			} else {
				print("No mutable contact found for \(identifier)")
			}
		} catch let error {
			print("Unable to delete", error)
		}
	}
	
	func requestAccessAndFetchContacts() {
		let store = CNContactStore()
		switch CNContactStore.authorizationStatus(for: .contacts) {
			case .authorized:
				self.getContacts()
			case .denied:
				store.requestAccess(for: .contacts) { granted, error in
					if granted {
						self.getContacts()
					}
				}
			case .restricted, .notDetermined:
				store.requestAccess(for: .contacts) { granted, error in
					if granted {
						self.getContacts()
					}
				}
			@unknown default:
				print("error")
		}
	}
	
	private func getContacts() {
		DispatchQueue.main.async {
			self.contacts = self.fetch()
		}
	}
	
	private func fetch() -> [ContactInfo] {
		var contacts = [ContactInfo]()
		let request = CNContactFetchRequest(keysToFetch: keys)
		
		do {
			try CNContactStore().enumerateContacts(with: request, usingBlock: { contact, stopPointer in
				contacts.append(ContactInfo(identifier: contact.identifier, firstName: contact.givenName, lastName: contact.familyName))
			})
		} catch let error {
			print("failed", error)
		}
		
		contacts = contacts.sorted {
			$0.firstName < $1.firstName
		}
		return contacts
	}
}

//
//  ContentView.swift
//  Contacts Cleaner
//
//  Created by Haakon Langaas Lageng on 23/07/2022.
//

import SwiftUI

struct ContactsView: View {
	@StateObject private var vm = ContactsViewModel()
	@State private var buttonColor = Color.red
	
	var body: some View {
		VStack {
			Text("Your contacts")
				.font(.title)
				.padding(.bottom, 1)
			
			Text("Warning! Tapping \"Delete\" on a row will immediately and irreversably remove the contact.")
				.font(.caption)
				.italic()
				.multilineTextAlignment(.center)
				.padding(0)
				.padding(.bottom, 10)
			
			ScrollView {
				if self.vm.contacts != nil {
					ForEach(self.vm.contacts!) { contact in
						HStack {
							Group {
								Text("\(contact.firstName) ") + Text(contact.lastName).bold()
							}
							.lineLimit(1)
							
							Spacer()
							
							Button {
								vm.deleteContact(with: contact.identifier)
							} label: {
								Text("Delete")
							}
							.buttonStyle(.bordered)
							.accentColor(.red)
							.padding(.trailing, 10)
						}
						
						Divider()
					}
				} else {
					Spacer()
					
					VStack(spacing: 10) {
						Text("Loading contacts")
						ProgressView()
					}
					
					Spacer()
				}
			}
		}
		.padding()
		.onAppear {
			vm.requestAccessAndFetchContacts()
		}
	}
}

struct ContactsPreviews: PreviewProvider {
	static var previews: some View {
		ContactsView()
	}
}

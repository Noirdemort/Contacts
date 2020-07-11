////
////  ContactDetailViewController.swift
////  Contacts
////
////  Created by Noirdemort on 02/06/20.
////  Copyright © 2020 Noirdemort. All rights reserved.
////
//
//import Cocoa
//
//protocol ContactDeleteDelegate: class {
//	func deleteContact(contact: Contact)
//}
//
//
//class ContactDetailViewController: NSViewController, ContactSelectionDelegate {
//
//	
//	var contact: Contact?
//	
//    override func viewDidLoad() {
//        super.viewDidLoad()
//		
//		ContactListViewController.displayDelegate = self
//		self.number.isEditable = false
//		
//		
//        // Do view setup here.
//    }
//	
//	static weak var deleteDelegate: ContactDeleteDelegate?
//	static weak var editDelegate: ContactModificationDelegate?
//
//	@IBOutlet weak var name: NSTextField!
//	
//	@IBOutlet weak var nickname: NSTextField!
//	
//	@IBOutlet weak var number: NSTextField!
//	
//	@IBOutlet weak var email: NSTextField!
//	
//	@IBOutlet weak var address: NSTextField!
//	
//	@IBOutlet weak var job: NSTextField!
//	
//	@IBOutlet weak var notes: NSTextField!
//	
//	
//	@IBAction func editContact(_ sender: Any) {
//		if name.stringValue.isEmpty {
//			name.backgroundColor = .systemRed
//					name.placeholderString = "Name is required"
//			return
//		}
//		
//		let contact = Contact(name: name.stringValue,
//								nickname: nickname.stringValue,
//								number: number.stringValue,
//								email: email.stringValue,
//								job: job.stringValue,
//								address: address.stringValue,
//								notes: notes.stringValue)
//		
//		ContactDetailViewController.editDelegate?.modifiedContact(contact: contact, isNewContact: false)
//	}
//	
//	
//	@IBAction func exportContact(_ sender: Any) {
//		let panel = NSSavePanel()
//		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//			let result = panel.runModal()
//			if result == .OK {
//				let encoder = JSONEncoder()
//				encoder.dataEncodingStrategy = .deferredToData
//				if let contact = self.contact {
//					let data = try? encoder.encode(contact)
//					try? data?.write(to: panel.url!)
//				}
//					
//			}
//		}
//		
//	}
//	
//	
//	@IBAction func deleteContact(_ sender: Any) {
//		if let contact = self.contact {
//			ContactDetailViewController.deleteDelegate?.deleteContact(contact: contact)
//		}
//	}
//	
//	func showContact(contact: Contact) {
//		self.contact = contact
//		self.setContact(contact: contact)
//	}
//	
//	
//	func setContact(contact: Contact){
//		self.name.stringValue = contact.name
//		self.nickname.stringValue = contact.nickname
//		self.number.stringValue = contact.number
//		self.email.stringValue = contact.email
//		self.address.stringValue = contact.address
//		self.job.stringValue  = contact.job
//		self.notes.stringValue = contact.notes
//	}
//	
//}

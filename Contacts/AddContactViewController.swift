//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Noirdemort on 07/06/20.
//  Copyright © 2020 Noirdemort. All rights reserved.
//

import Cocoa


class AddContactViewController: NSViewController {
	
	
	weak var addContactDelegate: ContactModificationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
	
	
	@IBOutlet weak var name: NSTextField!
		
	@IBOutlet weak var nickname: NSTextField!
	
	@IBOutlet weak var number: NSTextField!
		
	@IBOutlet weak var email: NSTextField!
	
	@IBOutlet weak var address: NSTextField!
	
	@IBOutlet weak var job: NSTextField!
	
	@IBOutlet weak var notes: NSTextField!
	
	
	
	@IBAction func addContact(_ sender: Any) {
		if name.stringValue.isEmpty {
			name.backgroundColor = .systemRed
			name.placeholderString = "Name is required"
			return
		}
		
		if number.stringValue.isEmpty {
			number.backgroundColor = .systemRed
			number.placeholderString = "Phone number is required"
			return
		}
		
		let contact = Contact(name: name.stringValue,
							  nickname: nickname.stringValue,
							  number: number.stringValue,
							  email: email.stringValue,
							  job: job.stringValue,
							  address: address.stringValue,
							  notes: notes.stringValue)
		
		self.addContactDelegate?.modifiedContact(contact: contact, isNewContact: true)

		self.dismiss(nil)
	}
	
	
}

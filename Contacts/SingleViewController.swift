//
//  ViewController.swift
//  Contacts
//
//  Created by Noirdemort on 02/06/20.
//  Copyright © 2020 Noirdemort. All rights reserved.
//

import Cocoa


protocol ContactModificationDelegate: class {
	func modifiedContact(contact: Contact, isNewContact : Bool)
}



class SingleViewController: NSViewController {
	
	
	var selectedContact: Contact? {
		willSet {
			self.name.stringValue = newValue?.name as! String
			self.phone.stringValue = newValue?.number as! String
		}
	}
		
	@IBOutlet weak var name: NSTextField!
	
	@IBOutlet weak var phone: NSTextField!
	
	@IBOutlet weak var nickname: NSTextField!
	
	@IBOutlet weak var email: NSTextField!
	
	@IBOutlet weak var address: NSTextField!
		
	@IBOutlet weak var job: NSTextField!
	
	@IBOutlet weak var notes: NSTextField!
	
	@IBOutlet weak var tableColumn: NSTableColumn!
	
	
	@IBOutlet weak var contactSourceView: NSOutlineView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		tableColumn.tableView?.delegate = self
		tableColumn.tableView?.dataSource = self
		contactSourceView.delegate = self
		contactSourceView.dataSource = self
		phone.formatter = nil
		loadData()
	}
	
	func loadData(){
		let filePath = "\(FileManager.default.homeDirectoryForCurrentUser.relativeString)contacts.json"

		DispatchQueue.global(qos: .userInteractive).async {
			guard let text = try? String(contentsOf: URL(string: filePath)!) else {
				print("No stored Data")
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dataDecodingStrategy = .deferredToData
			
			let contacts = try? decoder.decode([Contact].self, from: text.data(using: .utf8)!)
			CONTACTS = contacts ?? []
			DispatchQueue.main.async {
				self.tableColumn.tableView?.reloadData()
				self.contactSourceView.reloadData()
			}
		}
	}
	
	
	@IBAction func deleteCurrentContact(_ sender: Any){

		
		guard let contact = self.selectedContact else { return }
		CONTACTS.removeAll(where: { $0 == contact })
		self.tableColumn.tableView?.reloadData()
		
	}
	
	
	@IBAction func saveCurrentContact(_ sender: Any){
		
		guard let oldContact = self.selectedContact else { return }
		
		if self.name.stringValue.isEmpty {
			name.backgroundColor = .systemRed
			name.placeholderString = "Name is required"
			return
		}
			
		let contact = Contact(name: self.name.stringValue,
							  nickname: nickname.stringValue,
							  number: oldContact.number,
							  email: email.stringValue,
							  job: job.stringValue,
							  address: address.stringValue,
							  notes: notes.stringValue)
			
		self.modifiedContact(contact: contact, isNewContact: false)
	}
	
	
	@IBAction func addContact(_ sender: Any) {
		self.performSegue(withIdentifier: "showAddContact", sender: nil)
	}
	
	
	@IBAction func exportContact(_ sender: Any) {
		guard let contact = self.selectedContact else { return }
		
		let panel = NSSavePanel()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			let result = panel.runModal()
			if result == .OK {
				let encoder = JSONEncoder()
				encoder.dataEncodingStrategy = .deferredToData
				let data = try? encoder.encode(contact)
				try? data?.write(to: panel.url!)
					
			}
		}
		
	}
	
	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		let destination = segue.destinationController as! AddContactViewController
		destination.addContactDelegate = self
	}
	

}

extension SingleViewController: ContactModificationDelegate {
	
	func modifiedContact(contact: Contact, isNewContact: Bool) {
		
		if isNewContact {
			CONTACTS.append(contact)
		} else {
			if let modifiedContact = CONTACTS.firstIndex(where: { $0.number == contact.number }) {
				CONTACTS[modifiedContact] = contact
			}
		}
		
		self.tableColumn.tableView?.reloadData()
		
	}
	
}


extension SingleViewController: NSTableViewDelegate {

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ContactCell"), owner: nil) as! ContactListCell
		cell.textField?.stringValue = CONTACTS[row].name
		return cell
	}

}


extension SingleViewController: NSTableViewDataSource {

	func numberOfRows(in tableView: NSTableView) -> Int {
		return CONTACTS.count
	}

	func tableViewSelectionDidChange(_ notification: Notification) {
		guard let row = self.tableColumn.tableView?.selectedRow else { return }
		self.selectedContact = CONTACTS[row]
	}


}


extension SingleViewController: NSOutlineViewDelegate {
  
	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		guard let contact = item as? Contact else { return nil }
		
		let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ContactCell"), owner: self) as? ContactListCell
		cell?.textField?.stringValue = contact.name
		cell?.textField?.sizeToFit()
	  	return cell
	}
	
	func outlineViewSelectionDidChange(_ notification: Notification) {
	  	
	  	guard let outlineView = notification.object as? NSOutlineView else {
			return
	  	}
		self.selectedContact = CONTACTS[outlineView.selectedRow]
	}
}

extension SingleViewController: NSOutlineViewDataSource {
  
	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		return CONTACTS.count
	}
	
	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		return false
	}
	
	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
	  	return CONTACTS[index]
	}
	
}

class ContactListCell: NSTableCellView {
	
}

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


enum ExportFormats: String {

	case json = "json"
	case vCard = "vCard"
	
	static func all() -> [String]{
		return [json.rawValue, vCard.rawValue]
	}
	
}





class SingleViewController: NSViewController {
	
	var vCard: (_ name: String, _ phone: String)->String = { (name, phone) in
		return """
		BEGIN:VCARD
		VERSION:2.1
		FN: \(name)
		TEL;HOME;VOICE:\(phone)
		END:VCARD\n
		"""
	}
	
	var selectedExportFormat = ExportFormats.json.rawValue
	
	var selectedContact: Contact? {
		willSet {
			guard let newContact = newValue else { return }
			self.name.stringValue = newContact.name
			self.phone.stringValue = newContact.number
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
	
	@IBOutlet weak var exportFormat: NSPopUpButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		
		tableColumn.tableView?.delegate = self
		tableColumn.tableView?.dataSource = self
		contactSourceView.delegate = self
		contactSourceView.dataSource = self
		phone.formatter = nil
		
		exportFormat.removeAllItems()
		exportFormat.addItems(withTitles: ExportFormats.all())
		exportFormat.selectItem(at: 0)
		
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
	
	
	
	@IBAction func changeExportFormat(_ sender: Any) {
		self.selectedExportFormat = ExportFormats.all()[self.exportFormat.indexOfSelectedItem]
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
		let fileExtension = self.selectedExportFormat == ExportFormats.json.rawValue ? "json" : "vcf"
		
		panel.title = "Save As \(self.selectedExportFormat)"
		panel.nameFieldStringValue = "\(contact.name).\(fileExtension)"
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			
			let result = panel.runModal()
			
			if result != .OK {
				return
			}
			
			if self.selectedExportFormat == ExportFormats.json.rawValue {
				let encoder = JSONEncoder()
				encoder.dataEncodingStrategy = .deferredToData
				let data = try? encoder.encode(contact)
				try? data?.write(to: panel.url!)
				return
			}
			
			try? self.vCard(contact.name, contact.number).data(using: .utf8)?.write(to: panel.url!)
			
		}
		
	}
	
	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		let destination = segue.destinationController as! AddContactViewController
		destination.addContactDelegate = self
	}
	

}


// MARK:- ContactModificationDelegate

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


// MARK:- TABLEVIEW Delegate

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

// MARK:- OUTLINE Delegate

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

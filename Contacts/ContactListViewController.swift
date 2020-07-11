////
////  ContactListViewController.swift
////  Contacts
////
////  Created by Noirdemort on 02/06/20.
////  Copyright © 2020 Noirdemort. All rights reserved.
////
//
//import Cocoa
//
//protocol ContactSelectionDelegate: class {
//	func showContact(contact: Contact)
//}
//
//
//class ContactListViewController: NSViewController {
//	
//	@IBOutlet weak var tableView: NSTableView!
//	
//	var contact: Contact?
//	
//	static weak var displayDelegate: ContactSelectionDelegate?
//	
//	
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do view setup here.
//		
//		AddContactViewController.addContactDelegate = self
//		ContactDetailViewController.deleteDelegate = self
//		ContactDetailViewController.editDelegate = self
//		
//		
//		tableView.delegate = self
//		tableView.dataSource = self
//    }
//	
//	
//	@IBAction func addContact(_ sender: Any) {
//		self.performSegue(withIdentifier: "addContact", sender: nil)
//	}
//	
//    
//}
//
//extension ContactListViewController:NSTableViewDelegate {
//	
//	func numberOfRows(in tableView: NSTableView) -> Int {
//		return CONTACTS.count
//	}
//	
//	func tableViewSelectionDidChange(_ notification: Notification) {
//		print(tableView.selectedRow)
//		ContactListViewController.displayDelegate?.showContact(contact: CONTACTS[tableView.selectedRow%CONTACTS.count])
//	}
//	
//}
//
//extension ContactListViewController: NSTableViewDataSource {
//	
//	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//		let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "contactCell"), owner: nil) as! ContactListTableCell
//		cell.textField?.stringValue = CONTACTS[row].name
//		return cell
//	}
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
//}
//
//
//extension ContactListViewController: ContactModificationDelegate, ContactDeleteDelegate {
//	
//	func modifiedContact(contact: Contact, isNewContact: Bool) {
//		
//		if isNewContact {
//			CONTACTS.append(contact)
//			self.tableView.reloadData()
//			return
//		}
//		
//		if let modifiedContact = CONTACTS.firstIndex(where: { $0.number == contact.number }) {
//			CONTACTS[modifiedContact] = contact
//		}
//		
//		self.tableView.reloadData()
//		
//	}
//	
//	func deleteContact(contact: Contact) {
//		CONTACTS.removeAll(where: { $0 == contact })
//		self.tableView.reloadData()
//	}
//	
//	
//}
//
//
//class ContactListTableCell: NSTableCellView {
//	
//	
//	
//}

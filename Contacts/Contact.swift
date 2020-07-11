//
//  Contact.swift
//  Contacts
//
//  Created by Noirdemort on 02/06/20.
//  Copyright © 2020 Noirdemort. All rights reserved.
//

import Foundation



struct Contact: Codable, Hashable, Equatable {
	
	var name: String
	var nickname: String = ""
	var number: String
	var email: String = ""
	var job: String = ""
	var address: String = ""
	var notes: String = ""
	
}


var CONTACTS: [Contact] = []

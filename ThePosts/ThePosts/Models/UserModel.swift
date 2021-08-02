//
//  UserModel.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 31/07/21.
//

import Foundation

struct UserModel : Codable{
	var id : Int
	var name : String
	var username : String
	var email : String
	var address : Address
	var phone : String
	var website : String
	var company : Company
	
}


struct Address : Codable {
	var street : String
	var suite : String
	var city : String
	var zipcode : String
	var geo : Geo
}

struct Company : Codable {
	var name : String
	var catchPhrase : String
	var bs : String
}

struct Geo : Codable{
	var lat : String
	var lng : String
	
}

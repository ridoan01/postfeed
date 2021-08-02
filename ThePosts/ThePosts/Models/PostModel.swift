//
//  Posts.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 31/07/21.
//

import Foundation

struct PostModel: Codable, Hashable {
	var userId : Int
	var id : Int
	var title : String
	var body : String
	
}

//
//  CommentModel.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 31/07/21.
//

import Foundation
struct CommentModel : Decodable, Hashable {
	var postId : Int
	var id : Int
	var name : String
	var email : String
	var body : String
}

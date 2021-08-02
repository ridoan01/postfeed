//
//  PhotoModel.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 31/07/21.
//

import Foundation

struct PhotoModel : Codable, Hashable {
	var albumId : Int
	var id : Int
	var title : String
	var url : String
	var thumbnailUrl : String 
}

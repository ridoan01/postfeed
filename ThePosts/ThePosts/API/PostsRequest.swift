//
//  PostsRequest.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 31/07/21.
//

import Foundation



enum APIError : Error {
	case noDataAvailable
	case canNotProcessData
}

struct PostsRequest {
	let resourceURL : URL
	
	init() {
		
		let resourceString = "https://jsonplaceholder.typicode.com/posts"
		guard let resourceURL = URL(string: resourceString) else {
			fatalError()
		}
		self.resourceURL = resourceURL
	}
	
	func getPosts(completion: @escaping (Result<[PostModel], APIError>) -> Void) {
		
		let task = URLSession.shared.dataTask(with: resourceURL){ data, response, error in
			guard let jsonData = data else{
				completion(.failure(.noDataAvailable))
				return
			}
			
			if error != nil || data == nil {
				print("Client Error")
				return
			}
	
			guard let response = response as? HTTPURLResponse, (200...299).contains( response.statusCode)
			else { print("Server Error")
				return
			}
			
			guard let mime = response.mimeType, mime == "application/json" else{
				print("Wrong MIME type")
				return
			}
			
			do{
				let decoder = JSONDecoder()
				let postsResp = try decoder.decode([PostModel].self, from: jsonData)
				completion(.success(postsResp))
			}catch{
				completion(.failure(.canNotProcessData))
			}
		}
		task.resume()
		
	}
}

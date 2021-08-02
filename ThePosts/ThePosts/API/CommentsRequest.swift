//
//  CommentRequest.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 31/07/21.
//

import Foundation

struct CommentsRequest {
	let resourceURL : URL
	
	init(postId : Int) {
		
		let resourceString = "https://jsonplaceholder.typicode.com/comments?postId=\(postId)"
		guard let resourceURL = URL(string: resourceString) else {
			fatalError()
		}
		self.resourceURL = resourceURL
	}
	
	func getComments(completion: @escaping (Result<[CommentModel], APIError>) -> Void) {
		
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
				let commResp = try decoder.decode([CommentModel].self, from: jsonData)
				completion(.success(commResp))
			}catch{
				completion(.failure(.canNotProcessData))
			}
		}
		task.resume()
	
	}
}


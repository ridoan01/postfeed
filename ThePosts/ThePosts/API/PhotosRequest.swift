//
//  PhotosRequest.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 01/08/21.
//

import Foundation
struct PhotosRequest {
	let resourceURL : URL
	
	init(albumId : Int) {
		
		let resourceString = "https://jsonplaceholder.typicode.com/albums/\(albumId)/photos"
		guard let resourceURL = URL(string: resourceString) else {
			fatalError()
		}
		self.resourceURL = resourceURL
	}
	
	func getPhotos(completion: @escaping (Result<[PhotoModel], APIError>) -> Void) {
		
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
				let phResp = try decoder.decode([PhotoModel].self, from: jsonData)
				completion(.success(phResp))
			}catch{
				print("JSON Photo Error \(error.localizedDescription)")
				completion(.failure(.canNotProcessData))
			}
		}
		task.resume()
		
	}
}

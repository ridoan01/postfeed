//
//  AlbumRequest.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 01/08/21.
//

import Foundation
struct AlbumsRequest {
	let resourceURL : URL
	
	init(userId : Int) {
		
		let resourceString = "https://jsonplaceholder.typicode.com/users/\(userId)/albums"
		guard let resourceURL = URL(string: resourceString) else {
			fatalError()
		}
		self.resourceURL = resourceURL
	}
	
	func getAlbums(completion: @escaping (Result<[AlbumModel], APIError>) -> Void) {
		
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
				let albumsResp = try decoder.decode([AlbumModel].self, from: jsonData)
				completion(.success(albumsResp))
			}catch{
				print("JSON Album Error : \(error.localizedDescription)")
				completion(.failure(.canNotProcessData))
			}
		}
		task.resume()
		
	}
}

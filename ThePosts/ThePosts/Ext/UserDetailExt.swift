//
//  UserDetailExt.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 01/08/21.
//

import Foundation
import UIKit

typealias DidSelectClosure = ((_ tableIndex: Int?, _ collectionIndex: Int?) -> Void)


extension UserDetailViewController : UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return albums.count
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
			cell.username_lbl.text = user[indexPath.row].name
			cell.email_lbl.text = user[indexPath.row].email
			cell.address_lbl.text = "Street : \(user[indexPath.row].address.street)\nSuite : \(user[indexPath.row].address.suite)\nCity : \(user[indexPath.row].address.city)\nZip Code : \(user[indexPath.row].address.zipcode)"
			cell.company_lbl.text = "Name : \(user[indexPath.row].company.name)\nCatch Phrase : \(user[indexPath.row].company.catchPhrase)\nBS : \(user[indexPath.row].company.bs)"
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumCell
			
			cell.title_lbl.text = albums[indexPath.row].title
			cell.photos = photos[indexPath.row]
			cell.index = indexPath.row
			cell.didSelectClosure = { tabIndex, colIndex in
				if let tabIndexp = tabIndex, let celIndexp = colIndex {
					self.moveOnPhotoDetails(tindex: tabIndexp, cindex: celIndexp)
				}
			}
			
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return ""
		}else{
			return "Albums"
		}
	}
	
}

extension AlbumCell : UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else{
			return UICollectionViewCell()
		}
		cell.albumImgs.load(url: URL(string: photos?[indexPath.row].thumbnailUrl ?? "")!)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		didSelectClosure?(index!, indexPath.row)
	}
	
}

class UserCell: UITableViewCell {
	@IBOutlet weak var username_lbl : UILabel!
	@IBOutlet weak var email_lbl : UILabel!
	@IBOutlet weak var address_lbl : UILabel!
	@IBOutlet weak var company_lbl : UILabel!
	
}

class AlbumCell : UITableViewCell{
	@IBOutlet weak var title_lbl : UILabel!
	@IBOutlet weak var photosCell: UICollectionView!
	
	
	var index : Int?
	var didSelectClosure : DidSelectClosure?
	
	var photos : [PhotoModel]?{
		didSet{
			photosCell.reloadData()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		photosCell.delegate = self
		photosCell.dataSource = self
	}
}

class PhotoCell : UICollectionViewCell{
	@IBOutlet weak var albumImgs: UIImageView!
	
	
}

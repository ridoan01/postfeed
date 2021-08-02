//
//  PostDetailViewController.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 31/07/21.
//

import UIKit

class PostDetailViewController: UIViewController {
	
	@IBOutlet weak var comment_tbl : UITableView!
	var user = [UserModel]()
	var post = [PostModel]()
	var comments = [CommentModel](){
		didSet{
			DispatchQueue.main.async {
				self.comment_tbl.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		comment_tbl.dataSource = self
		comment_tbl.delegate = self
		comment_tbl.rowHeight = UITableView.automaticDimension
		comment_tbl.estimatedRowHeight = 300
		
		fetchComments()
	}
	
	@IBAction func toDetail(_ sender: Any) {
		performSegue(withIdentifier: "userDetail", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "userDetail" {
			let viewController = segue.destination as! UserDetailViewController
			viewController.user = user
			
		}
	}
	
	func fetchComments(){
		let comm = CommentsRequest.init(postId: post[0].id)
		comm.getComments(){ result in
			switch result{
			case .failure(let error) :
				print(error.localizedDescription)
			case .success(let comments):
				self.comments = comments
			}
		}
		
	}
	
}


extension PostDetailViewController : UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return comments.count
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath as IndexPath) as! ContentCell
			
			cell.title_lbl.text = post[0].title
			cell.body_lbl.text = post[0].body
			cell.username_btn.setTitle(user[0].name, for: .normal)
			cell.company_lbl.text = user[0].company.name
			
			return cell
		}
		else{
		let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath  as IndexPath) as! CommentsTableViewCell
		
		cell.body_lbl.text = comments[indexPath.row].body
		cell.author_lbl.text = comments[indexPath.row].name
		
		return cell
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return ""
		}else{
			return "Comments"
		}
	}
	
}

class ContentCell: UITableViewCell {
	@IBOutlet weak var title_lbl: UILabel!
	@IBOutlet weak var body_lbl: UILabel!
	@IBOutlet weak var username_btn: UIButton!
	@IBOutlet weak var company_lbl: UILabel!
}


class CommentsTableViewCell : UITableViewCell{
	@IBOutlet weak var body_lbl : UILabel!
	@IBOutlet weak var author_lbl  : UILabel!
}

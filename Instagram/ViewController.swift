//
//  ViewController.swift
//  Instagram
//
//  Created by zhong zheng on 2/4/21.
//  Copyright © 2021 ZHONG ZHENG. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    
    var numOfPosts: Int = 3
    let myRefreshControl = UIRefreshControl()
    let commentBar = MessageInputBar()
    var showCommentBar = false
    var selectedPost: PFObject!
    @IBOutlet weak var tableView: UITableView!
     var posts: [PFObject] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .interactive
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        myRefreshControl.addTarget(self, action: #selector(loadPost), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        tableView.dataSource = self
        tableView.delegate = self
        loadPost()
    
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
             super.viewDidAppear(animated)
             loadPost()
         }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showCommentBar
    }
    
    @objc func loadPost(){
           let query = PFQuery(className: "MyPosts")
           query.includeKeys(["author","comments","comments.author"])
           query.limit = 3
           
           query.findObjectsInBackground { (posts, error) in
               if posts != nil {
                   self.posts = posts!
                   self.tableView.reloadData()
               }
           }
           
           
       }
    
  
    
    @IBAction func signOut(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
            
        let loginController = main.instantiateViewController(withIdentifier: "loginController")
        let delegate = self.view.window!.windowScene!.delegate as! SceneDelegate
            
        delegate.window?.rootViewController = loginController
        
        
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        // create comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!
        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { (success, error) in
            if success{
                print("Comment saved")
            }else{
                print("Error saving comment", error?.localizedDescription)
            }
        }
        tableView.reloadData()
        
        // dismiss commentbar
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    func loadMorePost() {
        let query = PFQuery(className: "MyPosts")
        query.includeKeys(["author","comments","comments.author"])
        numOfPosts += 3
        query.limit = numOfPosts
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2
        
       }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == posts.count{
//                    loadMorePost()
//                }
//    }
    

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let post = posts[indexPath.section]
      let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == 0 {
              let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
              let post = posts[indexPath.row]
              let user = post["author"] as! PFUser
              cell.nameLabel.text = user.username
              cell.captionField.text = post["caption"] as! String
              let imageFile = post["image"] as! PFFileObject
              let urlString = imageFile.url!
              let url = URL(string: urlString)
        //    print(post.updatedAt)
              cell.postImage!.af_setImage(withURL: url!)
              return cell
        } else if (indexPath.row <= comments.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]
            let user = comment["author"] as! PFUser
            cell.name.text! = user.username as! String
            cell.content.text! = comment["text"] as! String
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewComment")!
            return cell
    }
    
      

   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
        }
        
    
        
    }
    
}


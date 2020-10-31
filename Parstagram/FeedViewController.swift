//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Priyanka Balwadkar on 10/24/20.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var user = PFUser()
    var posts = [PFObject]()
    let myRefreshControl = UIRefreshControl()
    var numberOfPosts: Int!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        numberOfPosts = 10
        tableView.delegate = self
        tableView.dataSource = self
        
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        
        commentBar.delegate = self
        tableView.keyboardDismissMode = .interactive
        let center  = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        loadPosts()
        
        myRefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        tableView.refreshControl = myRefreshControl
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //create the comment
        
        
        // dismiss
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
        
    }
    
    
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        
    }
    
    
    func loadPosts()
    {
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author","comments","comments.author"])
        
        query.limit = 10
        
        query.findObjectsInBackground {(posts, error) in
        if posts != nil {
         
            self.posts = posts!
            self.tableView.reloadData()
               
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
        //self.tableView.reloadData()
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        //let user = posts[0]["author"] as PFUser!
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = loginViewController
        //self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            user = post["author"] as! PFUser

            cell.usernameLabel.text = user.username
            cell.captionLabel.text = post["caption"] as? String

            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!

            cell.postView.af_setImage(withURL: url)

            return cell
        }
        else if indexPath.row <= comments.count
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row-1]
            cell.commentLabel.text = comment["text"] as! String
            let user = comment["author"] as! PFUser
            cell.userLabel.text = user.username
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
        
    }
    
    
    
    @objc func onRefresh()
    {
            loadPosts()
            self.myRefreshControl.endRefreshing()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == posts.count{
            loadMorePosts()
        }
    }
    
    
    func loadMorePosts(){
        
        numberOfPosts = numberOfPosts + 10
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author","comments", "comments.author"])
        query.limit = numberOfPosts
    
        query.findObjectsInBackground {(posts, error) in
            if posts != nil {
                
                self.posts.removeAll()
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comments = post["comments"] as? [PFObject] ?? []
        
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            
            commentBar.inputTextView.becomeFirstResponder()
        }
        
       /*
        comment["text"] = "This is a random comment"
        comment["post"] = post
        comment["author"] = PFUser.current()!
        
        
        post.add(comment, forKey: "comments")
        post.saveInBackground{(success, error) in
            if success {
                print("Comment saved")
                
            }
            else{
                print("Error in saving the comment")
                
            }
            
        } */
    }
    
    
    override var inputAccessoryView: UIView?{
        return commentBar
        
    }
    override var canBecomeFirstResponder: Bool{
        return showsCommentBar
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

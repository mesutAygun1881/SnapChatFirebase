//
//  FeedVC.swift
//  SnapChatFirebase
//
//  Created by mesutAygun on 29.03.2021.
//

import UIKit
import Firebase

class FeedVC: UIViewController  , UITableViewDelegate , UITableViewDataSource {
    
    var snapArray = [Snap]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) as! FeedCell
        cell.feedUsernameLabel.text = snapArray[indexPath.row].username
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    let fireStoreDatabase = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        getUserInfo()
     getSnapsFromfirebase()
    }
      func  getSnapsFromfirebase(){
        
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue() , to : Date()).hour {
                                        self.fireStoreDatabase.collection("Snaps").document(documentId).delete()  { (error) in
                                            
                                            
                                        }
                                    }
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                }
                            }
                        }
                    }
                }
            }
        }
            
        }
    
    
    func getUserInfo() {
        
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email!).getDocuments { (snapshot, error) in
            if error != nil {
                self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents  {
                     if let username = document.get("username")   as? String {
                        UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                        UserSingleton.sharedUserInfo.username = username
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    func makeAlert (titleInput : String , messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }



}

//
//  ViewController.swift
//  Events
//
//  Created by Christopher Walter on 10/5/21.
//

import UIKit
import Firebase
import simd


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    
    var events: [String] = [String]()
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        createFirestoreListener()
        
    }

    @IBAction func addEvent(_ sender: UIBarButtonItem)
    {
        let db = Firestore.firestore()
        let date = Double(Date().timeIntervalSince1970)
        let name = "Test"
        let data = ["name": name, "created": date] as [String : Any]
        db.collection("Events").addDocument(data: data) {
            err in
            if let error = err {
                print("Error adding document: \(error)")
            }
        }
        
    }
    
    func createFirestoreListener()
    {
        let db = Firestore.firestore()
        db.collection("Events").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else { print("Error fetching document: \(error!)")
                return
            }
            self.events.removeAll()
            let documentData = document.documents
            
            for item in documentData
            {
                let data = item.data()
                let created = data["created"] as? Double ?? Double(Date().timeIntervalSince1970)
                let name = data["name"] as? String ?? "Hello"
                
                let date = Date(timeIntervalSince1970: created)
                self.events.append("\(name): \(date)")
                
                
            }

            self.myTableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let event = events[indexPath.row]
        cell.textLabel?.text = event
        
        return cell
    }
    
}


//
//  TodoListTableViewController.swift
//  Coredata_Course
//
//  Created by Ravikumar on 6/27/21.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    
    let itemArray = ["Find Mike","Buy Eggos","Destroy Demorgo"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoList", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    

}

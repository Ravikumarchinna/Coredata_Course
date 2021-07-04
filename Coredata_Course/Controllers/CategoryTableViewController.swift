//
//  CategoryTableViewController.swift
//  Coredata_Course
//
//  Created by Ravikumar on 7/3/21.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    
    var catArray = [CatIten]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem()
        

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = catArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "loadItems", sender: self)
//        context.delete(catArray[indexPath.row])
//        saveItems()
//        loadItem()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! TodoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
    }
    
    
    
    @IBAction func AddbarbittonPressed(_ sender: Any) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let catItem = CatIten(context: self.context)
            catItem.name = textfield.text
            self.catArray.append(catItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Item"
            textfield = alertTextfield
        }
        alert.addAction(action)
        self.present(alert, animated: true) {
        }
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch  {
            print("Error saveing context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItem() {
        let request:NSFetchRequest<CatIten> = CatIten.fetchRequest()
        do {
         catArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context ..\(error)")
        }
        self.tableView.reloadData()
    }
    
    
    
}

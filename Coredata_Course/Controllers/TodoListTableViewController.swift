//
//  TodoListTableViewController.swift
//  Coredata_Course
//
//  Created by Ravikumar on 6/27/21.
//

import UIKit
import CoreData



class TodoListTableViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory:CatIten? {
        didSet{
            loadItems()
        }
    }
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        self.loadItems()
        
    }

    @IBAction func addItemPressed(_ sender: Any) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textfield.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
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
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context ..\(error)")
        }
        self.tableView.reloadData()
    }
    
    
//    func loadItem() {
//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//        //................. Relation ship items predicate
//        let prediacte = NSPredicate(format: "parentCategory.name MATCHES %@",  selectedCategory!.name!)
//        request.predicate = prediacte
//        do {
//         itemArray = try context.fetch(request)
//        } catch  {
//            print("Error fetching data from context ..\(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoList", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //.........Start to update the NSManaged Object
//        let Itemupdate = itemArray[indexPath.row]
//        Itemupdate.setValue("Completed", forKey: "title")
        //.........End to update the NSManaged Object
        
        //............. This is for delete the NSManaged Obejct through the Context
        context.delete(itemArray[indexPath.row])
        saveItems()
        loadItems()
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TodoListTableViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let fetchRequest:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: fetchRequest, predicate: predicate)
        
//        do {
//          itemArray =  try context.fetch(fetchRequxest)
//        } catch  {
//            print("Error fetching data")
//        }
//        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}







































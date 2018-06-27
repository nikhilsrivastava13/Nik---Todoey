//
//  ViewController.swift
//  Todoey
//
//  Created by NIK-HIL on 6/13/18.
//  Copyright © 2018 NIKHIL. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    
    var itemArray = [Item]()
    
    var selectedCategory : Categories? {
        didSet {
            loaditems()
        }
    }
  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    @IBOutlet weak var SearchBar: UISearchBar!
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let  item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ===>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        

        // Flashes the selected item and then goes back to white background
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New items sections
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController (title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button on the UI alert
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text!)
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present (alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {

        do {
          try context.save()
        } catch {
          print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Load Data Method
    
    // Below function has both internal(with) and external(request) parameters along with the default value ( = Item.fetchRequest() )
    
    func loaditems (with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
        print("Error fetching data from core data \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: Search bar Methods

extension ToDoListViewController: UISearchBarDelegate {

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
        loaditems(with: request, predicate: searchPredicate)
    
    }
    
    // Below function was called when text in a search bar was changed and when user deleted the text in the search bar or hit x to clear the text then If condition will be checked and if the condition is true i.e == 0 then load item with default values
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loaditems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

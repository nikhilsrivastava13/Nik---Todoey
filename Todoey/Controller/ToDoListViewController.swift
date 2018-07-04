//
//  ViewController.swift
//  Todoey
//
//  Created by NIK-HIL on 6/13/18.
//  Copyright © 2018 NIKHIL. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory : Categories? {
        didSet {
            loaditems()
        }
    }
  
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    @IBOutlet weak var SearchBar: UISearchBar!
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let  item = todoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
        
            //Ternary operator ===>
            // value = condition ? valueIfTrue : valueIfFalse
        
            cell.accessoryType = item.done == true ? .checkmark : .none
        
        } else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return todoItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//              realm.delete(item)
                item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        self.tableView.reloadData()
        
        // Flashes the selected item and then goes back to white background
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New items sections
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController (title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text!)
            textField = alertTextField
        }
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button on the UI alert
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                    newItem.dateCreated = Date()
//         newItem.parentCategory = self.selectedCategory
                        }
                    } catch {
                    print ("Error Saving new items, \(error)")
                }
            self.tableView.reloadData()
            
//            self.saveItems(itemArray: newItem)
            }
        }
        
            alert.addAction(action)
            
            self.present (alert, animated: true, completion: nil)

    }
    //MARK: - Model Manipulation Methods
    
//    func saveItems(itemArray: Item) {
//
//        do {
//            try realm.write {
//                realm.add(itemArray)
//            }
//        } catch {
//          print("Error saving data \(error)")
//        }
//        tableView.reloadData()
//    }
    
    //MARK: - Load Data Method
    
    // Below function has both internal(with) and external(request) parameters along with the default value ( = Item.fetchRequest() )

    func loaditems () {

       todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
      
        tableView.reloadData()
    }
    
}

//MARK: Search bar Methods

extension ToDoListViewController: UISearchBarDelegate {

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
    
    tableView.reloadData()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loaditems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

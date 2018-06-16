//
//  ViewController.swift
//  Todoey
//
//  Created by NIK-HIL on 6/13/18.
//  Copyright © 2018 NIKHIL. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
    var itemArrary = ["Item 1", "Item 2", "Item 3"]
    
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            
            itemArrary = items
        }
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArrary[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArrary.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //print (itemArrary[indexPath.row])
        
        // Flashes the selected item and then goes back to white background
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New items sections
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController (title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button on the UI alert
            
            
            self.itemArrary.append(textField.text!)
            
            self.defaults.set(self.itemArrary, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
          
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text!)
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present (alert, animated: true, completion: nil)
        
        
    }
    
}


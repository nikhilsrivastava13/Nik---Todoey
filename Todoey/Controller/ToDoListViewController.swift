//
//  ViewController.swift
//  Todoey
//
//  Created by NIK-HIL on 6/13/18.
//  Copyright © 2018 NIKHIL. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
    var itemArrary = [ToDoItems]()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath!)

        loaditems()
        
// Old way of defining data in an array. Instead we have defined a function loaddata() above which will get the data from plist file
        
//        let items1 = ToDoItems()
//        items1.title = "Find Mike"
//        itemArrary.append(items1)
//
//        let items2 = ToDoItems()
//        items2.title = "Buy Eggos"
//        itemArrary.append(items2)
//
//        let items3 = ToDoItems()
//        items3.title = "Destroy Demogorgon"
//        itemArrary.append(items3)
//
//        let items4 = ToDoItems()
//        items4.title = "Save the World"
//        itemArrary.append(items4)
        
//  This was an old way of loading the item array from User default so that the data in the array loads up everytime we load the app. Not a good way to handle the data persistance and hence we created "A Custom data model" which stores messages
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [ToDoItems] {
//        itemArrary = items
//        }
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let  item = itemArrary[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ===>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.Done == true ? .checkmark : .none
        

// This is an old way of comparing the values. We have reduced the code above by using Ternary Operator
        
//        if item.Done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArrary.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArrary[indexPath.row].Done = !itemArrary[indexPath.row].Done
        
        saveItems()
    
//        if itemArrary[indexPath.row].Done == false {
//            itemArrary[indexPath.row].Done = true
//        } else {
//            itemArrary[indexPath.row].Done = false
//        }
        

        
        // Flashes the selected item and then goes back to white background
        tableView.deselectRow(at: indexPath, animated: true)
        
//        This was an old way of checking & Unchecking an item in the list. The code in cellforrow method replaced this piece of code
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //print (itemArrary[indexPath.row])
    }
    
    //MARK - Add New items sections
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController (title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button on the UI alert
            
            let newItem = ToDoItems()
            newItem.title = textField.text!
            
            self.itemArrary.append(newItem)
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
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArrary)
            try data.write(to:dataFilePath!)
        } catch {
            print("Error encoding item arry, \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK - Load Data Method
    
    func loaditems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArrary = try decoder.decode([ToDoItems].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    
    }

}

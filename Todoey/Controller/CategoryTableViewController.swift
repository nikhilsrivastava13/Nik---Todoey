//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by NIK-HIL on 6/23/18.
//  Copyright © 2018 NIKHIL. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var category = [Categories]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let request : NSFetchRequest<Categories> = Categories.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK: - TableView DataSource method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return category.count
    }
    
    //MARK: - Add TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category[indexPath.row]
        }
    }
    
    
    //MARK:  - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
            let newCategory = Categories(context: self.context)
            
             newCategory.name = textField.text!
            
            self.category.append(newCategory)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (categorytextfield) in
        categorytextfield.placeholder = "Create New Category"
        textField = categorytextfield
        }
        
        alert.addAction(action)
        
        present (alert, animated: true, completion: nil)
        
       
    }
    
    //MARK: - TableView Manipulation method (CRUD)
    
    func saveItems() {
        do {
        try context.save()
        } catch {
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Load Data Method
    func loadItems() {
        
        do {
        category = try context.fetch(request)
        } catch {
        print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }
    
    
 
}

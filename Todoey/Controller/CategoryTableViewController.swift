//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by NIK-HIL on 6/23/18.
//  Copyright © 2018 NIKHIL. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var category : Results<Categories>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    
    //MARK: - TableView DataSource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category?[indexPath.row].name ?? "No Categories added Yet"
        
        return cell
        
    }
    
    //MARK: - Add TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
    
    
    //MARK:  - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
            let newCategory = Categories()
            
             newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (categorytextfield) in
        categorytextfield.placeholder = "Create New Category"
        textField = categorytextfield
        }
        
        alert.addAction(action)
        
        present (alert, animated: true, completion: nil)
        
       
    }
    
    //MARK: - TableView Manipulation method (CRUD)
    
    func save(category: Categories) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Load Data Method
    func loadCategory() {

        category = realm.objects(Categories.self)
        
        tableView.reloadData()
    }
}

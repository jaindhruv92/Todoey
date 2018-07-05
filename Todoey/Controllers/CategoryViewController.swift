//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dhruv Jain on 04/07/18.
//  Copyright © 2018 Dhruv Jain. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    var category : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }


    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once user clicks the Add item button on the UI Alert
            
            let newItem = Category()
            newItem.name = textField.text!
            
            //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
           

            self.save(category: newItem)
            

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = category?[indexPath.row].name ?? "No Categories Added"
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation methods
    func save(category: Category){
        //  let encoder = PropertyListEncoder()
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            
        }
        self.tableView.reloadData()
    }
    func loadCategories(){
         category = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}

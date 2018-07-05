//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dhruv Jain on 04/07/18.
//  Copyright © 2018 Dhruv Jain. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryViewController: SwipeTableTableViewController{
    let realm = try! Realm()
    var category : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
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
            newItem.colour = UIColor.randomFlat.hexValue()
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
        

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let categoryy = category?[indexPath.row]{
            
            
        cell.textLabel?.text = categoryy.name
        //cell.backgroundColor = UIColor(hexString: category?[indexPath.row].colour ?? "1D9BF6")
            guard let categoryColor = UIColor(hexString: categoryy.colour) else{fatalError()}
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
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
    
    //MARK: - Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.category?[indexPath.row]{
                            do {
                                try self.realm.write {
                                    self.realm.delete(categoryForDeletion)
                                }
                            }catch{
            
                            }
                        }
    }
}


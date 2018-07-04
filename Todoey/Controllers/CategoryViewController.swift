//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dhruv Jain on 04/07/18.
//  Copyright © 2018 Dhruv Jain. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
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
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            
            self.categoryArray.append(newItem)
            //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
           

            self.saveCategories()
            

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
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation methods
    func saveCategories(){
        //  let encoder = PropertyListEncoder()
        do{
            try  context.save()
            
        }catch{
            print("Error saving coontext \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

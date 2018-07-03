//
//  ViewController.swift
//  Todoey
//
//  Created by Dhruv Jain on 29/06/18.
//  Copyright © 2018 Dhruv Jain. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray = [Item]()
//    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        print(dataFilePath)
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destory Demogorgon"
//        itemArray.append(newItem3)
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//
//    }
    loadItems()
    }
//MARK- Table View DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK- TableViewDelegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
//        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks the Add item button on the UI Alert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error Encoding item array,\(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try itemArray = decoder.decode([Item].self, from: data)
            }catch{
                print("Error Decoding item array,\(error)")
            }
        }
    }
}


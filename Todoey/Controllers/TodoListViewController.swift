//
//  ViewController.swift
//  Todoey
//
//  Created by Abdulla Aseed on 20/11/1440 AH.
//  Copyright © 1440 Abdulla Aseed. All rights reserved.
//

import UIKit
 class TodoListViewController: UITableViewController   {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item ]{
            itemArray = items
        }
        // Do any additional setup after loading the view.
    }

// Make  -  Table Veiw Data source Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        
//        if    item.done == true {
//            cell.accessoryType = .checkmark
//        }else {cell.accessoryType = .none }
        
// the another short  way of condition called  -> Ternary
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // Mark - TableVeiw Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()

        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user click the add item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            
         }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create A New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)

present(alert, animated: true, completion: nil)    }
    
 }


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
//    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
                print(dataFilePath)
//
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
 loadItems()
        
        
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
        
        self.saveItem()
 
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
            self.saveItem()
           
            
         }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create A New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)

present(alert, animated: true, completion: nil)    }
    
    // MARK - Model Manupulation Methods
    func saveItem(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try  data.write(to : dataFilePath!)
        }
        catch { print("Error encoding Item Array,\(error)") }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let  decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch
            { print("Error Decoding item Array, \(error)") }
            
        }
    }
    
 }


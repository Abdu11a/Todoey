//
//  ViewController.swift
//  Todoey
//
//  Created by Abdulla Aseed on 20/11/1440 AH.
//  Copyright © 1440 Abdulla Aseed. All rights reserved.
//

import UIKit
import RealmSwift
 class TodoListViewController: UITableViewController    {
    
    var todoItems : Results<Item>?
    let realm  = try! Realm()
    var selectedCategory : Category? {
        didSet{
    loadItems()
        }
    }
    
    
//    let defaults = UserDefaults.standard
   
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) )
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
        
  
        
        
        // Do any additional setup after loading the view.
    }

// Make  -  Table Veiw Data source Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        
        if  let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.titel
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
    
        
        return cell
    }
    
    // Mark - TableVeiw Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do {
            try realm.write {
                item.done = !item.done
                
                }
                
            } catch {print("Error Saving done status,\(error)"  )}
            
        }
        
        tableView.reloadData()
//
 
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user click the add item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.titel = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem )
                    }
                } catch {
                    print("Error Saving  New Items, \(error)")
                }
            }
          
           
         self.tableView.reloadData() 
         }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create A New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)

present(alert, animated: true, completion: nil)    }
    
    // MARK - Model Manupulation Methods

    
    func loadItems() {

          todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }


    
    
 }
// MARK : - search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }


   

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
    }
}

//
//  ViewController.swift
//  Todoey
//
//  Created by Abdulla Aseed on 20/11/1440 AH.
//  Copyright © 1440 Abdulla Aseed. All rights reserved.
//

import UIKit
import CoreData
 class TodoListViewController: UITableViewController    {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
             loadItems()
        }
    }
    
    
//    let defaults = UserDefaults.standard
   
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
        
//         context.delete(itemArray[indexPath.row])
//        itemArray.remove(at:indexPath.row)
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItem()
 
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user click the add item button on our UIAlert
            
          
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
       
        do { 
            try context.save()
           
        }
        catch {
            print("Error saving context ,\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
      
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
  
         do {
           itemArray = try  context.fetch(request)

        } catch {print("Error fetching data context \(error)")}
        
        
    }
    

    
    
 }
// MARK : - search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()

          let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with : request , predicate:predicate )

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

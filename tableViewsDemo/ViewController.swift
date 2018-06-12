//
//  ViewController.swift
//  tableViewsDemo
//
//  Copyright © 2018 MyCompany. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tblList: UITableView!
    var arrayFruit = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
     self.tblList.dataSource = self
        self.tblList.delegate = self
       // self.arrayFruit = ["Apple","Banana","Orange","Grapes","Watermelon"]
       self.fetchData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - table method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayFruit.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:simpleTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"simpleTableViewCell") as? simpleTableViewCell
        if cell == nil{
            tableView.register(UINib.init(nibName: "simpleTableViewCell", bundle: nil), forCellReuseIdentifier: "simpleTableViewCell")
            let arrNib:Array = Bundle.main.loadNibNamed("simpleTableViewCell",owner: self, options: nil)!
            cell = arrNib.first as? simpleTableViewCell
        }
        let fruit = self.arrayFruit[indexPath.row]
        cell?.labelName.text = fruit.value(forKey: "name") as! String
        cell?.imageViewFruit.image = UIImage (named: "fruit_img")
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
     return 100.0
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (action, indexPath) in
//            self.arrayFruit.remove(at: indexPath.row)
//            self.tblList.reloadData()
        let fruit = self.arrayFruit[indexPath.row]
        let name = fruit.value(forKey: "name") as! String
          
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Fruit")
            request.predicate = NSPredicate(format: "name = %@", name)
            request.returnsObjectsAsFaults = false
            
            do{
               let test = try managedContext.fetch(request)
                if test.count == 1{
                    let objectDelete = test[0] as! NSManagedObject
                    //delete this way
                    managedContext.delete(objectDelete)
                    
                    do{
                        try managedContext.save()
                        print("Object is deleted successfully...")
                    }catch{
                        print("error")
                    }
                }
            }catch{
                print("error")
            }
            self.fetchData()
        }
        
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit") { (action, indexpath) in
            
            let alert = UIAlertController(title: "FruitApp", message: "Enter Fuit Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter new fruit name"
            })
            alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { [weak alert](_) in
                let textField = alert?.textFields![0]
                
                let fruit = self.arrayFruit[indexPath.row]
                let name = fruit.value(forKey: "name") as! String
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Fruit")
                request.predicate = NSPredicate(format: "name = %@", name)
                request.returnsObjectsAsFaults = false
                
                do{
                    let test = try managedContext.fetch(request)
                    if test.count == 1{
                        let objectUpdate = test[0] as! NSManagedObject
                        objectUpdate.setValue(textField?.text!, forKey: "name")
                        do{
                            try managedContext.save()
                            print("Updated sucessfully...")
                        }catch{
                            print("error")
                        }
                    }
                }catch{
                    print("error")
                }
                self.fetchData()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        edit.backgroundColor = UIColor.blue
        return [delete,edit]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "secondViewController") as! secondViewController
        //vc.strName = self.arrayFruit[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonHandlerAdd(_ sender: Any) {
        let alert = UIAlertController(title: "FruitApp", message: "Enter Fuit Name", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter new fruit name"
        })
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { [weak alert](_) in
           let textField = alert?.textFields![0]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName:"Fruit", in: context)
            let newFruit = NSManagedObject(entity: entity!, insertInto: context)
            newFruit.setValue(textField?.text!, forKey:"name")
            newFruit.setValue(false, forKey:"isDone")
            do{
                try context.save()
                self.fetchData()
                print("Data added successfully....")
            }catch{
                print("Error while inserting data....")
            }
            self.tblList.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)

        
    }
    func fetchData(){
        self.arrayFruit.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Fruit")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                self.arrayFruit.append(data)
                
            }
            self.tblList.reloadData()
        }catch{
            print("error while fetching....")
        }
    }
    
}


//
//  MasterViewController.swift
//  Assignment 3.5
//
//  Created by Brian Chun on 4/27/17.
//  Copyright © 2017 Brian Chun. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var filePath: String? {
        do {
            let fileManager = FileManager.default
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let savePath = documentDirectory.appendingPathComponent("Musicians.bin")
            return savePath.path
        } catch {
            print("Error getting path")
            return nil
        }
    }
    
    var detailViewController: DetailViewController? = nil
    var musicians = [Musicians]()

    let firstName = ["Michael", "Jimi", "Tupac", "Kurt", "John", "Freddie", "Elvis"]
    let lastName = ["Jackson", "Hendrix", "Shakur", "Cobain", "Lennon", "Mercury", "Presley"]
    let year = [2009, 1970, 1996, 1994, 1980, 1991, 1977]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        if let path = filePath {
            if let array = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [Musicians] {
                musicians = array
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        let randomFirstName = firstName[Int(arc4random_uniform(UInt32(firstName.count)))]
        let randomLastName = lastName[Int(arc4random_uniform(UInt32(lastName.count)))]
        let randomyear = year[Int(arc4random_uniform(UInt32(year.count)))]
        
        musicians.insert(Musicians(firstName: randomFirstName, lastName: randomLastName, year: randomyear), at: 0)
        if let path = filePath {
            NSKeyedArchiver.archiveRootObject(musicians, toFile: path)
        }
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = musicians[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicians.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = musicians[indexPath.row]
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            musicians.remove(at: indexPath.row)
            if let path = filePath {
                NSKeyedArchiver.archiveRootObject(musicians, toFile: path)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}


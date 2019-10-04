//
//  DocumentsViewController.swift
//  DocumentsCoreDataSearch
//
//  Created by Brady Webb on 10/4/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit
import CoreData

class DocumentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    @IBOutlet weak var documentsTableView: UITableView!
    let dateFormatter = DateFormatter()
    var selectedSearchScope = SearchScope.all
    var documents = [Document]()
    var searchController : UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Document"
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search"
        searchController?.searchBar.scopeButtonTitles = SearchScope.titles
        searchController?.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDocuments(searchString: "")
    }
    
    func fetchDocuments(searchString: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do
        {
            if (searchString != "")
            {
                switch (selectedSearchScope)
                {
                case .name:
                    fetchRequest.predicate = NSPredicate(format: "contains[c] %@", searchString)
                case .content:
                    fetchRequest.predicate = NSPredicate(format: "contains[c] %@", searchString)
                }
            }
            documents = try managedContext.fetch(fetchRequest)
            documentsTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selectedSearchScope = SearchScope.scopes[selectedScope]
        if let searchString = searchController?.searchBar.text
        {
            fetchDocuments(searchString: searchString)
        }
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        let document = documents[indexPath.row]
        
        if let managedObjectContext = document.managedObjectContext
        {
            managedObjectContext.delete(document)
            
            do
            {
                try managedObjectContext.save()
                self.documents.remove(at: indexPath.row)
                documentsTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "document", for: indexPath)
        
        if let cell = cell as? DocumentTableViewCell
        {
            let document = documents[indexPath.row]
            cell.sizeLabel.text = String(document.size) + " bytes"
            cell.nameLabel.text = document.name
            
            if let modifiedDate = document.modifiedDate
            {
                cell.modifiedLabel.text = dateFormatter.string(from: modifiedDate)
            }
            else
            {
                cell.modifiedLabel.text = "error"
            }
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentViewController,
           let segueIdentifier = segueIdentifier == "NewDocument",
           let row = documentsTableView.indexPathForSelectedRow?.row
        {
                destination.document = documents[row]
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            deleteDocument(at: indexPath)
        }
    }
}

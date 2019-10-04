//
//  DocumentViewController.swift
//  DocumentsCoreDataSearch
//
//  Created by Brady Webb on 10/4/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""

        if let document = document
        {
            let name = document.name
            nameTextField.text = name
            contentTextView.text = document.content
            title = name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any) {
        let documentName = name.trimmingCharacters(in: .whitespaces)
       
        let content = contentTextView.text
        
        if document == nil
        {
            document = Document(name: documentName, content: content)
        }
        else
        {
            document?.update(name: documentName, content: content)
        }
        
        if let document = document
        {
            do
            {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        title = nameTextField.text
    }
}

//
//  NoteViewController.swift
//  secureNote
//
//  Created by Vladimir Kovalev on 06.04.2023.
//

import UIKit

class NoteViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var lockButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var noteList: [Note]?

    var message: String?
    var lockStatus: String?
    var index: Int?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        guard let noteText = message else { return }
        guard let lockStatus = lockStatus else { return }
        
        let buttonTitle = lockStatus == "locked" ? "Unlock this note" : "Lock this note"
        noteTextView.text = noteText
        lockButton.setTitle(buttonTitle, for: .normal)
        
        lockButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    //MARK: - Actions
    
    
    @IBAction func lockButtonPressed(_ sender: UIButton) {
        guard let index = index else { return }
        guard let noteList = noteList else { return }
        
        let lockedStatus = lockStatus == "locked" ? "unlocked"  : "locked"
        
        noteList[index].setValue(lockedStatus, forKey: "lockStatus")
        saveItems()
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension NoteViewController {
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("ERROR saving items")
        }
    }
}

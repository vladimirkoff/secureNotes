//
//  NotesListViewController.swift
//  secureNote
//
//  Created by Vladimir Kovalev on 06.04.2023.
//

import UIKit
import LocalAuthentication
import CoreData
private let reuseIdentifier = "NoteCell"

class NotesViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var noteList: [Note]? {
        didSet {
            tableView.reloadData()
        }
    }

    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNote))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems { notes in
            self.noteList = notes
        }
        configureTableView()
        tableView.reloadData()
    }
    
    //MARK: - Actions
    
    @objc func addNote() {
        let alertController = UIAlertController(title: "Add note", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Note"
        }
        
        let continueAction = UIAlertAction(title: "Add",
                                           style: .default) { [weak alertController] _ in
            guard let textField = alertController?.textFields else { return }
            
            if let noteText = textField[0].text {
                let newNote = Note(context: self.context)
                newNote.message = noteText
                newNote.lockStatus = "unlocked"
                self.saveItems()
            }
        }
        alertController.addAction(continueAction)
        present(alertController, animated: true)
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        tableView.register(UINib(nibName: "NoteCellTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func pushNote(indexPath: IndexPath) {
        guard let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController else { return }
        guard let note = noteList?[indexPath.row] else { return }
        
        noteVC.lockStatus = note.lockStatus
        noteVC.message = note.message
        noteVC.index = indexPath.row
        noteVC.noteList = noteList
        
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteCell
        if let noteList = noteList {
            guard let message = noteList[indexPath.row].message else { return UITableViewCell() }
            guard let lockStatus: LockStatus = noteList[indexPath.row].lockStatus == "locked" ? .locked : .unlocked else { return UITableViewCell() }
            let note = NoteModel(message: message, lockStatus: lockStatus)
            cell.configure(note: note)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteList = noteList else { return }
        if noteList[indexPath.row].lockStatus == "locked" {
            authBiometrics { [weak self] authenticated in
                noteList[indexPath.row].lockStatus = "unlocked"
                DispatchQueue.main.async {
                    self?.pushNote(indexPath: indexPath)
                }
            }
        } else {
            pushNote(indexPath: indexPath)
        }
    }
    
    //MARK: - TocuhId
    func authBiometrics(completion: @escaping(Bool) -> ()) {
        let myContext = LAContext()
        let reason = "Our app uses Tocuh/Face ID to secure your data"
        var authError: NSError?
        
        if #available(iOS 8.0, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                    if success {
                        completion(true)
                    } else {
                        guard let evaluateErrorString = error?.localizedDescription else { return }
                        DispatchQueue.main.async {
                            
                            self?.showAlert(with: evaluateErrorString)
                            completion(false)
                        }

                    }
                }
            } else {
                guard let authErrorString = authError?.localizedDescription else { return }
                DispatchQueue.main.async {
                    self.showAlert(with: authErrorString)
                    completion(false)
                }
                
            }
        } else {
            completion(false)
        }
    }
}

//MARK: - CoreData methods

extension NotesViewController {
    func loadItems(completion: @escaping([Note]) -> ()) {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        do {
            let noteList = try context.fetch(request)
            completion(noteList)
        } catch {
            print("ERROR loading items")
        }
        tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("ERROR saving items")
        }
    }
}

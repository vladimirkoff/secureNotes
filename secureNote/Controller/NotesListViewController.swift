//
//  NotesListViewController.swift
//  secureNote
//
//  Created by Vladimir Kovalev on 06.04.2023.
//

import UIKit
import LocalAuthentication
private let reuseIdentifier = "NoteCell"

class NotesViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        tableView.reloadData()
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
        
        let note = notesArray[indexPath.row]
        noteVC.lockStatus = note.lockStatus
        noteVC.message = note.message
        noteVC.index = indexPath.row
        
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteCell
        let note = notesArray[indexPath.row]
        cell.configure(note: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notesArray[indexPath.row].lockStatus == .locked {
            authBiometrics { [weak self] authenticated in
                notesArray[indexPath.row].lockStatus = .unlocked
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
                        print("Here")
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

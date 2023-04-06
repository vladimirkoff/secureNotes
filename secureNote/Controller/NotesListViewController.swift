//
//  NotesListViewController.swift
//  secureNote
//
//  Created by Vladimir Kovalev on 06.04.2023.
//

import UIKit

private let reuseIdentifier = "NoteCell"

class NotesViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        tableView.register(UINib(nibName: "NoteCellTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
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
        guard let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController else { return }
        
        let note = notesArray[indexPath.row]
        noteVC.lockStatus = note.lockStatus
        noteVC.message = note.message
        noteVC.index = indexPath.row
        
        navigationController?.pushViewController(noteVC, animated: true)
    }
}

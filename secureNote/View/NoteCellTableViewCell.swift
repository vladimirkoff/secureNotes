//
//  NoteCellTableViewCell.swift
//  secureNote
//
//  Created by Vladimir Kovalev on 06.04.2023.
//

import UIKit

class NoteCell: UITableViewCell {
    //MARK: - Properties
    
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK: - Helpers
    
    func configure(note: NoteModel) {
        let message = "\(note.message.prefix(40))..."
        let lockStatus = note.lockStatus
        
        noteLabel.text = message
        lockImage.image = lockStatus == .unlocked ? UIImage(systemName: "lock.open.fill") : UIImage(systemName: "lock")
    }
}

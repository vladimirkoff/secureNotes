//
//  Note.swift
//  secureNote
//
//  Created by Vladimir Kovalev on 06.04.2023.
//

import Foundation

struct NoteModel {
    let message: String
    var lockStatus: LockStatus
    
    init(message: String, lockStatus: LockStatus) {
        self.message = message
        self.lockStatus = lockStatus
    }
}

struct NoteList {
    static var noteList = [Note]()
}



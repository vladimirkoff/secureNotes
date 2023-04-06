//
//  Note.swift
//  secureNote
//
//  Created by Vladimir Kovalev on 06.04.2023.
//

import Foundation

class Note {
    public private(set) var message: String
    public  var lockStatus: LockStatus
    
    init(message: String, lockStatus: LockStatus) {
        self.message = message
        self.lockStatus = lockStatus
    }
}

//
//  File.swift
//  secureNote
//
//  Created by Vladimir Kovalev on 06.04.2023.
//

import Foundation

func isNoteLocked(lockStatus: LockStatus) -> Bool {
    switch lockStatus {
    case .locked:
        return true
    case .unlocked:
        return false
    }
}

func lockStatusFlipper(lockStatus: LockStatus) -> LockStatus {
    switch lockStatus {
    case .locked:
        return .unlocked
    case .unlocked:
        return .locked
    }
}

//
//  NoteObjects.swift
//  secureNote
//
//  Created by Vladimir Kovalev on 06.04.2023.
//

import Foundation

var note1 = Note(message: "It is my first FaceID app", lockStatus: .locked)
var note2 = Note(message: "My name is Vladimir", lockStatus: .locked)
var note3 = Note(message: "I am a gymrat", lockStatus: .unlocked)
var note4 = Note(message: "password from my apple id is itsmyIphonexsb1", lockStatus: .locked)


var notesArray: [Note] = [ note1, note2, note3, note4 ]

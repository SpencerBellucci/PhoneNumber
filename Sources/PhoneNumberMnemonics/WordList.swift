// WordList.swift
// Created for Assignment 5 of CSI 380

import Foundation

// YOU FILL IN HERE
// You'll want to create a mechanism here for loading and querying
// words.txt. It's up to you how you do this. You may consider a struct.

// struct for file i/o
struct fileIO {
    // url of file
    let fileURL = "/Users/spencerbellucci/Desktop/EmergingLang/PhoneNumber/words.txt"
    
    // func to put contents of file in a string
    func readFile() -> String {
        do {
            let contents = try String(contentsOfFile: fileURL)
            return contents.uppercased()
        } catch { return "Error" }
    }
    // check for words in list with min length
    func querryFile(message: String, list: [String], length: UInt) -> [String] {
        let array = list.map { message.contains($0) ? $0 : ""}.filter { $0 != "" && $0.count >= length}
        return array
    }
}

// WordSearch.swift
// Created for Assignment 5 of CSI 380

import Foundation

let zero = ["0"]
let one = ["1"]
let two = ["A", "B", "C"]
let three = ["D", "E", "F"]
let four = ["G", "H", "I"]
let five = ["J", "K", "L"]
let six = ["M", "N", "O"]
let seven = ["P", "Q", "R", "S"]
let eight = ["T", "U", "V"]
let nine = ["W", "X", "Y", "Z"]

// Feel free to put in additional utility code as long as you have
// no loops, no *mutable* global variables, and no custom classes.

// Replaces each character in a phone number with an array of the
// possible letters that could be in place of that character
// For instance, 234 becomes [["A", "B", "C"], ["D", "E", "F"], ["G", "H", "I"]]
public func letters(for phoneNumber: String) -> [[String]] {
    // hold the letters
    var letterArray: [[String]] = []
    
    // define recursive function for converting numbers to letters
    func printNumber(num: String, offset: Int, maxOffset: Int) {
        // if phone number length has not been reached
        if (offset != maxOffset) {
            // index the next number
            let i = num[num.index(num.startIndex, offsetBy: offset)]
            // find which letters to add
            switch(i) {
                case "0":
                    letterArray.append(zero)
                case "1":
                    letterArray.append(one)
                case "2":
                    letterArray.append(two)
                case "3":
                    letterArray.append(three)
                case "4":
                    letterArray.append(four)
                case "5":
                    letterArray.append(five)
                case "6":
                    letterArray.append(six)
                case "7":
                    letterArray.append(seven)
                case "8":
                    letterArray.append(eight)
                case "9":
                    letterArray.append(nine)
                default:
                    print("Error")
            }
            printNumber(num: num, offset: offset + 1, maxOffset: maxOffset)
        }
    }
    // call recursive function
    printNumber(num: phoneNumber, offset: 0, maxOffset: 10)
    return letterArray
}

// Finds all of the ordered permutations of a given
// array of arrays of strings
// combining each choice in one
// array with each choice in the next array, and so on to produce strings
// For instance permuations(of: [["a", "b"], ["c"], ["d", "e"]]) will return
// ["acd", "ace" "bcd", "bce"]
public func permutations(of arrays: [[String]]) -> [String] {
    // get the first array in arrays
    let arraysFirst = arrays[0]
    
    // use high-order functions to find permutations
    let perm = arrays.dropFirst().reduce(arraysFirst){( first, word ) in
        first.flatMap {( i ) in
            word.map {
                j in i + j
            }
        }
    }
    // return the array
    return perm
}

// Finds all of the possible strings of characters that a phone number
// can potentially represent
// Uses letters(for:) and permutations(of:) to do this
public func possibles(for phoneNumber: String) -> [String] {
    // find possible letters
    let possibleLetters = letters(for: phoneNumber)
    // find permutations of said letters
    let perms = permutations(of: possibleLetters)
    
    return perms
}

// Returns all of the words in a given *string* from the wordlist.txt file
// using only words in the word list of minimum length ofMinLength
public func wordsInString(_ string: String, ofMinLength length: UInt) -> [String] {
    // create the file object
    let file = fileIO()

    // querry the file, then turn string into array
    let text = (file.readFile()).components(separatedBy: "\n").filter { $0 != "" }

    // find all the words that occur in the message
    let words = file.querryFile(message: string, list: text, length: length)

    return words
}

// Returns all possibles strings of characters that a phone number
// can potentially represent that contain words in words.txt
// greater than or equal to ofMinLength characters
public func possiblesWithWholeWords(ofMinLength length: UInt, for phoneNumber: String) -> [String] {
    // possible letter combos
    let letterCombo = possibles(for: phoneNumber)
    // find which of these has a word from words.txt in the combo
    let posWords = letterCombo.filter {
        wordsInString($0, ofMinLength: length).count > 0
    }
    
    return posWords
}

// Returns the phone number mnemonics that have the most words present in words.txt
// within them (note that these words could be overlapping)
// For instance, if there are two mnemonics that contain three words from
// words.txt, it will return both of them, if the are no other mnemonics
// that contain more than three words
public func mostWords(for phoneNumber: String) -> [String] {
    // get possible
    let letterCombo = possibles(for: phoneNumber)

    // find words from words.txt present in possible
    let words = letterCombo.map { i in
        return wordsInString(i, ofMinLength: 0)
    }.filter { $0 != [] }

    // find that ones with most words present in one possible
    if let max = words.max(by: {$1.count > $0.count}) {
        return(max)
    }
    return[""]
}

// Returns the phone number mnemonics with the longest words from words.txt
// If more than one word is tied for the longest, returns all of them
public func longestWords(for phoneNumber: String) -> [String] {
    // get possible
    let letterCombo = possibles(for: phoneNumber)

    // find words from words.txt present in possible, and filter into one array
    let words = letterCombo.map { i in
        return wordsInString(i, ofMinLength: 0)
    }.filter { $0 != [] }.reduce([]) { array, words in
        array + words
    }

    // find the longest string in array
    if let longest = words.max(by: {$1.count > $0.count}) {
        return [longest]
    }
    return [""]
}

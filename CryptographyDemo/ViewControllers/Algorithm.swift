//
//  Algorithm.swift
//  CryptographyDemo
//
//  Created by tcui on 14/8/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

import UIKit

// MARK: - Algorithm

enum Algorithm: String {
    case caesar
    case substitution
    case vigenère
    case enigma
    
    init?(segueIdentifier: String) {
        let algorithmEnumName = segueIdentifier.replacingOccurrences(of: " ", with: "").lowercased()
        if let algorithm = Algorithm(rawValue: algorithmEnumName) {
            self = algorithm
        } else {
            return nil
        }
    }
    
    var cryptography: Cryptography {
        switch self {
        
        case .caesar:
            return CaesarCipher()
        case .substitution:
            return SubstitutionCipher()
        case .vigenère:
            return Vigenere()
        case .enigma:
            return Enigma()
        }
    }
}

protocol Cryptography {
    var name: String { get }
    var defaultKey: String { get }
    func encrypt(from text: String, key: String) -> String?
    func decrypt(from text: String, key: String) -> String?
}


// MARK: - CaesarCipher
struct CaesarCipher: Cryptography {
    var name = "Caesar Cipher"
    var defaultKey = "3"
    
    func encrypt(from text: String, key: String) -> String? {
        guard let shift = Int32(key) else {
            return nil
        }
        
        let newCharacters = text.characters.map { ch -> Character in
            let res: Character
            switch ch {
            case "a"..."z": res = encipherChar(char: ch, shiftBy: shift, base: "a")
            case "A"..."Z": res = encipherChar(char: ch, shiftBy: shift, base: "A")
            default: res = ch
            }
            return res
        }
        
        return String(newCharacters)
    }
    
    func decrypt(from text: String, key: String) -> String? {
        guard let newKey = key.reversedIntString() else {
            return nil
        }
        
        return encrypt(from: text, key: newKey)
    }
    
    private func asciiIndex(withChar char: Character) -> UInt32 {
        let unicodeScalars = String(char).unicodeScalars
        
        return unicodeScalars[unicodeScalars.startIndex].value
    }
    
    private func encipherChar(char: Character, shiftBy shift: Int32, base: Character) -> Character {
        let baseIndex = asciiIndex(withChar: base)
        let charIndex = asciiIndex(withChar: char)
        let resIndex = baseIndex + UInt32((Int32(charIndex) - Int32(baseIndex) + shift + 26) % 26)
        
        return Character(UnicodeScalar(resIndex)!)
    }
    
}

// MARK: - SubstitutionCipher
struct SubstitutionCipher: Cryptography {
    var name = "Substitution Cipher"
    var defaultKey = "TMKGOYDSIPELUAVCRJWXZNHBQF"
    var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
   
    func encrypt(from text: String, key: String) -> String? {
        
        let uppercaseMap = cipherMap(key: alphabet.uppercased(), value: key.uppercased())
        let lowercaseMap = cipherMap(key: alphabet.lowercased(), value: key.lowercased())
        
        return cipherText(plainText: text, uppercaseMap: uppercaseMap, lowercaseMap: lowercaseMap)
    }
    
    func decrypt(from text: String, key: String) -> String? {
        let uppercaseMap = cipherMap(key: key.uppercased(), value: alphabet.uppercased())
        let lowercaseMap = cipherMap(key: key.lowercased(), value: alphabet.lowercased())
        
        return cipherText(plainText: text, uppercaseMap: uppercaseMap, lowercaseMap: lowercaseMap)
    }
    
    private func cipherText(plainText: String, uppercaseMap: [Character: Character], lowercaseMap: [Character: Character]) -> String {
        let newCharacters = plainText.characters.map { ch -> Character in
            let res: Character
            switch ch {
            case "a"..."z": res = lowercaseMap[ch] ?? ch
            case "A"..."Z": res = uppercaseMap[ch] ?? ch
            default: res = ch
            }
            return res
        }
        
        return String(newCharacters)
    }
    
    private func cipherMap(key: String, value: String) -> [Character: Character] {
        var res = [Character:Character]()
        zip(key.characters, value.characters).forEach { res[$0] = $1 }
        return res
    }
}

// MARK: - Enigma
struct Enigma: Cryptography {
    var name = "Enigma"
    var defaultKey = "default key"
    
    func encrypt(from text: String, key: String) -> String? {
        guard let shift = Int(key) else {
            return nil
        }
        
        let newCharacters = text.characters.map { ch -> Character in
            let res: Character
            switch ch {
            case "a"..."z": res = encipherChar(char: ch, shiftBy: shift, base: "a")
            case "A"..."Z": res = encipherChar(char: ch, shiftBy: shift, base: "A")
            default: res = ch
            }
            return res
        }
        
        return String(newCharacters)
    }
    
    func decrypt(from text: String, key: String) -> String? {
        guard let newKey = key.reversedIntString() else {
            return nil
        }
        
        return encrypt(from: text, key: newKey)
    }
    
    private func encipherChar(char: Character, shiftBy: Int, base: Character) -> Character {
        let start = String(base).unicodeScalars
        
        let value = start[start.startIndex].value
        
        let index = (Int(value) + shiftBy) % 26
        
        return Character(UnicodeScalar(index)!)
    }
    
}


// MARK: - vigenère
struct Vigenere: Cryptography {
    var name = "Enigma"
    var defaultKey = "default key"
    
    func encrypt(from text: String, key: String) -> String? {
        guard let shift = Int(key) else {
            return nil
        }
        
        let newCharacters = text.characters.map { ch -> Character in
            let res: Character
            switch ch {
            case "a"..."z": res = encipherChar(char: ch, shiftBy: shift, base: "a")
            case "A"..."Z": res = encipherChar(char: ch, shiftBy: shift, base: "A")
            default: res = ch
            }
            return res
        }
        
        return String(newCharacters)
    }
    
    func decrypt(from text: String, key: String) -> String? {
        guard let newKey = key.reversedIntString() else {
            return nil
        }
        
        return encrypt(from: text, key: newKey)
    }
    
    private func encipherChar(char: Character, shiftBy: Int, base: Character) -> Character {
        let start = String(base).unicodeScalars
        
        let value = start[start.startIndex].value
        
        let index = (Int(value) + shiftBy) % 26
        
        return Character(UnicodeScalar(index)!)
    }

}



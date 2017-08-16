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

extension Cryptography {
    fileprivate func asciiIndex(ofChar char: Character) -> UInt32 {
        let unicodeScalars = String(char).unicodeScalars
        
        return unicodeScalars[unicodeScalars.startIndex].value
    }
    
    fileprivate func encipherChar(char: Character, shiftBy shift: Int32, base: Character) -> Character {
        let baseIndex = asciiIndex(ofChar: base)
        let charIndex = asciiIndex(ofChar: char)
        let resIndex = baseIndex + UInt32((Int32(charIndex) - Int32(baseIndex) + shift + 26) % 26)
        
        return Character(UnicodeScalar(resIndex)!)
    }
    
    fileprivate func shiftOffset(ofChar char: Character) -> Int32 {
        let start: Character
        switch char {
        case "a"..."z": start = "a"
        case "A"..."Z": start = "A"
        default: start = char
        }
        return Int32(asciiIndex(ofChar: char) - asciiIndex(ofChar: start))
    }
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


// MARK: - vigenère
struct Vigenere: Cryptography {
    var name = "vigenère Cipher"
    var defaultKey = "SESAME"
    
    func cipherText(from text: String, key: String, encrypt: Bool) -> String? {
        var newCharacters = [Character]()
        
        text.characters.enumerated().forEach { (index, ch) in
            
            let keyChar = getKeyChar(fromKey: key, index: index)
        
            let shift: Int32
            if encrypt {
                shift = shiftOffset(ofChar: keyChar)
            } else {
                shift = -shiftOffset(ofChar: keyChar)
            }
            
            let cipherChar: Character
            switch ch {
            case "a"..."z": cipherChar = encipherChar(char: ch, shiftBy: shift, base: "a")
            case "A"..."Z": cipherChar = encipherChar(char: ch, shiftBy: shift, base: "A")
            default: cipherChar = ch
            }
            
            newCharacters.append(cipherChar)
        }
        
        return String(newCharacters)
    }
    
    private func getKeyChar(fromKey key: String, index: Int) -> Character {
        let offset = index % key.characters.count
        let index = key.index(key.startIndex, offsetBy: offset)
        let keyChar = key[index]
        
        return keyChar
    }
    
    func encrypt(from text: String, key: String) -> String? {
        return cipherText(from: text, key: key, encrypt: true)
    }
    
    func decrypt(from text: String, key: String) -> String? {
        return cipherText(from: text, key: key, encrypt: false)
    }
}

// MARK: - Enigma
struct Enigma: Cryptography {
    var name = "Enigma"
    var defaultKey = "default key"
    
    func encrypt(from text: String, key: String) -> String? {
        return nil
    }
    
    func decrypt(from text: String, key: String) -> String? {
        return nil
    }
    
}





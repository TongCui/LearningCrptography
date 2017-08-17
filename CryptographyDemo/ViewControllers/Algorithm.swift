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
    var defaultKey = "TODO: later"
    
    func encrypt(from text: String, key: String) -> String? {
        
        var enigmaMachine = EnigmaMachine()
        
        var newCharacters = [Character]()
        
        text.characters.enumerated().forEach { (index, ch) in
            
            let cipherChar: Character
            switch ch {
            case "A"..."Z": cipherChar = encipherChar(char: ch, enigmaMachine: enigmaMachine)
            default: cipherChar = ch
            }
            
            enigmaMachine.moveRotors()
            
            newCharacters.append(cipherChar)
        }
        
        return String(newCharacters)
    }
    
    private func encipherChar(char: Character, enigmaMachine: EnigmaMachine) -> Character {
        
        let charAsciiIndex = asciiIndex(ofChar: char)
        let letterAAsciiIndex = asciiIndex(ofChar: "A")
        let plaintextIndex = Int(charAsciiIndex - letterAAsciiIndex)
        let ciphertextIndex = enigmaMachine.cipherIndex(fromIndex: plaintextIndex)
        let cipherAsciiIndex = UInt32(ciphertextIndex) + letterAAsciiIndex
        
        return Character(UnicodeScalar(cipherAsciiIndex)!)
    }
    
    func decrypt(from text: String, key: String) -> String? {
        return encrypt(from:text, key: key)
    }
}

struct EnigmaMachine {
    //  [Ruby] > (0...26).to_a.shuffle
    let originalRotor1 =  [3, 17, 21, 2, 23, 20, 19, 9, 11, 15, 24, 25, 0, 14, 10, 6, 7, 18, 12, 8, 4, 13, 1, 22, 5, 16]
    let originalRotor2 = [21, 0, 14, 25, 9, 15, 3, 24, 23, 20, 8, 4, 2, 5, 19, 13, 7, 10, 18, 17, 12, 16, 6, 22, 1, 11]
    let originalRotor3 = [4, 19, 0, 23, 2, 13, 21, 18, 12, 17, 7, 10, 20, 6, 24, 5, 14, 22, 25, 1, 3, 9, 15, 11, 8, 16]
    
    //  [Ruby] > (0...26).to_a.shuffle.each_slice(2).to_a
    let reflector = [[1, 9], [10, 5], [6, 3], [25, 20], [7, 24], [13, 18], [8, 12], [0, 15], [21, 19], [11, 14], [4, 23], [16, 2], [17, 22]]

    private var lettersCount = 0
    
    mutating func moveRotors() {
        lettersCount += 1
    }
    
    func cipherIndex(fromIndex index: Int) -> Int {
        var res: Int
        //  3 rotors
        let rotor1Map = rotorMap(offset: rotorOffsets(steps: lettersCount).roter1Offset, originalRotor: originalRotor1)
        rotor1Map.printEnigamaRotor()
        res = rotor1Map[index]!
        
        let rotor2Map = rotorMap(offset: rotorOffsets(steps: lettersCount).roter2Offset, originalRotor: originalRotor2)
        rotor2Map.printEnigamaRotor()
        res = rotor2Map[res]!
        
        let rotor3Map = rotorMap(offset: rotorOffsets(steps: lettersCount).roter3Offset, originalRotor: originalRotor3)
        rotor3Map.printEnigamaRotor()
        res = rotor3Map[res]!
        
        //  reflector
        res = reflectorIndex(fromIndex: res)
        
        //  3 rotors
        res = flip(rotor3Map)[res]!
        res = flip(rotor2Map)[res]!
        res = flip(rotor1Map)[res]!
        
        return res
    }
    
    private func reflectorIndex(fromIndex index: Int) -> Int {
        let res = reflector.first { $0.contains(index) }?.first { $0 != index }
        
        return res!
    }
    
    private func rotorOffsets(steps: Int) -> (roter1Offset: Int, roter2Offset: Int, roter3Offset: Int) {
        let first = steps.divMod(other: 26)
        let second = first.quotient.divMod(other: 26)
        
        return (first.modulus, second.modulus, second.quotient)
    }
    
    private func rotorMap(offset: Int, originalRotor: [Int]) -> [Int: Int] {
        var res = [Int: Int]()
        (0..<26).forEach { idx in
            let targetIndex = (offset + idx + 26) % 26
            res[idx] = originalRotor[targetIndex]
        }
        return res
    }
    
}





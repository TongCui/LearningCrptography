//
//  CryptographyViewController.swift
//  CryptographyDemo
//
//  Created by tcui on 14/8/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CryptographyViewController: BaseViewController {
    
    var cryptography: Cryptography?

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var keyTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        
        //  Default Key
        keyTextField.text = cryptography?.defaultKey
        
        //  Upper Case
        topTextField.rx.text
            .map { $0?.uppercased() }
            .bind(to: topTextField.rx.text)
            .disposed(by: disposeBag)

        bottomTextField.rx.text
            .map { $0?.uppercased() }
            .bind(to: bottomTextField.rx.text)
            .disposed(by: disposeBag)

        
        //  Bind Top and Bottom Textfields
        let topTextObservable = topTextField.rx.text.orEmpty.throttle(0.5, scheduler: MainScheduler.instance)
        let keyTextObservable = keyTextField.rx.text.orEmpty.throttle(0.5, scheduler: MainScheduler.instance)
        let segmentedControlObservable = segmentedControl.rx.value
        
        Observable.combineLatest(topTextObservable, keyTextObservable, segmentedControlObservable) { [weak self] topText, keyText, segmentedIndex in
            let bottomText: String?
            
            switch segmentedIndex {
            case 0: bottomText = self?.cryptography?.encrypt(from: topText, key: keyText)
            case 1: bottomText = self?.cryptography?.decrypt(from: topText, key: keyText)
            default: bottomText = "Error"
            }
            
            return bottomText ?? ""
            }
            .bind(to: bottomTextField.rx.text)
            .disposed(by: disposeBag)
        
    
        //  Segmented Control
        segmentedControl.rx.value
            .map { $0 == 0 ? "Plaintext" : "Chipertext" }
            .bind(to: topLabel.rx.text)
            .disposed(by: disposeBag)
        
        segmentedControl.rx.value
            .map { $0 == 1 ? "Plaintext" : "Chipertext" }
            .bind(to: bottomLabel.rx.text)
            .disposed(by: disposeBag)

        //  Tap View to hide keyboard
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
    }
    
    private func getPlaintext(from chiperText: String) -> String {
        return "plaintext \(chiperText)"
    }
    
    private func getChipertext(from plainText: String) -> String {
        return "chipertext \(plainText)"
    }
    
    private func changeKey() {
        print("TODO: Change Key")
    }

}

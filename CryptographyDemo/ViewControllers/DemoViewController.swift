//
//  DemoViewController.swift
//  CryptographyDemo
//
//  Created by tcui on 14/8/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

import UIKit

class DemoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let toVC = segue.destination as? CryptographyViewController,
            let segueIdentifier = segue.identifier {
            toVC.title = segueIdentifier.capitalized
            toVC.cryptography = Algorithm(segueIdentifier: segueIdentifier)?.cryptography
        }
    }

}

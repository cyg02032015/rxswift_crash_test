//
//  ViewController.swift
//  crash_test
//
//  Created by adam on 2022/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func test(_ sender: Any) {
        test()
    }
    
    func test() {
        let vc = TestViewController()
        present(vc, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak vc] in
                vc?.dismiss(animated: true, completion: { [weak self] in
                    self?.test()
                })
            }
        }
    }
}

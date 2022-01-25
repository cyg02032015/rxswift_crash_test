//
//  ViewController.swift
//  crash_test
//
//  Created by adam on 2022/1/21.
//

import UIKit

class ViewController: UIViewController {
    var button = UIButton()
    var time: Int = 0
    var isFirst: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let screen = UIScreen.main.bounds
        let wh: CGFloat = 50
        button.frame = CGRect(origin: CGPoint(x: screen.width/2 - wh/2, y: screen.height/2 - wh/2), size: CGSize(width: wh, height: wh))
        button.setTitle("B", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(test(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirst {
            isFirst = false
            test()
        }
    }
    
    @IBAction func test(_ sender: Any) {
        time = 0
        test()
    }
    
    func test() {
        let vc = TestViewController()
        present(vc, animated: true) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak vc] in
//                vc?.dismiss(animated: true, completion: {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
//                        self?.test()
//                    }
//                })
//            }
        }
    }
}

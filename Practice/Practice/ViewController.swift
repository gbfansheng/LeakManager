//
//  ViewController.swift
//  Practice
//
//  Created by Shenglin Fan on 2019/12/1.
//  Copyright © 2019 Shenglin Fan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

    let myView = UIView()
    let myLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("click", for: .normal)
        button.frame = CGRect.init(x: 100, y: 500, width: 100, height: 50)
        button.addTarget(self, action: #selector(move), for: .touchUpInside)
        self.view.addSubview(button)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func move() {
        
        
        let vc = SampleViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}


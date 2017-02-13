//
//  WBCompViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBCompViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.yellow

        navigationItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "退出", target: self, action: #selector(close))
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

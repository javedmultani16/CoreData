//
//  secondViewController.swift
//  tableViewsDemo
//
//  Copyright © 2018 MyCompany. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {

   var strName = ""
    @IBOutlet weak var labelFruit: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelFruit.text = strName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

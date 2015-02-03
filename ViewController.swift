//
//  ViewController.swift
//  3wbar
//
//  Copyright (c) 2015 kent. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGame(sender:UIButton){
        let alertView = UIAlertView();
        alertView.title = "开始";
        alertView.message = "游戏即将开始, Are You Ready?";
        alertView.addButtonWithTitle("GO");
        alertView.show();

        alertView.delegate = self;
    }
    //func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        self.presentViewController(MainTabViewController(), animated: true, completion: nil);
    }
}


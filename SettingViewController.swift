//
//  SettingViewController.swift
//  3wbar
//
//  Created by 盘健 on 15/1/2星期五.
//  Copyright (c) 2015年 kent. All rights reserved.
//

import UIKit

class SettingViewController:UIViewController,UITextFieldDelegate {
    
    var mainview: MainViewController;
    var textNum: UITextField!;
    var segDimension: UISegmentedControl!;
    
    init(mainview: MainViewController){
        self.mainview = mainview;
        super.init(nibName:nil, bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad();
        self.view.backgroundColor = UIColor.whiteColor();
        setupController();
        
    }
    
    func dimensionChanged(sender: SettingViewController){
        var segVals = [3,4,5];
        
        mainview.wd = segVals[segDimension.selectedSegmentIndex];
        
        mainview.resetBtn();
    }
    
    func numChanged(){
        println("num changed");

        
    }
    
    func setupController(){
        var cv = ControllView();
        textNum = cv.createText(String(mainview.maxnumber), action: Selector("numChanged"),sender: self);
        textNum.frame.origin.x = 50;
        textNum.frame.origin.y = 100;
        textNum.frame.size.width = 200;
        textNum.returnKeyType = UIReturnKeyType.Done;
        self.view.addSubview(textNum);
        
        segDimension = cv.createSeg(["3x3", "4x4", "5x5"], action: Selector("dimensionChanged:"),sender:self);
        segDimension.frame.origin.x = 50;
        segDimension.frame.origin.y = 200;
        segDimension.frame.size.width = 200;
        self.view.addSubview(segDimension);

        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder();
        println("Number changed");
        
        if(textField.text.toInt() != mainview.maxnumber){
            var num = textField.text.toInt();
            mainview.maxnumber = num!;
            
        }
        return true;
    }
}
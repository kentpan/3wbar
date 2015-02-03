//
//  MainTabViewController.swift
//  3wbar
//
//  Created by 盘健 on 15/1/2星期五.
//  Copyright (c) 2015年 kent. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController
{
    override init()
    {
        super.init(nibName: nil, bundle: nil);
        
        var viewMain = MainViewController();
        
        viewMain.title = "2048";
        
        var viewSetting = SettingViewController(mainview: viewMain);
        
        viewSetting.title = "设置";
        
        
        self.viewControllers = [viewMain, viewSetting];
        
        
        self.selectedIndex = 0;//self.viewControllers!.count-1;

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
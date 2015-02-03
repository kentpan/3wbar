//
//  MainViewController.swift
//  3wbar
//
//  Created by 盘健 on 15/1/2星期五.
//  Copyright (c) 2015年 kent. All rights reserved.
//

import UIKit

enum Animat2048Type{
    case None //无动画
    case New  //新出现动画
    case Merge //合并动画
}

class MainViewController:UIViewController
{
    var wd:Int = 4{
        didSet{
            data.wd = wd;
        }
    };
    var maxnumber:Int = 2048{
        didSet{
            data.maxnumber = maxnumber;
        }
    };
    var autoMargin = [
        3: CGFloat(80),
        4: CGFloat(50),
        5: CGFloat(25)
    ];
    var w:CGFloat  = 50;
    var pd:CGFloat = 6;
    var bgs: Array<UIView>;
    //var data: GameModel!;
    //var data: NSObject;
    
    var labels: Dictionary<NSIndexPath,NumberView>;
    var values: Dictionary<NSIndexPath,Int>;
    
    var score: ScoreView!;
    var bestScore: BestScoreView!;
    var data: GameModel!;
    override init()
    {
        self.bgs    = Array<UIView>();
        self.labels = Dictionary();
        //self.wd     = wd;
        self.values = Dictionary();
        
        super.init(nibName: nil, bundle: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setBackground();
        setBtn();
        setSwipeRegion();
        setupScoreLabel();
        self.data = GameModel(wd:wd,maxnumber: maxnumber,score:score,bestScore:bestScore);

        
        
        for i in 0 ... 1 {
            getRndNumber();
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScoreLabel(){
        score = ScoreView();
        score.frame.origin.x = 50;
        score.frame.origin.y = 80;
        score.changeScore(value: 0);
        self.view.addSubview(score);
        
        bestScore = BestScoreView();
        bestScore.frame.origin.x = 170;
        bestScore.frame.origin.y = 80;
        bestScore.changeScore(value: 0);
        self.view.addSubview(bestScore);

        
    }
    
    func setSwipeRegion(){
        
        let swipeUp = UISwipeGestureRecognizer(target:self,action:"handleSwipeGesture:");
        swipeUp.numberOfTouchesRequired = 1;
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up;
        self.view.addGestureRecognizer(swipeUp);
        
        let swipeDown = UISwipeGestureRecognizer(target:self,action:"handleSwipeGesture:");
        swipeDown.numberOfTouchesRequired = 1;
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down;
        self.view.addGestureRecognizer(swipeDown);
        
        let swipeLeft = UISwipeGestureRecognizer(target:self,action:"handleSwipeGesture:");
        swipeLeft.numberOfTouchesRequired = 1;
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left;
        self.view.addGestureRecognizer(swipeLeft);
        
        let swipeRight = UISwipeGestureRecognizer(target:self,action:"handleSwipeGesture:");
        swipeRight.numberOfTouchesRequired = 1;
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right;
        self.view.addGestureRecognizer(swipeRight);
        
    }
    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        //划动的方向
        var direction = sender.direction
       // var total:Int = wd * wd - 1;
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.Left:
            println("Left");
            data.reflowLeft();
            data.mergeLeft();
            data.reflowLeft();
            break;
        case UISwipeGestureRecognizerDirection.Right:
            println("Right");
            data.reflowRight();
            data.mergeRight();
            data.reflowRight();
            break;
        case UISwipeGestureRecognizerDirection.Up:
            println("Up");
            data.reflowUP();
            
            data.mergeUp();
            data.reflowUP();
            break;
        case UISwipeGestureRecognizerDirection.Down:
            println("Down");
            data.reflowDown();
            
            data.mergeDown();
            data.reflowDown();
            break;
        default:
            break;
        }
        println("=================");
        printNums(data.nums);
        println("=================");
        //resetUI();
        initUI()
        getRndNumber();


       
    }
    
    func printNums(nums:Array<Int>){
        var count = nums.count;
        for var i=0;i<count;i++ {
            if (i+1) % Int(wd) == 0 {
                println(nums[i]);
            }else{
                print("\(nums[i])\t");
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        resetBtn();
    }
    
    func initUI(){
        var index: Int;
        var key: NSIndexPath;
        var number: NumberView;//tile
        var value: Int; //tileval
        
        if(data.isSuccess()){
           // resetUI();
            var alertView = UIAlertView();
            alertView.title = "恭喜你通关";
            alertView.message = "嘿哈~~~你真棒棒!!!";
            alertView.addButtonWithTitle("确定");
            alertView.show();
            alertView.delegate = self;
            return;
        }
        
        for i in 0 ... wd-1 {
            for j in 0 ... wd-1 {
                var index = i*wd + j;
                key = NSIndexPath(forRow:i, inSection: j);
                //界面没有值,模型有值
                if(data.nums[index] > 0 && values.indexForKey(key) == nil){
                    insertNumber((i,j), val: data.reNums[index],aType:Animat2048Type.Merge);
                }
                //界面有值,模型没值
                if(data.nums[index] == 0 && values.indexForKey(key) != nil){
                    number = labels[key]!;
                    number.removeFromSuperview();
                    labels.removeValueForKey(key);
                    values.removeValueForKey(key);
                }
                //界面有值, 模型有值
                if(data.nums[index] > 0 && values.indexForKey(key) != nil){
                    value = values[key]!;
                    if(value != data.nums[index]){
                        number = labels[key]!;
                        number.removeFromSuperview();
                    
                        labels.removeValueForKey(key);
                        values.removeValueForKey(key);
                        insertNumber((i,j), val: data.reNums[index],aType:Animat2048Type.Merge);
                    }
                }
                /*if(data.nums[index] != 0){
                    insertNumber((i,j), val: data.reNums[index]);
                }*/
            }
        }
    }
    
    
    func resetUI(){
        for(key,val) in labels{
            val.removeFromSuperview();
        }
        
        labels.removeAll(keepCapacity: true);
        
        values.removeAll(keepCapacity: true);
        
        for bg in bgs {
            bg.removeFromSuperview();
        }
        
        data.initNumber();
        
        
        
        setBackground();
        
        score.changeScore(value: 0);
        
       // data.nums.removeAll(keepCapacity: true);
        
       // data.reNums.removeAll(keepCapacity: true);
        
        
        for i in 0 ... 1 {
            getRndNumber();
        }
        
        //bestScore.changeScore(value: 0);

        
    }
    
    func removeKey(key:NSIndexPath){
        var label = labels[key]!;
        var value = values[key];
        
        label.removeFromSuperview();
        
        labels.removeValueForKey(key);

        values.removeValueForKey(key);
    }
    
    func setBtn(){
        var ctrl = ControllView();
        var btnRest = ctrl.createBtn("重置", action: Selector("resetBtn"), sender: self);
        btnRest.frame.origin.x = 50;
        btnRest.frame.origin.y = 450;
        self.view.addSubview(btnRest);
        
        var btnGo = ctrl.createBtn("新设", action: Selector("goBtn"), sender: self);
        btnGo.frame.origin.x = 170;
        btnGo.frame.origin.y = 450;
        self.view.addSubview(btnGo);

        
    }
    
    func resetBtn(){
        println("重置");
        data.initNumber();
        resetUI();
    }
    
    func goBtn(){
        println("新设");
        getRndNumber();
    }
    
    func setBackground(){
        var x:CGFloat = autoMargin[wd]!;
        var y:CGFloat = 150;
        
        for i in 0...wd-1{
            y = 150;
            for j in 0...wd-1{
                var bg = UIView(frame: CGRectMake(x, y, w, w));
                bg.backgroundColor = UIColor.darkGrayColor();
                self.view.addSubview(bg);
                bgs.append(bg);
                y += pd + w;
            }
            x += pd + w;
        }
    }
    
    // 生成初始随机数字2,4
    func getRndNumber(){
        let rnd = Int(arc4random_uniform(10));
        var seed:Int = 2;
        if(rnd == 1){
            seed = 4;
        }
        let col = Int(arc4random_uniform(UInt32(wd)));
        let row = Int(arc4random_uniform(UInt32(wd)));
        println(row,col,"\(wd)---------");
        if(data.checkFull() == true){
            println("位置满了");
            
            var alertView = UIAlertView();
            alertView.title = "Game Over";
            alertView.message = "啊哦~~~你完蛋蛋了!!!";
            alertView.addButtonWithTitle("确定");
            alertView.show();
            alertView.delegate = self;
            return;
        }
        
        if(data.setPos(row, col: col, val: seed) == false){
            getRndNumber();
            return;
        }
        //println("位置:[cols]");

        insertNumber((row,col),val:seed,aType:Animat2048Type.New);
    }
    
    func insertNumber(pos:(Int,Int),val:Int,aType:Animat2048Type){
        let (row,col) = pos;
        var _width = autoMargin[wd]!;
        let x = _width + CGFloat(col) * (w + pd);
        let y = 150 + CGFloat(row) * (w + pd);
        
        let number = NumberView(pos: CGPointMake(x, y), w: w, value: val);
        //绑定到视图
        self.view.addSubview(number);
        self.view.bringSubviewToFront(number);
        
        var index = NSIndexPath(forRow: row,inSection: col);
        labels[index] = number;
        values[index] = val;
        
        if(aType == Animat2048Type.None){
            return;
        }else if(aType == Animat2048Type.New){
            number.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1));
        }else if(aType == Animat2048Type.Merge){
            number.layer.setAffineTransform(CGAffineTransformMakeScale(0.8, 0.8));
        }
        
        
        //添加动画
        number.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1));
        
        UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.TransitionNone, animations: {
                ()-> Void in
                number.layer.setAffineTransform(CGAffineTransformMakeScale(1,1));
            
            
            },
            completion:{
                (finished:Bool) -> Void in
                UIView.animateWithDuration(0.08, animations: {
                    () -> Void in
                    number.layer.setAffineTransform(CGAffineTransformIdentity);
                
                })
            
            })

        
    }
    
}

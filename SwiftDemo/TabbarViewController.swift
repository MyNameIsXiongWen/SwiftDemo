//
//  TabbarViewController.swift
//  SwiftDemo
//
//  Created by 熊文 on 2018/4/5.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTabbarController()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configTabbarController() {
        let oneC = OneViewController()
        let item1 : UITabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "onenormal"), selectedImage: UIImage(named: "oneselected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        item1.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], for: .selected);
        oneC.tabBarItem = item1
        let oneNav = NavgationViewController.init(rootViewController: oneC)
        
        let twoC = TwoViewController()
        let item2 : UITabBarItem = UITabBarItem(title: "订单", image: UIImage(named: "twonormal"), selectedImage: UIImage(named:"twoselected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        item2.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], for: .selected);
        twoC.tabBarItem = item2;
        let twoNav = NavgationViewController.init(rootViewController: twoC)
        
        let threeC = ThreeViewController()
        let item3 : UITabBarItem = UITabBarItem(title: "设置", image: UIImage(named: "threenormal"), selectedImage: UIImage(named:"threeselected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        item3.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], for: .selected);
        threeC.tabBarItem = item3;
        let threeNav = NavgationViewController.init(rootViewController: threeC)
        
        let tabbarArray = [oneNav,twoNav,threeNav]
        self.viewControllers = tabbarArray;
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

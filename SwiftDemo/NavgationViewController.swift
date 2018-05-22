//
//  NavgationViewController.swift
//  SwiftDemo
//
//  Created by 熊文 on 2018/4/7.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

class NavgationViewController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = UINavigationBar.appearance()
        navBar.backgroundColor = UIColor.white
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18.0)]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.setImage(UIImage.init(named: "back_black"), for: UIControlState.normal)
            btn.bounds = CGRect.init(x: 0, y: 0, width: 40, height: 30)
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15)
            btn.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            btn.addTarget(self, action: #selector(NavgationViewController.popSelector), for: UIControlEvents.touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn)
        }
        super.pushViewController(viewController, animated: animated)
        
        if self.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    @objc func popSelector() -> Void {
        self .popViewController(animated: true)
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

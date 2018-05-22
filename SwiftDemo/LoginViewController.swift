//
//  LoginViewController.swift
//  SwiftDemo
//
//  Created by jiazhuo1 on 2018/4/20.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phontTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        let dic = ["mobile":phontTextField.text!, "password":pwdTextField.text!, "typeid":0] as [String : Any]
        NetWorkManager.sharedNetWorkManager.NetWorkRequest(requestType: .POST, url: "\(HttpURLString)Member/login.html", params: dic, success: { (responseObject) in
            print(responseObject!)
            if responseObject?["errcode"] as? Int == 1 {
                UserDefaults.standard.set(1, forKey: "LogIn")
                let rootC = TabbarViewController()
//                let nav = UINavigationController.init(rootViewController: rootC)
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = rootC
                return
            }
            print("登录失败")
        }) { (error) in
            print(error!)
        }
        
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

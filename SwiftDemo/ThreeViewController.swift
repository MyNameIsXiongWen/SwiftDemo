//
//  ThreeViewController.swift
//  SwiftDemo
//
//  Created by 熊文 on 2018/4/5.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

class ThreeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate var tableview:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "设置"
        configTableView()
        // Do any additional setup after loading the view.
    }
    
    func configTableView() -> Void {
        tableview = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-49-64), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view.addSubview(tableview)
        swift_setScrollViewContentInsetAdjustmentNever(scrollView: tableview)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "退出"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logout()
    }
    
    private func logout() {
        NetWorkManager.sharedNetWorkManager.NetWorkRequest(requestType: .GET, url: "\(HttpURLString)Member/logout", params: [:], success: { (responseObject) in
            print(responseObject!)
            if responseObject?["errcode"] as? Int == 1 {
                UserDefaults.standard.set(0, forKey: "LogIn")
                let loginC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                let nav = UINavigationController.init(rootViewController: loginC)
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = nav
            }
        }) { (error) in
            print(error!)
        }
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

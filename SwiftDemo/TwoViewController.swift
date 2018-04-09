//
//  TwoViewController.swift
//  SwiftDemo
//
//  Created by 熊文 on 2018/4/5.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

let TableViewIdentifier = "tableviewIdentifier"

class TwoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "订单"
        configUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configUI() -> Void {
        let tableView: UITableView = UITableView.init(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        swift_setScrollViewContentInsetAdjustmentNever(scrollView: tableView)
        tableView.register(UINib.init(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: TableViewIdentifier)
        self.view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifier, for: indexPath) as! OrderTableViewCell
        
        return tableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let alert = UIAlertController(title: "title", message: "第\(indexPath.section)组，第\(indexPath.row)个msg", preferredStyle: UIAlertControllerStyle.alert)
//        self.present(alert, animated: true, completion: nil)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
//            self.presentedViewController?.dismiss(animated: true, completion: nil)
//        }
//        
        let orderDetailC = OrderDetailViewController()
        self.navigationController?.pushViewController(orderDetailC, animated: true)
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

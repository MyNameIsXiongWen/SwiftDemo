//
//  OneViewController.swift
//  SwiftDemo
//
//  Created by 熊文 on 2018/4/5.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

let MainTableViewCellIdentifier = "mainTableViewCellIdentifier"

class OneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate {

    fileprivate var tableview:UITableView!
    fileprivate var adtableview:UITableView!
    var dataArray = NSMutableArray()
    var viewModel = LiveViewModel.init()
    var cycleScrollView = SDCycleScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "首页"
        configTableView()
        // Do any additional setup after loading the view.
        refreshHead()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configTableView() -> Void {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 345))
        headerView.backgroundColor = UIColor.white
        
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        footerView.backgroundColor = UIColor.clear
        let label = UILabel.init(frame: footerView.bounds)
        label.text = "然后，就没有然后了～"
        label.textColor = UIColor.init(fromHexString: "444444")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11.0)
        footerView.addSubview(label)
        
        cycleScrollView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 175), imageURLStringsGroup: viewModel.bannerArray as! [Any])
        cycleScrollView.delegate = self
        cycleScrollView.infiniteLoop = true
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        headerView.addSubview(cycleScrollView)
        
        let textArray = ["主播基地","兼职空间","发布任务","每日打卡"]
        let imgArray = ["home_live_base","home_parttime","home_publish","home_daily_clock"]
        for i:Int in 0..<textArray.count {
            let v = UIView.init(frame: CGRect.init(x: CGFloat(i) * SCREEN_WIDTH/4, y: 175, width: SCREEN_WIDTH/4, height: 100))
            v.backgroundColor = UIColor.white
            let btn = UIButton.init(frame: CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH/4, height: 60))
            btn.setImage(UIImage.init(named: imgArray[i]), for: .normal)
            btn.tag = i
            btn.addTarget(self, action: #selector(pushController(btn:)), for: .touchUpInside)
            let lab = UILabel.init(frame: CGRect.init(x: 0, y: 75, width: SCREEN_WIDTH/4, height: 15))
            lab.text = textArray[i]
            lab.textColor = UIColor.init(fromHexString: "333333")
            lab.font = UIFont.systemFont(ofSize: 13.0)
            lab.textAlignment = .center
            v.addSubview(btn)
            v.addSubview(lab)
            headerView.addSubview(v)
        }
        
        adtableview = UITableView.init(frame: CGRect.init(x: 0, y: 295, width: SCREEN_WIDTH, height: 35), style: .plain)
        adtableview.isScrollEnabled = false
        adtableview.delegate = self
        adtableview.dataSource = self
        adtableview.tag = 111
        adtableview.separatorStyle = .none
        headerView.addSubview(adtableview)
        
        tableview = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-49-64), style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tag = 999
        tableview.tableFooterView = UIView()
        tableview.estimatedSectionHeaderHeight = 0;
        tableview.estimatedSectionFooterHeight = 0;
        tableview.register(UINib.init(nibName: "LiveIntelligentTableViewCell", bundle: nil), forCellReuseIdentifier: MainTableViewCellIdentifier)
        tableview.mj_header = MJRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshHead))
        tableview.tableHeaderView = headerView
        tableview.tableFooterView = footerView
        view.addSubview(tableview)
        swift_setScrollViewContentInsetAdjustmentNever(scrollView: tableview)
        swift_setScrollViewContentInsetAdjustmentNever(scrollView: adtableview)
    }

    @objc func refreshHead() -> Void {
        viewModel.liveRequestHeaderData {
            self.cycleScrollView.imageURLStringsGroup = self.viewModel.bannerArray as! [Any]?
            self.tableview.reloadData()
            self.adtableview.reloadData()
        }
        tableview.mj_header.endRefreshing()
    }
    
    @objc func pushController(btn:UIButton) -> Void {
        if btn.tag == 0 {
            let viewCon = LiveShowViewController.init(nibName: "LiveShowViewController", bundle: nil)
            navigationController?.pushViewController(viewCon, animated: true)
        }
        else if btn.tag == 1 {
            let viewCon = LiveCreateViewController.init(nibName: "LiveCreateViewController", bundle: nil)
            navigationController?.pushViewController(viewCon, animated: true)
        }
        else if btn.tag == 2 {
            
        }
        else if btn.tag == 3 {
            
        }
    }
    
//////////////////////TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 111 {
            return 1
        }
        if viewModel.anchorArray.count>0 {
            return viewModel.intelligentArray.count + 1
        }
        return viewModel.intelligentArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 111 {
            return viewModel.informationArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 111 {
            return 17.5
        }
        if indexPath.section == 0 {
            if viewModel.anchorArray.count > 0 {
                return 135+55
            }
            return 55;
        }
        let model = viewModel.intelligentArray.object(at: indexPath.section-1) as! ContentModel
        if model.data.count > 0 {
            return 180+55
        }
        return 55;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 111 {
            return 0.1
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 111 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell_id")
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell_id")
            }
            cell?.selectionStyle = .none
            let model:NewsModel = viewModel.informationArray.object(at: indexPath.row) as! NewsModel
            cell?.textLabel?.text = model.title
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 11.0)
            cell?.textLabel?.textColor = UIColor.init(fromHexString: "444444")
            if Int(model.cat_id) == 1 {
                cell?.imageView?.image = UIImage.init(named: "home_news")
            }
            else {
                cell?.imageView?.image = UIImage.init(named: "home_hr")
            }
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCellIdentifier, for: indexPath) as! LiveIntelligentTableViewCell
            cell.selectionStyle = .none
            var dataArray = NSMutableArray()
            var height = 0
            if indexPath.section == 0 {
                cell.leftTitleLabel.text = "热门主播"
                cell.type = .ContentTypeLive
                dataArray = viewModel.anchorArray
                height = 135
            }
            else {
                let model:ContentModel = viewModel.intelligentArray.object(at: indexPath.section-1) as! ContentModel
                cell.leftTitleLabel.text = model.name
                cell.type = .ContentTypeIntelligent
                dataArray = model.data
                height = 180
            }
            if dataArray.count > 6 {
                cell.contentScrollView.contentSize = CGSize.init(width: 145*6+100+15, height: height)
            }
            else {
                cell.contentScrollView.contentSize = CGSize.init(width: 145*dataArray.count+15, height: height)
            }
            cell.createScrollView(intelligentArray: dataArray)
            cell.rightAllBtn.tag = indexPath.section
            cell.rightAllBtn .addTarget(self, action: #selector(clickAll(btn:)), for: .touchUpInside)
            cell.clickAllBlock = {
                self.clickAll(btn: cell.rightAllBtn)
            }
            cell.clickInformationBlock = {(index:NSInteger, type:ContentType) -> Void in
                self.clickInformation(array: dataArray, index: index, type: type)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 111 {
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    @objc func clickAll(btn:UIButton) -> Void {
        if btn.tag == 0 {
            let viewCon = LiveShowViewController.init(nibName: "LiveShowViewController", bundle: nil)
            navigationController?.pushViewController(viewCon, animated: true)
        }
        else {
            
        }
    }
    
    func clickInformation(array:NSMutableArray,index:NSInteger, type:ContentType) -> Void {
//        let model:IntelligentModel = array.object(at: index) as! IntelligentModel
        if type == .ContentTypeLive {
            
        }
        else {
            
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

//
//  LiveShowViewController.swift
//  SwiftDemo
//
//  Created by jiazhuo1 on 2018/5/22.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

let LiveCollectionViewCellIdentifier = "liveCollectionViewCellIdentifier"
class LiveShowViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var filtButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentPage:Int = 1
    var orderby:String = ""
    var type:String = ""
    var exp:String = ""
    var anchor_type:String = ""
    var distanceType : Int = 0
    var ageType : Int = 0
    var filterView : LiveFilterView?
    var dataArray = NSMutableArray()
    var filterArray = NSMutableArray()
    var selectedIndexArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主播展示"
        configCollectionView()
        // Do any additional setup after loading the view.
        selectedIndexArray = [9999,9999,9999]
        filterArray = [["主播类型":["全部","电竞","电商","体育","教育","游戏","户外","其他"]],["直播经验":["全部","1年","2年","3年","4年以上"]], ["直播类型":["全部","全职","兼职"]]]
        refreshHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if filterView != nil {
            filterView?.dismiss()
            filterView = nil
        }
    }
    
    func configCollectionView() -> Void {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: (SCREEN_WIDTH - 10)/2, height: (SCREEN_WIDTH - 10)/2+45)
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib.init(nibName: "LiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: LiveCollectionViewCellIdentifier)
        collectionView.mj_header = MJRefreshHeader.init(refreshingBlock: {
            self.refreshHeader()
        })
        collectionView.mj_footer = MJRefreshFooter.init(refreshingBlock: {
            self.refreshFooter()
        })
    }
    
    private func getAnchorListRequest() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.show()
        var dic:[String:String] = ["page":"\(currentPage)"]
        if orderby.lengthOfBytes(using: .utf8) > 0 {
            dic.updateValue(orderby, forKey: "orderby")
        }
        if type.lengthOfBytes(using: .utf8) > 0 {
            dic.updateValue(type, forKey: "type")
        }
        if exp.lengthOfBytes(using: .utf8) > 0 {
            dic.updateValue(exp, forKey: "exp")
        }
        if anchor_type.lengthOfBytes(using: .utf8) > 0 {
            dic.updateValue(anchor_type, forKey: "anchor_type")
        }
        
        NetWorkManager.sharedNetWorkManager.NetWorkRequest(requestType: .POST, url: "\(HttpURLString)anchor/anchor_list", params: dic, success: { (responseObject) in
            SVProgressHUD.dismiss()
            if responseObject?["errcode"] as? Int == 1 {
                if self.currentPage == 1 {
                    self.dataArray = IntelligentModel.mj_objectArray(withKeyValuesArray: responseObject?["data"])
                }
                else {
                    self.dataArray.addObjects(from: IntelligentModel.mj_objectArray(withKeyValuesArray: responseObject?["data"]) as! [Any])
                }
                self.collectionView.reloadData()
            }
        }) { (error) in
            SVProgressHUD.dismiss()
            print(error!)
        }
    }
    
    @objc func refreshHeader() -> Void {
        currentPage = 1
        getAnchorListRequest()
        collectionView.mj_header.endRefreshing()
    }
    @objc func refreshFooter() -> Void {
        currentPage += 1
        getAnchorListRequest()
        collectionView.mj_footer.endRefreshing()
    }
    
//////////////////////CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveCollectionViewCellIdentifier, for: indexPath) as! LiveCollectionViewCell
        let model = dataArray[indexPath.row] as! IntelligentModel
        cell.photoImageView.sd_setImage(with: URL.init(string: model.photo), completed: nil)
        cell.ageLabel.text = model.age.appendingFormat("岁")
        cell.timeLabel.text = model.last_login
        cell.nameLabel.text = model.nickname
        if Int(model.sex) == 2 {
            cell.sexImageView.image = UIImage.init(named: "live_female")
            cell.ageLabel.textColor = UIColor.init(fromHexString: "f335a0")
        }
        else {
            cell.sexImageView.image = UIImage.init(named: "live_male")
            cell.ageLabel.textColor = UIColor.init(fromHexString: "5aa7f9")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 10)/2, height: (SCREEN_WIDTH - 10)/2+45)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(5, 0, 5, 0)
//    }

    @IBAction func clickTopConditionBtn(_ sender: Any) {
        let btn:UIButton = sender as! UIButton
        if btn.tag == 1 {
            if distanceType == 0 {
                distanceType = 1
                orderby = "4"
                btn.setImage(UIImage.init(named: "live_triangle_up"), for: .normal)
                btn.setTitleColor(UIColor.init(fromHexString: "457fea"), for: .normal)
            }
            else if distanceType == 1 {
                distanceType = 2
                orderby = "5"
                btn.setImage(UIImage.init(named: "live_triangle_down"), for: .normal)
                btn.setTitleColor(UIColor.init(fromHexString: "457fea"), for: .normal)
            }
            else if distanceType == 2 {
                distanceType = 0
                orderby = ""
                btn.setImage(UIImage.init(named: "live_triangle"), for: .normal)
                btn.setTitleColor(UIColor.init(fromHexString: "333333"), for: .normal)
            }
            ageType = 0
            ageButton.setImage(UIImage.init(named: "live_triangle"), for: .normal)
            ageButton.setTitleColor(UIColor.init(fromHexString: "333333"), for: .normal)
            refreshHeader()
        }
        else if btn.tag == 2 {
            if ageType == 0 {
                ageType = 1
                orderby = "3"
                btn.setImage(UIImage.init(named: "live_triangle_up"), for: .normal)
                btn.setTitleColor(UIColor.init(fromHexString: "457fea"), for: .normal)
            }
            else if ageType == 1 {
                ageType = 2
                orderby = "2"
                btn.setImage(UIImage.init(named: "live_triangle_down"), for: .normal)
                btn.setTitleColor(UIColor.init(fromHexString: "457fea"), for: .normal)
            }
            else if ageType == 2 {
                ageType = 0
                orderby = ""
                btn.setImage(UIImage.init(named: "live_triangle"), for: .normal)
                btn.setTitleColor(UIColor.init(fromHexString: "333333"), for: .normal)
            }
            distanceType = 0
            distanceButton.setImage(UIImage.init(named: "live_triangle"), for: .normal)
            distanceButton.setTitleColor(UIColor.init(fromHexString: "333333"), for: .normal)
            refreshHeader()
        }
        else if btn.tag == 3 {
            if filterView == nil {
                filterView = LiveFilterView.init(frame: CGRect.init(x: 0, y: 64+40, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64-40-150), withFilterArray: filterArray as! [Any], andSelectedIndexArray: selectedIndexArray)
                filterView?.show()
                btn.setImage(UIImage.init(named: "live_filter_selected"), for: .normal)
                btn.setTitleColor(UIColor.init(fromHexString: "457fea"), for: .normal)
                filterView?.dismissFilterBlock = { arr in
                    let array:NSMutableArray = NSMutableArray.init(array: arr!)
                    self.filterView?.dismiss()
                    self.filterView = nil
                    if array[0] as! Int == 9999 && array[1] as! Int == 9999 && array[2] as! Int == 9999 {
                        self.filtButton.setImage(UIImage.init(named: "live_filter_unselected"), for: .normal)
                        self.filtButton.setTitleColor(UIColor.init(fromHexString: "333333"), for: .normal)
                    }
                }
                filterView?.confirmFilterBlock = {arr in
                    let array:NSMutableArray = NSMutableArray.init(array: arr!)
                    self.selectedIndexArray = array
                    let dic0:NSDictionary = self.filterArray[0] as! NSDictionary
                    let tempDataArray0:NSArray = dic0.allValues.last as! NSArray
                    let dic1:NSDictionary = self.filterArray[1] as! NSDictionary
                    let tempDataArray1:NSArray = dic1.allValues.last as! NSArray
                    if array[2] as! Int != 9999 {
                        if array[2] as! Int == 0 {
                            self.type = ""
                        }
                        else {
                            self.type = "\(array[2])"
                        }
                    }
                    else {
                        self.type = ""
                    }
                    if array[1] as! Int != 9999 {
                        if array[1] as! Int == 0 {
                            self.exp = ""
                        }
                        else {
                            self.exp = "\(tempDataArray1[array[1] as! Int])"
                        }
                    }
                    else {
                        self.exp = ""
                    }
                    if array[0] as! Int != 9999 {
                        if array[0] as! Int == 0 {
                            self.anchor_type = ""
                        }
                        else {
                            self.anchor_type = "\(tempDataArray0[array[0] as! Int])"
                        }
                    }
                    else {
                        self.anchor_type = ""
                    }
                    self.filterView?.dismiss()
                    self.filterView = nil
                    self.refreshHeader()
                    if array[0] as! Int == 9999 && array[1] as! Int == 9999 && array[2] as! Int == 9999 {
                        self.filtButton.setImage(UIImage.init(named: "live_filter_unselected"), for: .normal)
                        self.filtButton.setTitleColor(UIColor.init(fromHexString: "333333"), for: .normal)
                    }
                }
                return
            }
        }
        if filterView != nil {
            filterView?.dismiss()
            filterView = nil
            filtButton.setImage(UIImage.init(named: "live_filter_unselected"), for: .normal)
            filtButton.setTitleColor(UIColor.init(fromHexString: "333333"), for: .normal)
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

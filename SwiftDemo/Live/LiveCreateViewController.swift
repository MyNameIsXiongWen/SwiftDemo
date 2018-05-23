//
//  LiveCreateViewController.swift
//  SwiftDemo
//
//  Created by jiazhuo1 on 2018/5/23.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

let LIVECREATA_TABLEVIEW_ID = "livecreate_tableview_id"
let MAXPHOTOCOUNT = 16

class LiveCreateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, BottomSelectViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var pickerview: UIPickerView!
    
    var provinceString : String!
    var cityString : String!
    
    var areaString : String = ""
    var typeString : String = "请选择"
    var platformString : String = "请选择"
    var room_numberString : String = ""
    var anchor_typeString : String = "请选择"
    var expString : String = "请选择"
    var wechatString : String = ""
    var wish_salaryString : String = ""
    var brokerage_agencyString : String = ""
    var self_evaluateString : String = "请填写"
    
    var idString : String!//主播ID
    var moneyString : String!//上传照片是收费
    
    var leftSalaryArray : NSMutableArray!
    var rightSalaryArray : NSMutableArray!
    var selectCity : Bool = false
    
    //地区相关
    var pickerDic : NSDictionary!
    var provinceArray : NSArray!
    var cityArray : NSArray!
    var selectedArray : NSArray!
    var filterArray : NSMutableArray = ["",
                                        ["直播类型":["兼职","全职"]],
                                        ["所属平台":["花椒","映客","虎牙","斗鱼","战旗","熊猫","YY直播","一直播","六间房","龙珠直播","Now直播","来疯直播","触手直播","繁星直播","全民直播","KK直播","Live直播","陌陌直播","喵播","快手","其他"]],
                                        "",
                                        ["主播类型":["电竞","电商","体育","教育","游戏","户外","其他"]],
                                        ["直播经验":["1年","2年","3年","4年以上"]],
                                        "",
                                        ""]
    
    var picArray : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我是主播"
        // Do any additional setup after loading the view.
        tableview.register(UINib.init(nibName: "LiveCreateTableViewCell", bundle: nil), forCellReuseIdentifier: LIVECREATA_TABLEVIEW_ID)
        picArray = NSMutableArray.init()
        leftSalaryArray = NSMutableArray.init()
        rightSalaryArray = NSMutableArray.init()
        for i in 1...50 {
            leftSalaryArray.add("\(i)")
        }
        leftSalaryArray.insert("面议", at: 0)
        for i in 2...51 {
            rightSalaryArray.add("\(i)")
        }
        rightSalaryArray.insert("面议", at: 0)
        let rightBtn:UIButton = UIButton.init(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        rightBtn.setTitleColor(UIColor.init(fromHexString: "333333"), for: .normal)
        rightBtn.bounds = CGRect.init(x: 0, y: 0, width: 40, height: 30)
        rightBtn.addTarget(self, action: #selector(saveCreate), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        getSelectTypeRequest(type: 1)
        getSelectTypeRequest(type: 2)
        getPickerData()
    }
    
    func getPickerData() -> Void {
        let path = Bundle.main.path(forResource: "Address", ofType: "plist")
        pickerDic = NSDictionary.init(contentsOfFile: path!)
        provinceArray = pickerDic.allKeys as NSArray
        selectedArray = pickerDic.object(forKey: provinceArray.object(at: 0)) as! NSArray
        if selectedArray.count > 0 {
            let dic:NSDictionary = selectedArray.object(at: 0) as! NSDictionary
            cityArray = dic.allKeys as NSArray
        }
    }
    
    @objc func saveCreate() -> Void {
        
    }
    
    func getSelectTypeRequest(type:NSInteger) -> Void {
        var typeString = ""
        if type == 1 {
            typeString = "platform"
        }
        else {
            typeString = "anchor_type"
        }
        let dic = ["type":typeString]
        NetWorkManager.sharedNetWorkManager.NetWorkRequest(requestType: .GET, url: "\(HttpURLString)currency/get_conf", params: dic, success: { (responseObject) in
            SVProgressHUD.dismiss()
            if responseObject?["errcode"] as? Int == 1 {
                if type == 1 {
                    let arr:NSArray = responseObject?["data"] as! NSArray
                    let tempDic:[String:Any] = ["所属平台":arr] as [String:Any]
                    self.filterArray.replaceObject(at: 2, with: tempDic)
                }
                else {
                    let arr:NSArray = responseObject?["data"] as! NSArray
                    let tempDic:[String:Any] = ["主播类型":arr] as [String:Any]
                    self.filterArray.replaceObject(at: 4, with: tempDic)
                }
            }
            else {
                SVProgressHUD.showError(withStatus: responseObject?["message"] as? String)
            }
        }) { (error) in
            SVProgressHUD.dismiss()
            print(error!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if picArray.count == 16 {
                return ((SCREEN_WIDTH-30-30)/4+10)*CGFloat(picArray.count/4) + 10+25
            }
            return ((SCREEN_WIDTH-30-30)/4+10)*CGFloat(picArray.count/4+1) + 10+25
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 15
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
            if cell == nil {
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cellId")
            }
            for view:UIView in (cell?.contentView.subviews)! {
                view.removeFromSuperview()
            }
            cell?.accessoryType = .none
            let xingxiang:UILabel = UILabel.init(frame: CGRect.init(x: 15, y: 10, width: 100, height: 15))
            xingxiang.text = "主播魅力"
            xingxiang.textColor = UIColor.init(fromHexString: "333333")
            xingxiang.font = UIFont.systemFont(ofSize: 14.0)
            cell?.addSubview(xingxiang)
            
            return cell!
        }
        else {
            let leftArray = ["城市","直播类型","所属平台","平台房间号","主播类型(选填)","直播经验(选填)","微信","期望薪资","经纪公司","我的特点(选填)"]
            let rightArray = [areaString,typeString,platformString,room_numberString,anchor_typeString,expString,wechatString,wish_salaryString,brokerage_agencyString,self_evaluateString]
            let cell:LiveCreateTableViewCell = tableView.dequeueReusableCell(withIdentifier: LIVECREATA_TABLEVIEW_ID) as! LiveCreateTableViewCell
//            let range:NSRange = (leftArray[indexPath.row]).range(of: "(选填)") as! NSRange
//            let attributeStr = NSMutableAttributedString.init(string: leftArray[indexPath.row])
//            attributeStr.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.init(fromHexString: "ff9102"),NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12.0)], range: range)
//            cell.leftLabel.attributedText = attributeStr
            cell.leftLabel.text = leftArray[indexPath.row]
            cell.rightLabel.text = rightArray[indexPath.row]
            cell.rightTextField.text = rightArray[indexPath.row]
            if indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
                if indexPath.row == 0 || indexPath.row == 7 {
                    cell.rightTextField.inputView = pickerview
                    if indexPath.row == 7 {
                        cell.rightTextField.placeholder = "请选择(以千为单位)"
                    }
                    else {
                        cell.rightTextField.placeholder = "请选择"
                    }
                }
                else {
                    cell.rightTextField.placeholder = "请填写"
                    cell.rightArrowImg.isHidden = true
                }
                cell.rightLabel.isHidden = true
                cell.rightTextField.isHidden = false
                cell.rightTextField.delegate = self
                cell.rightTextField.tag = indexPath.row
            }
            else {
                cell.rightArrowImg.isHidden = false
                cell.rightTextField.isHidden = true
                cell.rightLabel.isHidden = false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5 {
//            var title:String = ""
            let object:NSDictionary = filterArray[indexPath.row] as! NSDictionary
            let dataArray = object.allValues as! [String]
            let title = "请选择" + ((object.allKeys.last) as! String)
//            if object.count > 0 {
//                dataArray = object.allValues as NSArray
//                title = "请选择" + ((object.allKeys.last) as! String)
//            }
            var selectedNum:Int = 0
            if indexPath.row == 1 {
                if typeString != "请选择" {
                    selectedNum = dataArray.index(of: typeString)!
                }
            }
            else if indexPath.row == 2 {
                if platformString != "请选择" {
                    selectedNum = dataArray.index(of: platformString)!
                }
            }
            else if indexPath.row == 4 {
                if anchor_typeString != "请选择" {
                    selectedNum = dataArray.index(of: anchor_typeString)!
                }
            }
            else if indexPath.row == 5 {
                if expString != "请选择" {
                    selectedNum = dataArray.index(of: expString)!
                }
            }
            else if indexPath.row == 7 {
                if wish_salaryString != "" {
                    selectedNum = dataArray.index(of: wish_salaryString)!
                }
            }
            let bottomview = BottomSelectView.init(bottomWithTitle: title, stringsArray: dataArray, selectedNumber: selectedNum)
            bottomview?.tag = indexPath.row
            bottomview?.delegate = self
            bottomview?.show()
            view.endEditing(true)
        }
        else if indexPath.row == 9 {
            
        }
    }
    
    func bottomSelectViewClicked(onCell view: BottomSelectView!, clickedTag tag: Int, withDataArray array: [Any]!) {
        if view.tag == 1 {
            typeString = array[tag] as! String
        }
        else if view.tag == 2 {
            platformString = array[tag] as! String
        }
        else if view.tag == 4 {
            anchor_typeString = array[tag] as! String
        }
        else if view.tag == 5 {
            expString = array[tag] as! String
        }
        tableview.reloadRows(at: [IndexPath.init(row: view.tag, section: 0)], with: .none)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            if !selectCity {
                selectCity = true
                pickerview.reloadAllComponents()
                pickerview.selectRow(0, inComponent: 0, animated: false)
                pickerview.selectRow(0, inComponent: 1, animated: false)
            }
        }
        else if textField.tag == 7 {
            if selectCity {
                selectCity = false
                pickerview.reloadAllComponents()
                pickerview.selectRow(0, inComponent: 0, animated: false)
                pickerview.selectRow(0, inComponent: 1, animated: false)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            selectPickerView(pickerView: pickerview)
        }
        else if textField.tag == 3 {
            room_numberString = textField.text!
        }
        else if textField.tag == 6 {
            wechatString = textField.text!
        }
        else if textField.tag == 7 {
            selectPickerView(pickerView: pickerview)
        }
        else if textField.tag == 8 {
            brokerage_agencyString = textField.text!
        }
        tableview.reloadRows(at: [IndexPath.init(row: textField.tag, section: 0)], with: .none)
    }
    
    func selectPickerView(pickerView:UIPickerView) -> Void {
        if selectCity {
            provinceString = provinceArray.object(at: pickerView.selectedRow(inComponent: 0)) as! String
            cityString = cityArray.object(at: pickerView.selectedRow(inComponent: 1)) as! String
            areaString = provinceString + cityString
        }
        else {
            let left = leftSalaryArray.object(at: pickerView.selectedRow(inComponent: 0))
            let right = rightSalaryArray.object(at: pickerView.selectedRow(inComponent: 1))
            if pickerView.selectedRow(inComponent: 0) == 0 {
                wish_salaryString = "面议"
            }
            else {
                wish_salaryString = "\(left)000-\(right)000"
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectCity {
            if component == 0 {
                return provinceArray.count
            }
            return cityArray.count
        }
        else {
            if component == 0 {
                return leftSalaryArray.count
            }
            return rightSalaryArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectCity {
            if component == 0 {
                return provinceArray.object(at: row) as! String
            }
            return cityArray.object(at: row) as! String
        }
        else {
            if component == 0 {
                return leftSalaryArray.object(at: row) as! String
            }
            return rightSalaryArray.object(at: row) as! String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if selectCity {
            if component == 0 {
                return 150
            }
            return 200
        }
        return SCREEN_WIDTH/2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectCity {
            if component == 0 {
                selectedArray = pickerDic.object(forKey: provinceArray.object(at: row)) as! NSArray
                if selectedArray.count > 0 {
                    let dic:NSDictionary = selectedArray.object(at: 0) as! NSDictionary
                    cityArray = dic.allKeys as NSArray
                }
                else {
                    cityArray = nil
                }
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            }
        }
        else {
            if component == 0 {
                if row == 0 {
                    pickerView.reloadComponent(1)
                    pickerView.selectRow(0, inComponent: 1, animated: true)
                }
                else {
                    if row > pickerView.selectedRow(inComponent: 1) {
                        pickerView.reloadComponent(1)
                        pickerView.selectRow(row, inComponent: 1, animated: true)
                    }
                }
            }
            else {
                if row == 0 {
                    pickerView.reloadComponent(0)
                    pickerView.selectRow(0, inComponent: 0, animated: true)
                }
                else {
                    if row > pickerView.selectedRow(inComponent: 0) {
                        pickerView.reloadComponent(0)
                        pickerView.selectRow(row, inComponent: 0, animated: true)
                    }
                }
            }
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

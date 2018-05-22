//
//  LiveIntelligentTableViewCell.swift
//  SwiftDemo
//
//  Created by jiazhuo1 on 2018/5/22.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

enum ContentType {
    case ContentTypeIntelligent
    case ContentTypeLive
}

typealias ClickAllBlock = () -> Void
typealias ClickInformationBlock = (NSInteger, ContentType) -> Void
private let MaxShow:NSInteger = 6

class LiveIntelligentTableViewCell: UITableViewCell {
    
    @IBOutlet weak internal var leftTitleLabel: UILabel!
    @IBOutlet weak var rightAllBtn: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    var clickAllBlock : ClickAllBlock?
    var clickInformationBlock : ClickInformationBlock?
    var type : ContentType?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func createScrollView(intelligentArray:NSMutableArray) -> Void {
        for view:UIView in contentScrollView.subviews {
            view.removeFromSuperview()
        }
        var viewHeight:Int = 0
        if type == .ContentTypeIntelligent {
            viewHeight = 180
        }
        else if type == .ContentTypeLive {
            viewHeight = 135
        }
        
        for i:NSInteger in 0..<intelligentArray.count {
            if i < MaxShow {
                let model:IntelligentModel! = intelligentArray.object(at: i) as! IntelligentModel
                if type == .ContentTypeIntelligent {
                    let intView = IntelligentView.init(frame: CGRect.init(x: 15+145*i, y: 0, width: 135, height: viewHeight))
                    intView.imageView.sd_setImage(with: URL.init(string: model.photo), completed: nil)
                    intView.nameLabel.text = model.nickname
                    intView.priceLabel.text = "¥\(model.price)"
                    intView.timeLabel.text = model.last_login
                    contentScrollView.addSubview(intView)
                    let btn:UIButton = UIButton.init(frame: intView.frame)
                    btn.tag = i
                    btn.addTarget(self, action: #selector(clickIntView(btn:)), for: .touchUpInside)
                    contentScrollView.addSubview(btn)
                }
                else {
                    let intView = LiveView.init(frame: CGRect.init(x: 15+145*i, y: 0, width: 135, height: viewHeight))
                    intView.imageView.sd_setImage(with: URL.init(string: model.photo), completed: nil)
                    contentScrollView.addSubview(intView)
                    let btn:UIButton = UIButton.init(frame: intView.frame)
                    btn.tag = i
                    btn.addTarget(self, action: #selector(clickIntView(btn:)), for: .touchUpInside)
                    contentScrollView.addSubview(btn)
                }
            }
            else {
                var imageStr:String = ""
                if type == .ContentTypeIntelligent {
                    imageStr = "home_intelligent_more";
                }
                else {
                    imageStr = "home_live_more";
                }
                let btn:UIButton = UIButton.init(frame: CGRect.init(x: 15+145*i, y: 0, width: 100, height: viewHeight))
                btn.setImage(UIImage.init(named: imageStr), for: .normal)
                btn.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
                contentScrollView.addSubview(btn)
            }
        }
    }
    
    @objc func clickIntView(btn:UIButton) -> Void {
        if clickInformationBlock != nil {
            clickInformationBlock!(btn.tag, type!)
        }
    }
    
    @objc func clickMore() -> Void {
        if clickAllBlock != nil {
            clickAllBlock!()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

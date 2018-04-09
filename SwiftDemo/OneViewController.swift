//
//  OneViewController.swift
//  SwiftDemo
//
//  Created by 熊文 on 2018/4/5.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

let CollectionViewCellIdentifier = "mainCollectionViewCellIdentifier"

class OneViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "首页"
        configUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configUI() -> Void {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: (SCREEN_WIDTH-1)/3, height: 100)
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        collectionViewLayout.minimumLineSpacing = 0.5
        collectionViewLayout.minimumInteritemSpacing = 0.5
        
        
        let collectionView:UICollectionView = UICollectionView(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), collectionViewLayout: collectionViewLayout)
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MainControllerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCellIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier, for: indexPath) as! MainControllerCollectionViewCell
        collectionViewCell.mainImageView.image = UIImage(named: "twoselected")
        collectionViewCell.mainLabel.text = "会员"
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertC = UIAlertController(title: "提示", message: "mmmmmm", preferredStyle: UIAlertControllerStyle.alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default) { (action) in
            print("点击了确定")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            print("点击了取消")
        }
        alertC.addTextField { (textfield) in
            textfield.placeholder = "输入账号"
        }
        alertC.addTextField { (textfield) in
            textfield.placeholder = "输入密码"
            textfield.isSecureTextEntry = true
        }
        alertC.addAction(confirmAction)
        alertC.addAction(cancelAction)
        self.present(alertC, animated: true, completion: nil)
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

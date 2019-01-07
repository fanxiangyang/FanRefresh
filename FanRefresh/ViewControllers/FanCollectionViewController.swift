//
//  FanCollectionViewController.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/4/10.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FanCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var dataArray:Array<String>?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        self.dataArray=["1","2","3","4","5"]
        self.view.backgroundColor=UIColor.white
        self.collectionView?.backgroundColor=UIColor.white
        
        self.automaticallyAdjustsScrollViewInsets=false
        self.navigationController?.navigationBar.isTranslucent=false
        
        
        weak var weakSelf=self
        //下拉
        self.collectionView?.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
        //上拉
        self.collectionView?.fan_footer=FanRefreshFooterDefault.footerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadMoreData()
        })

    }
    init() {
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .vertical//垂直,Horizontal横向
        //横向纵向最小间距(后面有两个代理可以动态改变，所以这里设置无效）
        layout.minimumLineSpacing=3
        layout.minimumInteritemSpacing=0
        super.init(collectionViewLayout: layout)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 数据处理
    
    func fan_loadData() {
        self.dataArray = ["6","7","8","9","10"]
        
        weak var weakTableView=self.collectionView
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
            weakTableView?.reloadData()
            
            weakTableView?.fan_header?.fan_endRefreshing()
            //            weakTableView?.reloadData()
            
        }
        
    }
    func fan_loadMoreData() {
        weak var weakTableView=self.collectionView
        self.dataArray=self.dataArray! + ["6","7","8","9","10"]
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
            weakTableView?.reloadData()
            
            weakTableView?.fan_footer?.fan_endRefreshing()
            //            weakTableView?.reloadData()
            
        }
        
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)

    }
    
    //设置所有的cell组成的视图与section 上、左、下、右的间隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20)
    }
    //反之亦然(当前设置是垂直布局）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)//头部布局垂直布局高度有效果
    }
    
    //最小纵向间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    //最小横向间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (self.dataArray?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        var textLabel:UILabel? = cell.viewWithTag(100) as? UILabel
        if (textLabel == nil) {
            textLabel = UILabel(frame: cell.bounds)
            textLabel?.tag = 100
            textLabel?.backgroundColor=UIColor.green
            cell.addSubview(textLabel!)
            textLabel?.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        }
        
        textLabel?.text = self.dataArray?[indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

//
//  FanTableViewController.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/29.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

class FanTableViewController: UITableViewController {
    var dataArray:Array<Any>?
    var fan_indexPath:IndexPath?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArray=Array()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.navigationBar.isTranslucent=true
        self.navigationItem.title="TableView"
        self.configData()
        self.configUI()
        
        self.fan_jumpType()

    }
    func configUI() {
        let item = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.fan_more))
        self.navigationItem.rightBarButtonItem=item
    }
    @objc func fan_more()  {
        var exampleIndex = 0
        switch (self.fan_indexPath?.section)! {
        case 0:
            exampleIndex = (self.fan_indexPath?.row)!
        case 1:
            exampleIndex = (self.fan_indexPath?.row)! + 4
            
        default: break
            
        }
        
        var title:String? = "温馨提示"
        var message:String?
        switch exampleIndex {
        case 0:
            message = "默认下拉状态！"
        case 1:
            title = "修改内容"
            message = "1.透明度渐变 2.背景颜色 3.字体颜色大小及状态内容 4.时间回调强显示 5.几秒后自动刷新"
        case 2:
            message = "下拉时隐藏时间控件"
        case 3:
            message = "可以修改，下拉，刷新，正常状态下的GIF"
        case 4:
            message = "默认上拉加载"
        case 5:
            title = "修改内容"
            message = "1.透明度渐变 2.背景颜色 3.字体颜色大小及状态内容 4.时间回调强显示 5.几秒后自动刷新"
        case 6:
            message = "确定重置上拉吗？\n 该功能可以配合刷新调整"
        case 7:
            message = "只支持刷新状态下的GIF"
        default: break
            
        }
        self.fan_showAlert(title: title, message: message)
    }
    func fan_show()  {
        var exampleIndex = 0
        switch (self.fan_indexPath?.section)! {
        case 0:
            exampleIndex = (self.fan_indexPath?.row)!
        case 1:
            exampleIndex = (self.fan_indexPath?.row)! + 4
            
        default: break
            
        }
        
        switch exampleIndex {
        case 0: break
        case 1: break
        case 2: break
        case 3: break
        case 4: break
            //没有数据时，隐藏
//            self.tableView.fan_hiddenFooterWhenNull()
        case 5: break
        case 6:
            let fanFooter=self.tableView.fan_footer as! FanRefreshFooterDefault
            fanFooter.fan_resetNoMoreData()
        case 7: break
        default: break
            
        }
    }
    
    func  fan_showAlert(title:String?,message:String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (act) in

        }))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (act) in
            self.fan_show()
        }))
        
        self.present(alert, animated: true) { 
            
        }
        
    }
    // MARK: - 例子

    func fan_jumpType()  {
        var exampleIndex = 0
        switch (self.fan_indexPath?.section)! {
        case 0:
            exampleIndex = (self.fan_indexPath?.row)!
        case 1:
            exampleIndex = (self.fan_indexPath?.row)! + 4
        case 4:
            exampleIndex = (self.fan_indexPath?.row)! + 8
        default: break
            
        }
        switch exampleIndex {
        case 0:
            self.example01()
        case 1:
            self.example02()
        case 2:
            self.example03()
        case 3:
            self.example04()
        case 4:
            self.example05()
        case 5:
            self.example06()
        case 6:
             self.example07()
        case 7:
            self.example08()
        case 8:
            self.example09()
        case 9:
            self.example10()
        default: break
            
        }
        
        //这个不会冲突 ---  给判断时间间隔几秒后自动刷新
//        let fanHeader=self.tableView.fan_header as! FanRefreshHeaderDefault
//        fanHeader.fan_beginRefreshing()
    }
    func example01() {
        weak var weakSelf=self
        //下拉
        self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
//        self.tableView.fan_footer=FanRefreshFooterDefault.footerRefreshing(refreshingBlock: {
//            weakSelf?.fan_loadMoreData()
//        })
    }
    func example02() {
        weak var weakSelf=self
        //下拉
        self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
        //不转的话，没有属性可以掉用
        let fanHeader=self.tableView.fan_header as! FanRefreshHeaderDefault
        //修改背景颜色(默认透明)
        fanHeader.backgroundColor=UIColor.yellow
        //文字与菊花之间的间距（默认20）
        fanHeader.fan_labelInsetLeft=40.0
        //修改状态字体内容（默认支持 中文，繁体中文，和英文）
        fanHeader.fan_setTitle(title: "下拉可以刷新", state: .Default)
//        fanHeader.fan_setTitle(title: "松开立即刷新", state: .Pulling)
        fanHeader.fan_stateTitles[.Pulling] = "松开立即刷新"
        fanHeader.fan_setTitle(title: "正在刷新数据中...", state: .Refreshing)
        //修改状态和时间显示的字体颜色和大小样式
        fanHeader.fan_stateLabel.textColor=FanRefreshColor(r: 250, g: 34, b: 43, a: 1)
        fanHeader.fan_stateLabel.font=UIFont.boldSystemFont(ofSize: 14)
        
        // MARK:  HeaderRefresh特有的
        //--------------------------------特有begain-----------------------------------
        //下拉时透明度自动增强（默认true）
        fanHeader.fan_automaticallyChangeAlpha=false
        //修改时间显示的字体颜色和大小样式
        fanHeader.fan_lastUpdatedTimeLabel.textColor=FanRefreshColor(r: 250, g: 34, b: 43, a: 1)

        //外部修改时间控件的显示内容（默认正确的时间，可以+，可以-）
        fanHeader.fan_lasUpdateTimeText = { ( lastUpdatTime ) in
            return "2017-04-01 12:00:00"
        }
        
        //添加5秒种后再次进入界面，自动下拉刷新  ，此方法放到viewDidAppear
        //如果启用这个方式，最好启动时，直接调用 fanHeader.fan_beginRefreshing()
        fanHeader.fan_autoRefresh(thanIntervalTime: 5.0)
        //--------------------------------特有end-----------------------------------

    }
    func example03() {
        weak var weakSelf=self
        //下拉
        self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
        
        //不转的话，没有属性可以掉用
        let fanHeader=self.tableView.fan_header as! FanRefreshHeaderDefault
        //隐藏时间
        fanHeader.fan_lastUpdatedTimeLabel.isHidden=true
        //隐藏状态
//        fanHeader.fan_stateLabel.isHidden=true

        
    }
    func example04() {
        weak var weakSelf=self
        //下拉
        self.tableView.fan_header = FanRefreshHeaderGIF.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
        
        //不转的话，没有属性可以掉用
        let fanHeader=self.tableView.fan_header as! FanRefreshHeaderGIF
        //隐藏时间
        //        fanHeader.fan_lastUpdatedTimeLabel.isHidden=true
        fanHeader.fan_height = 120
        fanHeader.fan_setGifName(name: "loding1", gifState: .Default)
        fanHeader.fan_setGifName(name: "loding", gifState: .Refreshing)
        //        fanHeader.fan_setGifName(name: "loding1", gifState: .Pulling)
        //上面可以这样替换，也可以放置png,jpg的image对象
        fanHeader.fan_gifImages[.Pulling] = UIImage.fan_gif(name: "loding1")
        
        //修改time与GIF间距默认5
        //        fanHeader.fan_labelInsetTop=0
        fanHeader.fan_gifImageView.fan_size=CGSize(width: 100, height: 60)
        
        fanHeader.fan_lastUpdatedTimeLabel.textColor=UIColor.red
//        fanHeader.fan_lastUpdatedTimeLabel.isHidden=true

    }
    func example05() {
        weak var weakSelf=self
        //下拉
        self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
        //上拉
        self.tableView.fan_footer=FanRefreshFooterDefault.footerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadMoreData()
        })
        
       
    }
    func example06() {
        weak var weakSelf=self
        //下拉
        self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
        //上拉
        self.tableView.fan_footer=FanRefreshFooterDefault.footerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadMoreData()
        })
        
        //不转的话，没有属性可以掉用
        let fanFooter=self.tableView.fan_footer as! FanRefreshFooterDefault
        
        //修改背景颜色(默认透明)
        fanFooter.backgroundColor=UIColor.yellow
        //文字与菊花之间的间距（默认20）
        fanFooter.fan_labelInsetLeft=40.0
        //修改状态字体内容（默认支持 中文，繁体中文，和英文）
        fanFooter.fan_setTitle(title: "点击或上拉加载更多", state: .Default)
        fanFooter.fan_setTitle(title: "正在加载更多的数据...", state: .Refreshing)
        fanFooter.fan_setTitle(title: "已经全部加载完毕", state: .NoMoreData)
        //修改状态和时间显示的字体颜色和大小样式
        fanFooter.fan_stateLabel.textColor=FanRefreshColor(r: 250, g: 34, b: 43, a: 1)
        fanFooter.fan_stateLabel.font=UIFont.boldSystemFont(ofSize: 14)

        // MARK:  FootreRefresh特有的
        //--------------------------------特有begain-----------------------------------

        //自动拖拽百分比（默认1.0）
        fanFooter.fan_automaticallyRefreshTriggerPercent=0.8
        //是否上拉时自动刷新，（默认刷新 true）
        fanFooter.fan_automaticallyRefresh=false
        //是否自动隐藏该控件当数据为空时(默认true) 暂时没有用
        fanFooter.fan_automaticallyFooterHidden=false
        //只隐藏刷新标题（默认false）
        fanFooter.fan_isRefreshTitleHidden=true
        
        //----------------------------------特有end------------------------------------

        
    }
    func example07() {
        weak var weakSelf=self
        //下拉
        self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
        //上拉
        self.tableView.fan_footer=FanRefreshFooterDefault.footerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadMoreData()
        })
        
        //不转的话，没有属性可以掉用
        let fanFooter=self.tableView.fan_footer as! FanRefreshFooterDefault
        
        //不建议在外部修改状态
//        fanFooter.state = .NoMoreData
        
        fanFooter.fan_endRefreshingWithNoMoreData()
        
    }
    func example08() {
        weak var weakSelf=self
        //下拉
        self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
        //上拉
        self.tableView.fan_footer=FanRefreshFooterGIF.footerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadMoreData()
        })
        //不转的话，没有属性可以掉用
        let fanFooter=self.tableView.fan_footer as! FanRefreshFooterGIF
        
        //不建议在外部修改状态请使用方法
//        fanFooter.state = .NoMoreData//（不推荐写法）
//        fanFooter.fan_endRefreshingWithNoMoreData() //(推荐些法)
        
        //更新高度(不要直接self.fan_height = 120)
        fanFooter.fan_UpdateHeight(height: 120)
        fanFooter.fan_setGifName(name: "loding1", gifState: .Default)
        fanFooter.fan_setGifName(name: "loding", gifState: .Refreshing)
        //        fanFooter.fan_setGifName(name: "loding1", gifState: .NoMoreData)
        //上面可以这样替换，也可以放置png,jpg的image对象
        fanFooter.fan_gifImages[.NoMoreData] = UIImage.fan_gif(name: "loding1")
        
        //修改time与GIF间距默认5
        fanFooter.fan_labelInsetLeft=0
        fanFooter.fan_gifImageView.fan_size=CGSize(width: 100, height: 60)
        
        fanFooter.fan_stateLabel.textColor=UIColor.red
        fanFooter.backgroundColor=UIColor.yellow
//        fanFooter.fan_isRefreshTitleHidden = true

        
    }
    
    func example09() {
        weak var weakSelf=self
        //系统自带简洁下拉
        let refreshControl = FanRefreshControl.fan_addRefresh(target: self, action: #selector(fan_loadDataControl))
        
        //这样也是可以的
        if #available(iOS 10.0, *) {
            self.tableView?.refreshControl = refreshControl
        }else{
            self.tableView?.fan_refreshControl = refreshControl
        }
        
//        self.tableView?.fan_refreshControl = refreshControl


        //上拉
        self.tableView.fan_footer=FanRefreshFooterDefault.footerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadMoreData()
        })
        
        
    }

    func example10() {
        weak var weakSelf=self
        //下拉
        //系统自带简洁下拉
        let refreshControl = FanRefreshControl.fan_addRefresh(target: self, action: #selector(fan_loadDataControl))
        //是否显示状态文本
        refreshControl.fan_isHidderTitle=false
        //修改菊花颜色
        refreshControl.tintColor = UIColor.red
        //修改字体颜色
        refreshControl.fan_textColor = UIColor.red
        if #available(iOS 10.0, *) {
            self.tableView?.refreshControl = refreshControl
        }else{
            self.tableView?.fan_refreshControl = refreshControl
        }
//        self.tableView?.fan_refreshControl = refreshControl

        //上拉
        self.tableView.fan_footer=FanRefreshFooterDefault.footerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadMoreData()
        })
        
        
    }

    // MARK: - 数据处理

    func fan_loadData() {
//        print("1111111111111")
        self.dataArray = ["6","7","8","9","10"]

        weak var weakTableView=self.tableView
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
            weakTableView?.reloadData()

            weakTableView?.fan_header?.fan_endRefreshing()
//            weakTableView?.reloadData()

        }
    }
    func fan_loadMoreData() {
        weak var weakTableView=self.tableView
        self.dataArray=self.dataArray! + ["6","7","8","9","10"]
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
            weakTableView?.reloadData()

            weakTableView?.fan_footer?.fan_endRefreshing()
//            weakTableView?.reloadData()

        }
        
    }
    @objc func fan_loadDataControl() {
   
//        self.dataArray = ["6","7","8","9","10"]
        if #available(iOS 10.0, *) {
            (self.tableView?.refreshControl as! FanRefreshControl).fan_beginRefreshing()
        }else{
            self.tableView?.fan_refreshControl?.fan_beginRefreshing()
        }
//        self.tableView?.fan_refreshControl?.fan_beginRefreshing()
        weak var weakTableView=self.tableView
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.0) {
            //这里修改数据，能防止cell复用时调用cell代理数组越界问题
            self.dataArray = ["6","7","8","9","10"]

            weakTableView?.reloadData()

            if #available(iOS 10.0, *) {
                weakTableView?.refreshControl?.endRefreshing()
            }else{
                weakTableView?.fan_refreshControl?.endRefreshing()
            }
//            weakTableView?.fan_refreshControl?.endRefreshing()

        }
    }
    func configData() -> () {
//        self.dataArray=self.dataArray! + ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14"]
        self.dataArray=self.dataArray! + ["0","1","2","3","4","5"]

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print((self.dataArray?.count)!)
        return (self.dataArray?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        print(self.dataArray?.count ?? "0")
        print(indexPath)

        cell.textLabel?.text=(self.dataArray?[indexPath.row] as? String)
//        cell.textLabel?.text=(self.dataArray?[indexPath.row] as? String)! + "ueiyruieyrwiuewyriuewyriewyriewyriuyr"
        print(cell.textLabel?.text ?? "")

        return cell
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

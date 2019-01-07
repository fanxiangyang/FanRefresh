# FanRefresh
Swift Refresh Lib
(一个swift语言的上拉加载下拉刷新的库)


Introduce（介绍）
==============

FanRefresh ScrollView Refresh。

超级好用的上拉下拉，git图片定制，系统UIRefreshControl,其他用户可以自己定制DIY

* Refresh 	— 基本类扩展和常量定义。
* Header		— 下拉刷新控件。
* Footer		— 上拉加载控件。

Installation（安装）
==============
### CocoaPods

1. Add `pod 'FanRefresh','~> 0.1.1'` to your Podfile.
2. Run `pod install` or `pod update`.

```
如果 pod search  FanRefresh  查找不到，更新本地spec仓库 
pod setup  或者  pod repo update
结果还是查不到：清空搜索缓存再查询
rm ~/Library/Caches/CocoaPods/search_index.json 
```

### 手动安装

1. 下载 FanRefresh项目
2. 将 FanRefresh项目里面Classes文件夹及内的源文件添加(拖放)到你的工程。
3. 链接以下 frameworks:
   * UIKit
   * Foundation
   * ImageIO

Requirements(系统要求)
==============
FanRefresh该项目最低支持 iOS 8.0。

注意：应该能够支持到iOS7的，没有设备尝试，如果不能可以告诉我


Function Example(功能事例)
==============
### 1.Example List（功能列表）
![动画](https://github.com/fanxiangyang/FanRefresh/blob/master/Document/refreshDemo.gif?raw=true)

### 2.下拉刷新
```
weak var weakSelf=self
//下拉
self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
    weakSelf?.fan_loadData()
})

```
### 3.上拉加载
```
weak var weakSelf=self
//上拉
self.tableView.fan_footer=FanRefreshFooterDefault.footerRefreshing(refreshingBlock: {
    weakSelf?.fan_loadMoreData()
})

```
### 4.下拉属性的修改
```
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
fanHeader.fan_setTitle(title: "松开立即刷新", state: .Pulling)
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

//添加5秒种后再次进入界面，自动下拉刷新  放到viewDidAppear里面
//如果启用这个方式，最好启动时，直接调用 fanHeader.fan_beginRefreshing()
fanHeader.fan_autoRefresh(thanIntervalTime: 5.0)
//--------------------------------特有end-----------------------------------

```
### 5.系统自带UIRefreshControl刷新

```
//系统自带简洁下拉
override func viewDidLoad() {
    super.viewDidLoad()
    self.dataArray=Array()

    let refreshControl = FanRefreshControl.fan_addRefresh(target: self, action: #selector(fan_loadDataControl))
	//这样也是可以的
	if #available(iOS 10.0, *) {
	    self.tableView?.refreshControl = refreshControl
	}else{
	    self.tableView?.fan_refreshControl = refreshControl
    }
}


//加载数据，模拟2秒后刷新
func fan_loadDataControl() {
    if #available(iOS 10.0, *) {
        (self.tableView?.refreshControl as! FanRefreshControl).fan_beginRefreshing()
    }else{
        self.tableView?.fan_refreshControl?.fan_beginRefreshing()
    }
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
    }
}

```

### 6.自定义Header GIF图片显示
```
weak var weakSelf=self
//下拉
self.tableView.fan_header = FanRefreshHeaderGIF.headerRefreshing(refreshingBlock: {
    weakSelf?.fan_loadData()
})

//不转的话，没有属性可以掉用
let fanHeader=self.tableView.fan_header as! FanRefreshHeaderGIF
//隐藏时间
//        fanHeader.fan_lastUpdatedTimeLabel.isHidden=true
fanHeader.fan_height = 100
fanHeader.fan_setGifName(name: "loding1", gifState: .Default)
fanHeader.fan_setGifName(name: "loding", gifState: .Refreshing)
//        fanHeader.fan_setGifName(name: "loding1", gifState: .Pulling)
//上面可以这样替换，也可以放置png,jpg的image对象
fanHeader.fan_gifImages[.Pulling] = UIImage.fan_gif(name: "loding1")

//修改time与GIF间距默认5
//        fanHeader.fan_labelInsetTop=0
fanHeader.fan_gifImageView.fan_size=CGSize(width: 100, height: 60)

fanHeader.fan_lastUpdatedTimeLabel.textColor=UIColor.red
//fanHeader.fan_lastUpdatedTimeLabel.isHidden=true

```
### 7.自定义Footer GIF图片显示
```
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
```
更新历史(Version Update)
==============
### Release 0.0.3
* 支持简单的上拉和下拉刷新，没有GIF图片

### Release 0.0.4
* 简化枚举属性
* 添加系统控件UIRefreshControl实现下拉刷新(可兼容iOS10)

### Release 0.0.5
* 修复中文字符串长度越界问题
* 修复调用时间记录初次为空时崩溃的处理
* 添加Header和Footer的自定义GIF展示

### Release 0.1.0
* 增加对iOS 11的支持及适配
* 已经更新到最新的swift4

### Release 0.1.1
* 已经更新到最新的swift4.2 部分语法变化

Like(喜欢)
==============
#### 有问题请直接在文章下面留言,喜欢就给个Star(小星星)吧！ 
#### Email:fqsyfan@gmail.com

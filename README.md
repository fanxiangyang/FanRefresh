# FanRefresh
Swift Refresh Lib
(一个swift语言的上拉加载下拉刷新的库)


Introduce（介绍）
==============

FanRefresh ScrollView Refresh。

现在只支持默认的上拉下拉，git图片在定制中，其他用户可以自己定制

* Refresh 		— 基本类扩展和常量定义。
* Header		— 下拉刷新控件。
* Footer		— 上拉加载控件。

Installation（安装）
==============
### CocoaPods

1. Add `pod "FanRefresh"` to your Podfile.
2. Run `pod install` or `pod update`.

### 手动安装

1. 下载 FanRefresh项目
2. 将 FanRefresh项目里面Classes文件夹及内的源文件添加(拖放)到你的工程。
3. 链接以下 frameworks:
    * UIKit
    * Foundation

Requirements(系统要求)
==============
FanKit该项目最低支持 iOS 8.0。

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
### 3.下拉属性的修改
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
fanHeader.fan_setTitle(title: "下拉可以刷新", state: .FanRefreshStateDefault)
fanHeader.fan_setTitle(title: "松开立即刷新", state: .FanRefreshStatePulling)
fanHeader.fan_setTitle(title: "正在刷新数据中...", state: .FanRefreshStateRefreshing)
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

//添加5秒种后再次进入界面，自动下拉刷新  
//如果启用这个方式，最好启动时，直接调用 fanHeader.fan_beginRefreshing()
fanHeader.fan_autoRefresh(thanIntervalTime: 5.0)
//--------------------------------特有end-----------------------------------

```


Like(喜欢)
==============
#### 有问题请直接在文章下面留言。
#### 喜欢此系列文章可以点击上面右侧的 Star 哦，变成 Unstar 就可以了！ 
### 开发人：凡向阳
#### Email:fanxiangyang_heda@163.com

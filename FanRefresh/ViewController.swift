//
//  ViewController.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/29.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView?
    var dataArray:Array<[String]>?
    var detailArray:Array<[String]>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.navigationController?.navigationBar.isTranslucent=false

        
        self.dataArray=[["下拉刷新-默认","下拉刷新-修改","下拉刷新-隐藏","下拉刷新-GIF"],["上拉加载-默认","上拉加载-修改","上拉加载-没有更多数据","上拉加载-GIF"],["UICollectionView"],["UIWebView"]]
        self.detailArray=[["FanTableViewController - example01","FanTableViewController - example02","FanTableViewController - example03","FanTableViewController - example04"],["FanTableViewController - example05","FanTableViewController - example06","FanTableViewController - example07","FanTableViewController - example08"],["FanCollectionView"],["FanWebView"]]
        
        self.configUI()
        
        weak var weakSelf=self
        //下拉
        self.tableView?.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadData()
        })
//        self.tableView?.fan_header?.backgroundColor=UIColor.red
//        self.tableView?.fan_header?.fan_automaticallyChangeAlpha=false
        
        //上拉
        self.tableView?.fan_footer=FanRefreshFooterDefault.footerRefreshing(refreshingBlock: {
            weakSelf?.fan_loadMoreData()
        })
        
    }
    func fan_loadData() {
        weak var weakTableView=self.tableView
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
            weakTableView?.reloadData()
            weakTableView?.fan_header?.fan_endRefreshing()
        }
        
    }
    func fan_loadMoreData() {
        weak var weakTableView=self.tableView
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
            weakTableView?.reloadData()
            weakTableView?.fan_footer?.fan_endRefreshing()
        }
        
    }

    func configUI() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .grouped)
        self.tableView?.delegate=self
        self.tableView?.dataSource=self
        self.view .addSubview(self.tableView!)
        self.tableView?.autoresizingMask=[.flexibleWidth,.flexibleHeight]

    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell?.accessoryType = .disclosureIndicator
        }
        // Configure the cell...
        cell?.textLabel?.text=(self.dataArray?[indexPath.section][indexPath.row])
        cell?.detailTextLabel?.text=self.detailArray?[indexPath.section][indexPath.row]
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 || indexPath.section == 1 {
            let vc:FanTableViewController? = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FanTableViewController") as? FanTableViewController
            vc?.fan_indexPath=indexPath
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if indexPath.section == 2 {
            let vc:FanCollectionViewController = FanCollectionViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 3 {
            let vc:FanWebViewController = FanWebViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


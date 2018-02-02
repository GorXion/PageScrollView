//
//  ViewController.swift
//  GXPageScrollView
//
//  Created by GorXion on 2018/2/2.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageScrollView = PageScrollView(frame: view.bounds)
        pageScrollView.frame.origin.y = 20
        pageScrollView.dataSource = self
        pageScrollView.delegate = self
        view.addSubview(pageScrollView)
        pageScrollView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: PageScrollViewDataSource {
    func numberOfSections(in pageScrollView: PageScrollView) -> Int {
        return 3
    }
    
    func pageScrollView(_ pageScrollView: PageScrollView, itemForIndexAt index: Int) -> UIView {
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        let redView = UIView()
        redView.backgroundColor = UIColor.red
        let greenView = UIView()
        greenView.backgroundColor = UIColor.green
        return [whiteView, redView, greenView][index]
    }
    
    func pageScrollView(_ pageScrollView: PageScrollView, titleForIndexAt index: Int) -> String {
        return ["第一页", "第二页", "第三页"][index]
    }
}

extension ViewController: PageScrollViewDelegate {
    func pageScrollView(_ pageScrollView: PageScrollView, didSelectItemAt index: Int) {
        print("点击了第\(index)个item")
    }
    
    func pageScrollView(_ pageScrollView: PageScrollView, didScrollToItemAt index: Int) {
        print("滚到了第\(index)个item")
    }
}


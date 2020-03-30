//
//  AppCoordinator.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator {
    
    var window: UIWindow
    
    private var tabbarCtrl: UITabBarController?
    private var dateViewCtrl: DateViewController!
    private var charViewCtrl: ChartViewController!
    private var viewModel = BodyViewModel()
    
    init(window: UIWindow) {
        keyboardHandler.isEnable = true
        self.window = window
        self.dateViewCtrl = DateViewController(viewModel: self.viewModel)
        self.charViewCtrl = ChartViewController(viewModel: self.viewModel)
        self.configureTabbarCtrl()
        self.bind()
    }
    
    private func configureTabbarCtrl() {
        self.tabbarCtrl = UITabBarController()
        self.tabbarCtrl?.viewControllers =
            [
                UINavigationController(rootViewController: self.dateViewCtrl),
                UINavigationController(rootViewController: self.charViewCtrl)
            ]
        self.configureTabbarItems()
    }
    
    private func configureTabbarItems() {
        guard
            let dateItem = self.tabbarCtrl?.tabBar.items?.first,
            let chartItem = self.tabbarCtrl?.tabBar.items?.last
        else { return }
        dateItem.title = "紀錄"
        dateItem.image = UIImage(named: "pencil")?.withRenderingMode(.alwaysOriginal)
        dateItem.selectedImage = UIImage(named: "pencil_highlight")?.withRenderingMode(.alwaysOriginal)
        dateItem.titlePositionAdjustment.vertical = dateItem.titlePositionAdjustment.vertical + 4
        
        chartItem.title = "圖表"
        chartItem.image = UIImage(named: "chart")?.withRenderingMode(.alwaysOriginal)
        chartItem.selectedImage = UIImage(named: "chart_highlight")?.withRenderingMode(.alwaysOriginal)
        chartItem.titlePositionAdjustment.vertical = chartItem.titlePositionAdjustment.vertical + 4
    }
    
    private func bind() {
        self.charViewCtrl.showBodyRecord = { [weak self] body in
            guard let `self` = self else { return }
            self.dateViewCtrl.reloadBodyValue(date: .init(timeIntervalSince1970: body.timestamp))
            self.tabbarCtrl?.selectedIndex = 0
        }
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        window.makeKeyAndVisible()
        window.rootViewController = self.tabbarCtrl
    }
}

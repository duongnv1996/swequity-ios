//
//  HMTrainingProgramVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import TYCyclePagerView
import RxSwift
import RxCocoa

class HMTrainingProgramVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet private weak var pagerView: TYCyclePagerView!
    @IBOutlet private weak var pageControl: TYPageControl!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private var tableFooterView: UIView!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let listTasks: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    override func setupView() {
        super.setupView()
        titleScreen = "Chương trình tập"
        
        setupTableView()
        setupPagerView()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = tableFooterView
        
        tableView.registerNibCellFor(type: HMTaskCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        listTasks.bind(to: tableView.rx.items(cellIdentifier: "HMTaskCell", cellType: HMTaskCell.self)) { row, model, cell in
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: {task in
            // TODO : Open Task detail screen
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setupPagerView() {
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(UINib(nibName: "HMTrainingProgramSlideCell", bundle: nil), forCellWithReuseIdentifier: "HMTrainingProgramSlideCell")
        
        pagerView.isInfiniteLoop = false
        
        pageControl.numberOfPages = 10
        pageControl.pageIndicatorTintColor = UIColor(red: 151, green: 151, blue: 151)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 221, green: 110, blue: 53)
        pageControl.pageIndicatorSize = CGSize(width: 10, height: 10)
        pageControl.contentHorizontalAlignment = .center
    }
    
    // MARK: - Data management
    private func fetchData() {
        listTasks.accept(["test","test","test","test","test"])
    }

}

extension HMTrainingProgramVC: TYCyclePagerViewDataSource {
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return 10
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: pageView.frame.width, height: pageView.frame.height)
        layout.itemSpacing = 8
        layout.itemVerticalCenter = true
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return layout
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HMTrainingProgramSlideCell", for: index) as! HMTrainingProgramSlideCell
        return cell
    }
    
}

extension HMTrainingProgramVC: TYCyclePagerViewDelegate {
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        self.pageControl.currentPage = toIndex;
    }
}


//
//  HMSplashVC.swift
//  Develop
//
//  Created by RTC-HN360 on 7/24/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMSplashVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Constants
    let pageTitles: [String] = ["LỐI SỐNG LÀNH MẠNH", "GIẤC NGỦ NGON", "THỰC PHẨM TƯƠI & NƯỚC", "LUYỆN TẬP  "]
    let pageImages: [String] = ["logo_slap_1", "logo_slap_2", "logo_slap_3", "logo_slap_4"]
    let pageContent: [String] = ["GIẢI TOẢ CĂNG THẲNG, CÂN BẰNG CUỘC SỐNG BẰNG CÁCH LUYỆN .", "GIỮ CHO TINH THẦN TỈNH TÁO, SỨC KHOẺ DẺO DAI BỀN BỈ.", "GIỮ CHO CƠ THỂ LUÔN TRONG TRẠNG THÁI KHOẺ MẠNH NHẤT.", "RÈN LUYỆN THỂ CHẤT ĐỂ CÓ MỘT CƠ THỂ SĂN CHẮC, BODY HOÀN HẢO."]
    
    // MARK: - Variables
    var pages: [HMContentSplashVC] = []
    var pageContainer: UIPageViewController!
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupView() {
        super.setupView()
        setUpPageContainer()
        setUpPageControl()
    }
    
    // MARK: - Action
    @IBAction func invokeSkipButton(_ sender: UIButton) {
        movePage(direction: .reverse)
    }
    
    @IBAction func invokeNextButton(_ sender: UIButton) {
        if currentIndex == (pages.count - 1) {
            let rootVC = UINavigationController(rootViewController: HMLoginVC.create())
            var window = UIApplication.shared.keyWindow
            HMSystemBoots.instance.changeRoot(window: &window, rootController: rootVC)
        } else {
            movePage(direction: .forward)
        }
    }
    
    func setUpPageContainer() {
        // Setup data
        let page1 = HMContentSplashVC.create()
        page1.titleStr = pageTitles[0]
        page1.content = pageContent[0]
        page1.image = pageImages[0]
        let page2 = HMContentSplashVC.create()
        page2.titleStr = pageTitles[1]
        page2.content = pageContent[1]
        page2.image = pageImages[1]
        let page3 = HMContentSplashVC.create()
        page3.titleStr = pageTitles[2]
        page3.content = pageContent[2]
        page3.image = pageImages[2]
        let page4 = HMContentSplashVC.create()
        page4.titleStr = pageTitles[3]
        page4.content = pageContent[3]
        page4.image = pageImages[3]
        
        pages = [page1,page2, page3, page4]
        
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.dataSource = self
        pageContainer.delegate = self
        if let firstVC = pages.first {
            pageContainer.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        pageContainer!.view.frame = CGRect(x: 0, y: -20, width: 375, height: 667);
        addChild(pageContainer)
        containView.addSubview(pageContainer.view)
        containView.bringSubviewToFront(pageControl)
    }
    
    func setUpPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentIndex
    }
    
    func movePage(direction: UIPageViewController.NavigationDirection) {
        if(direction == UIPageViewController.NavigationDirection.forward) {
            guard currentIndex < pages.count else { return }
            currentIndex = currentIndex + 1
            guard currentIndex < pages.count else { return }
        } else {
            guard currentIndex >= 0 else { return }
            currentIndex = currentIndex - 1
            guard currentIndex >= 0 else { return }
        }
        
        pageControl.currentPage = currentIndex
        let viewController = pages[currentIndex]
        pageContainer.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewController datasource
extension HMSplashVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! HMContentSplashVC) else { return nil }
        let previousIndex = viewControllerIndex - 1
        if (previousIndex < 0 || previousIndex == NSNotFound) { return nil }
        currentIndex = previousIndex
        pageControl.currentPage = previousIndex
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! HMContentSplashVC) else { return nil }
        let nextIndex = viewControllerIndex + 1
        if (nextIndex >= pages.count || nextIndex == NSNotFound) { return nil }
        currentIndex = nextIndex
        pageControl.currentPage = nextIndex
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewController delegates
extension HMSplashVC: UIPageViewControllerDelegate {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}

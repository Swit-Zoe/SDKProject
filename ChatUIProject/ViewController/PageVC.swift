//
//  PageVC.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/06.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit
import PinLayout

protocol PageVCDelegate{
    func logout()
    func goToChannel()
    func goToTask()
}

class HomeStepper: Stepper {

    let steps = PublishRelay<Step>()
}
/*
class PageVC: UIViewController {
    var pages = [UIViewController]()

    private let disposeBag = DisposeBag()
    private var firstVC = UIViewController()


    private lazy var pageViewController: UIPageViewController = {
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        page.view.translatesAutoresizingMaskIntoConstraints = false
        page.delegate = self
        page.dataSource = self
        return page
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        print(#function)
        print("page count : \(pages.count)")
        guard let firstVC = pages.first else {
            print("fail")
            return }
     //   pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
    }

    private func layout() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

        NSLayoutConstraint.activate([pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     pageViewController.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                                     pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        pageViewController.didMove(toParent: self)
    }


}

extension PageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}

extension PageVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
            let currentViewController = pageViewController.viewControllers?.first,
            let index = pages.firstIndex(of: currentViewController) else {
            return
        }
    }
}
*/


class PageVC: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource{

    var coordinatorDelegate:PageVCDelegate?
    var homeSteps:HomeStepper = HomeStepper()
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
        
    private lazy var pageViewController: UIPageViewController = {
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        page.view.translatesAutoresizingMaskIntoConstraints = false
        page.delegate = self
        page.dataSource = self
        return page
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.dataSource = self
        self.delegate = self

//        let page1 = ProjectListVC()
//
//        let page2 = ChatListVC()
//        page2.delegate = coordinatorDelegate
//
//        // add the individual viewControllers to the pageViewController
//        self.pages.append(page1)
//        self.pages.append(page2)
        print("page count : \(pages.count)")
        
        guard let firstVC = pages.first else {
            print("fail")
            return
        }
        setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        
        
//        // pageControl
//        self.pageControl.frame = CGRect()
//        self.pageControl.currentPageIndicatorTintColor = UIColor.black
//        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
//        self.pageControl.numberOfPages = self.pages.count
//        self.pageControl.currentPage = initialPage
//        self.view.addSubview(self.pageControl)
//
//        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
//        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
//        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
//        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return self.pages.last
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    
    @objc func logout(){
        self.homeSteps.steps.accept(FlowStep.toLogin)
    }
    
}



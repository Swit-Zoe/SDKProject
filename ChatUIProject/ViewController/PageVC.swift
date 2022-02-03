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
        
        guard let firstVC = pages.first else {return }
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
    }

    private func layout() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        pageViewController.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
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

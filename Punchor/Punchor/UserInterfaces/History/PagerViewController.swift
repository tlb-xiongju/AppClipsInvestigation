//
//  HistoryViewController.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/10.
//

import UIKit

class PagerViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        view.backgroundColor = .systemGroupedBackground
        
        if let history = history(for: Date()) {
            setViewControllers([history], direction: .forward, animated: false)
        }
    }
    
    
    @IBAction func backwardButtonTap(_ sender: UIBarButtonItem) {
        if let history = history(for: Date()) {
            setViewControllers([history], direction: .reverse, animated: true)
        }
    }
    
    @IBAction func forwardButtonTap(_ sender: UIBarButtonItem) {
        if let history = history(for: Date()) {
            setViewControllers([history], direction: .forward, animated: true)
        }
    }
}



extension PagerViewController: UIPageViewControllerDataSource {
    private func history(for date: Date) -> HistoryViewController? {
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        return storyboard.instantiateInitialViewController()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return history(for: Date())
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return history(for: Date())
    }
}

extension PagerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
//        self.date = (self.viewControllers?.first as! JournalViewController).date
    }
}

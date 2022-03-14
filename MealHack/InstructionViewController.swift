//
//  InstructionViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 12/5/21.
//

import UIKit

class InstructionViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let pageControl = UIPageControl()
    let initialPage = 0
    var pages = [UIViewController]()
    var stepArray = [StepData]()
    var selectedRecipeName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up page controller
        dataSource = self
        delegate = self
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        //Append step controllers in stepArray
        for i in 0..<stepArray.count {
            let page:StepViewController = storyboard?.instantiateViewController(identifier: "StepViewController") as! StepViewController
            page.testTitle = selectedRecipeName
            page.newStepNumber = "Step \(i+1) of \(stepArray.count)"
            page.newStepInstruction = "\(stepArray[i].step)"
            if i == stepArray.count-1 {
                page.isLastPage = true
            } else {
                page.isLastPage = false
            }
            pages.append(page)
            
        }
        
        //Control
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1),
        ])
    }
    
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
    
    //Swipe left
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    //Swipe right
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        }
        else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        pageControl.currentPage = currentIndex
    }
}

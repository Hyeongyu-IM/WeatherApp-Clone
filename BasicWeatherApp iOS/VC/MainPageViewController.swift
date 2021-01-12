//
//  MainPageViewController.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/20.
//

import UIKit
import CoreLocation

class MainPageViewController: UIPageViewController {
    private var locationManager = LocationGeocoder()
    private var coreDatas = CoreDataManager()
    private var cachedWeatherViewControllers = NSCache<NSNumber, MainTableViewController>()
    private let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    private let subStoryBoard = UIStoryboard(name: "Mainsub", bundle: nil)
    private var pageControl = UIPageControl()
    private var locationList = [Location]() {
        didSet {
            self.pageControl.numberOfPages = locationList.count
//            self.pageControl.setIndicatorImage(UIImage.init(systemName: "location.fill"), forPage: 0)
        }
    }
    
    var lastViewedPageIndex: Int = 0
    
//    lazy var bottomView: UIView = {
//        let view = UIView(frame: .init(
//                            x: 0,
//                            y: UIScreen.main.bounds.height - 50,
//                            width: UIScreen.main.bounds.width,
//                            height: 50))
//        view.backgroundColor = .clear
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocationList()
        coreDatas.settingTempBool()
        configPageViewController()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "night")!)
        self.locationManager.delegate = self
        self.locationManager.requestCurrentLocation()
        configSubViews()
        
    }
    
    private func configPageViewController() {
        delegate = self
        dataSource = self

        
    }
    
    private func setLocationList() {
        self.locationList = coreDatas.getDataLocationList()
        print(self.locationList.count)
    }
    
    private func configSubViews() {
        let pageViewFrame = self.view.frame
        configurePageViewController(inside: pageViewFrame)
        configureListButton(inside: pageViewFrame)
        configureLinkIconButton(inside: pageViewFrame)
    }
    
    private func configurePageViewController(inside frame: CGRect) {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.maxY - 80, width: frame.maxX, height: 50))
        self.pageControl.numberOfPages = locationList.count
        self.pageControl.currentPage = lastViewedPageIndex
        self.pageControl.tintColor = .gray
        self.pageControl.pageIndicatorTintColor = .gray
        self.pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(systemName: "paperplane.fill")!)
        self.pageControl.backgroundColor = .clear
        self.view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(self.changeCurrentPageViewController), for: .valueChanged)
    }
    
    @objc func changeCurrentPageViewController() {
        lastViewedPageIndex = self.pageControl.currentPage
        let pickedViewController = mainTableViewController(at: self.pageControl.currentPage)
        self.setViewControllers([pickedViewController], direction: .forward, animated: false, completion: nil)
    }
    
    private func configureListButton(inside frame: CGRect) {
        let buttonRect = CGRect(x: frame.maxX - 50, y: frame.maxY - 70, width: 20, height: 20)
        let locationListButton = UIButton(frame: buttonRect)
        locationListButton.setImage(UIImage(named: "list-icon"), for: .normal)
        locationListButton.addTarget(self, action: #selector(self.presentLocationListViewController), for: .touchUpInside)
        self.view.addSubview(locationListButton)
    }
    
    @objc func presentLocationListViewController() {
        guard let locationListViewController = subStoryBoard.instantiateViewController(withIdentifier: LocationListViewController.identifier) as? LocationListViewController else { return }
        let currentPage = mainTableViewController(at: self.pageControl.currentPage)
        locationListViewController.listViewModel.locationList.value = coreDatas.getListViewData()
        locationListViewController.delegate = self
        locationListViewController.modalPresentationStyle = .fullScreen
        locationListViewController.view.backgroundColor = self.view.backgroundColor
        self.present(locationListViewController, animated: true, completion: nil)
    }
    
    private func configureLinkIconButton(inside frame: CGRect) {
        let buttonRect = CGRect(x: 20, y: frame.maxY - 70, width: 30, height: 30)
        let linkIconButton = UIButton(frame: buttonRect)
        linkIconButton.setImage(UIImage(named: "weatherChannelLogo"), for: .normal)
        linkIconButton.addTarget(self, action: #selector(self.presentWebpage), for: .touchUpInside)
        self.view.addSubview(linkIconButton)
    }
    
    @objc func presentWebpage() {
        UIApplication.shared.open(URL(string: "https://www.weather.go.kr/weather/forecast/timeseries.jsp")!, options: [:], completionHandler: nil)
    }
}

//MARK: page view controller delegate
extension MainPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let displayedContentViewController = pageViewController.viewControllers?[0] as? MainTableViewController else {
            return
        }
        self.pageControl.currentPage = displayedContentViewController.index
        self.lastViewedPageIndex = displayedContentViewController.index
        let backgroundTime = displayedContentViewController.viewModel!.weatherListTableCell.backgrounTime
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: ImageBackgroundType(Int(backgroundTime) ?? 0).rawValue)!)
        }
    }
}


extension MainPageViewController: UIPageViewControllerDataSource {
    func mainTableViewController(at index: Int) -> UIViewController {
        if let cachedWeatherViewController = cachedWeatherViewControllers.object(forKey: NSNumber(value: index)) {
            return cachedWeatherViewController
        }
        guard let createdWeatherViewController = mainStoryBoard.instantiateViewController(withIdentifier: MainTableViewController.identifier) as? MainTableViewController else { CreationError.toWeatherViewController.andReturn() }
        createdWeatherViewController.location = self.locationList[index]
        createdWeatherViewController.index = index
        cachedWeatherViewControllers.setObject(createdWeatherViewController, forKey: NSNumber(value: index))
        return createdWeatherViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        if let viewController = viewController as? MainTableViewController {
            let currentIndex = viewController.index
            return currentIndex > 0 ? mainTableViewController(at: currentIndex - 1) : nil
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        if let viewController = viewController as? MainTableViewController {
            let currentIndex = viewController.index
            return currentIndex < pageControl.numberOfPages - 1 ? mainTableViewController(at: currentIndex + 1) : nil
        }
        return nil
    }
    
    
}

//

extension MainPageViewController: LocationManagerDelegate {
    func locationManagerDidUpdate(currentLocation: Location) {
        if locationList.count == 0 {
            self.locationList.insert(currentLocation, at: 0)
        }
        coreDatas.saveORUpdateDataLocation(currentLocation)
        let currentWeatherViewController = mainTableViewController(at: lastViewedPageIndex)
        setViewControllers([currentWeatherViewController], direction: .forward, animated: false, completion: nil)
    }
}

extension MainPageViewController: LocationListViewDelegate {
    func userDidSelectLocation(at index: Int, image: UIColor) {
        guard let mainTableViewController = mainTableViewController(at: index) as? MainTableViewController else {
            print(CreationError.toWeatherViewController)
            return
        }
        self.setViewControllers([mainTableViewController], direction: .forward, animated: false, completion: nil)
        self.pageControl.currentPage = index
        self.lastViewedPageIndex = index
        self.view.backgroundColor = image
    }
    
    func userAdd(newLocation: Location) {
        self.locationList.append(newLocation)
        coreDatas.saveORUpdateDataLocation(newLocation)
    }
    
    func userDeleteLocation(at deletingIndex: Int) {
        if self.lastViewedPageIndex == deletingIndex {
            self.lastViewedPageIndex = 0
        }
        if self.lastViewedPageIndex > deletingIndex {
            self.lastViewedPageIndex -= 1
        }
        if isLastLocationInList(index: deletingIndex) {
            removeLocation(at: deletingIndex)
            return
        }
        removeLocation(at: deletingIndex)
        changeIndexOfCachedWeatherViewControllers(after: deletingIndex)
    }
    
    private func isLastLocationInList(index: Int) -> Bool {
        return index == locationList.count - 1
    }
    
    private func removeLocation(at index: Int) {
        self.locationList.remove(at: index)
        self.cachedWeatherViewControllers.removeObject(forKey: NSNumber(value: index))
    }
    
    private func changeIndexOfCachedWeatherViewControllers(after deletingIndex: Int) {
        var needChangeIndex = deletingIndex + 1
        repeat {
            let targetIndex = NSNumber(value: needChangeIndex)
            if let indexChangingViewController = self.cachedWeatherViewControllers.object(forKey: targetIndex) {
                self.cachedWeatherViewControllers.removeObject(forKey: targetIndex)
                indexChangingViewController.index -= 1
                self.cachedWeatherViewControllers.setObject(indexChangingViewController, forKey: NSNumber(value: indexChangingViewController.index))
            }
            needChangeIndex += 1
        } while needChangeIndex <= locationList.count
    }
}

//
//  MainTableViewController.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/26.
//

import UIKit

class MainTableViewController: UIViewController {
    static let identifier: String = "\(MainTableViewController.self)"
    var location: Location!
    var index = 0
    
    @IBOutlet weak var mainTableView: UITableView!
    
//    static func instance() -> MainTableViewController? {
//        return UIStoryboard(
//            name: "Main",
//            bundle: nil).instantiateViewController(
//            identifier: "MainTableViewController") as? MainTableViewController
//    }
    
    weak var delegate: WeatherListCellDelegate?
    
    var viewModel: WeatherViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
//            viewModel.location.bind { [weak self] _ in
////                self!.mainTableView.reloadData()
////                self!.mainTableView.reloadSections(IndexSet(2...2) , with: UITableView.RowAnimation.automatic)
////                print("viewModel.weekendTableViewCell -->>>>\(viewModel.weekendTableViewCell)")
//            }
            viewModel.weekendTableViewCell.bind { [weak self] _ in
                self!.mainTableView.reloadData()
                DispatchQueue.main.async {
                    self!.delegate?.WeatherListCellDelegate(cellData: viewModel.weatherListTableCell, index: self!.index)
                }
                
            }
//            viewModel.currentLocationName.bind { [weak self] _ in
//                self?.name = viewModel.
//                print("viewModel.currentLocationName.value 값이 변경되었습니다 \(viewModel.currentLocationName.value)")
//                self!.mainTableView.reloadData()
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
//        self.view.translatesAutoresizingMaskIntoConstraints = true
        print("view did load at index \(self.index)")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = .clear
        self.view.backgroundColor = .clear
        self.mainTableView.backgroundColor = .clear
        getWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let temperatureUnit = TemperatureUnit.shared.unit
        if viewModel?.temperatureUnit.value != temperatureUnit {
            viewModel?.temperatureUnit.value = temperatureUnit
        }
    }
    
    func registerCells() {
        mainTableView.register(UINib(nibName: "HourlyTableViewCell", bundle: nil), forCellReuseIdentifier: HourlyTableViewCell.registerID)
        mainTableView.register(UINib(nibName: "WeekendTableViewCell", bundle: nil), forCellReuseIdentifier: WeekendTableViewCell.registerID)
        mainTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: DetailTableViewCell.registerID)
    }
    
    func getWeatherData() {
        guard let location = self.location else {
            print(LocationError.noLocationConfigured.localizedDescription)
            return
        }
        self.viewModel = WeatherViewModel(location: location)
        self.viewModel?.retrieveWeatherInfo()
    }
}

extension MainTableViewController: UITableViewDelegate {
    
}

extension MainTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherTableViewSection.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = WeatherTableViewSection(sectionIndex: section) else { return 0 }
        switch section {
        case .hour:
            return 1
        case .weekend:
            return (viewModel?.weekendTableViewCell.value?.count ?? 1) - 1
        case .description:
            return 1
        case .detail:
            return 1
        case .link:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return UITableViewCell() }
        switch section {
        case  .hour:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.registerID, for: indexPath) as? HourlyTableViewCell,
                  let hourdatas = viewModel?.hourlyTableViewCell else { return UITableViewCell() }
            cell.passHourDatas(hourData: hourdatas)
            return cell
            
        case .weekend:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekendTableViewCell.registerID, for: indexPath) as? WeekendTableViewCell,
                  let weekendDatas = viewModel?.weekendTableViewCell.value else { return UITableViewCell() }
            cell.setWeekendData(weekendData: weekendDatas[indexPath.row])
            return cell
            
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: "longdescriptioncell", for: indexPath)
            cell.textLabel?.text = viewModel?.weatherDescription ?? ""
            return cell
            
        case .detail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.registerID, for: indexPath) as? DetailTableViewCell,
                let detailDatas = viewModel?.detailTableViewCell  else { return UITableViewCell() }
            cell.passDetailDatas(detailData: detailDatas)
            return cell
            
        case .link:
            let cell = tableView.dequeueReusableCell(withIdentifier: "linkcell", for: indexPath)
            cell.textLabel?.text = "자료가 없습니다"
            return cell
        }
        return UITableViewCell()
}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel, let headerData = viewModel.customHeaderViewData else { return nil }
        if viewModel.isHeaderViewMade {
            mainTableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
        } else {
            if section == 0 {
               let headerView = CustomHeaderView.instance()
               headerView.setHeaderData(headerData)
               return headerView
             }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
        return CGFloat(380)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return CGFloat() }
        switch section {
        case .description :
            return section.cellHeight
        case .detail:
            return section.cellHeight
        case .hour:
            return section.cellHeight
        case .link:
            return section.cellHeight
        case .weekend:
            return section.cellHeight
        }
    }
}


//extension MainTableViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let headerView = Bundle.main.loadNibNamed("CustomHeaderView", owner: nil, options: nil)?.first as? CustomHeaderView else { return }
//        let offset = scrollView.contentOffset.y
        

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let headerView = Bundle.main.loadNibNamed("CustomHeaderView", owner: nil, options: nil)?.first as? CustomHeaderView else { return }
//        let offset = scrollView.contentOffset.y
//        let changeStartOffset: CGFloat = -180
//        let changeSpeed: CGFloat = 100
//        headerView.tempStackView.alpha = min(1.0, (offset - changeStartOffset) / changeSpeed)
//    }
//}

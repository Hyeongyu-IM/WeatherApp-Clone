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
    @IBOutlet weak var mainTableViewTopConstrain: NSLayoutConstraint!
    
    weak var delegate: WeatherListCellDelegate?
    
    var viewModel: WeatherViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
//            self.viewModel!.weatherAPI.imageFileManager.delegate = self
            
            viewModel.weekendTableViewCell.bind { [weak self] _ in
                self!.mainTableView.reloadData()
                DispatchQueue.main.async {
                    self!.delegate?.WeatherListCellDelegate(cellData: viewModel.weatherListTableCell, index: self!.index)
                }
                viewModel.temperatureUnit.bind { [weak self] _ in
                    self!.mainTableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
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
        
        guard viewModel != nil else { return 1 }
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
            cell.setWeekendData(weekendData: weekendDatas[indexPath.row + 1])
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
}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel, let headerData = viewModel.customHeaderViewData else { return nil }
        if viewModel.isHeaderViewMade {
            mainTableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
        } else {
            if section == 0 {
                let headerView = CustomHeaderView.instance()
               headerView.setHeaderData(headerData)
               headerView.backgroundConfiguration = .clear()
               return headerView
             }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
        return CGFloat(380)
        }
        return CGFloat.leastNormalMagnitude
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


extension MainTableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.mainTableView.headerView(forSection: 0) as? CustomHeaderView else { return }
        
        let offset = scrollView.contentOffset.y
        let changeStartOffset: CGFloat = 80
        let changeSpeed: CGFloat = 100
        headerView.minTempLabel.alpha = min(1.0, (changeStartOffset - offset) / changeSpeed)
        headerView.maxTempLabel.alpha = min(1.0, (changeStartOffset - offset) / changeSpeed)
        headerView.currentTempLabel.alpha = min(1.0, (changeStartOffset - offset) / changeSpeed)
    }
}

//
//  MainTableViewController.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/26.
//

import UIKit

class MainTableViewController: UIViewController {
    let imageManager = ImageFileManager()
    
    static let identifier: String = "\(MainTableViewController.self)"
    var location: Location!
    var index = 0
//    var previousOffsetState: CGFloat = 0
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var mainTableViewTopConstrain: NSLayoutConstraint!
    
    weak var delegate: WeatherListCellDelegate?
    
    var viewModel: WeatherViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
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
        self.imageManager.delegate = self
        getWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print( "뷰가 다시 나타납니다 뷰가 다시 나타납니다 뷰가 다시 나타납니다" )
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
//        return 1
        return WeatherTableViewSection.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard viewModel != nil else { return 1 }
//        return 11
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
//        guard (viewModel?.weekendTableViewCell.value?.count)! != 0 else { return UITableViewCell() }
//        print("indexPath.row \(indexPath.row)")
//        switch indexPath.row {
//        case  1:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.registerID, for: indexPath) as? HourlyTableViewCell,
//                  let hourdatas = viewModel?.hourlyTableViewCell else { return UITableViewCell() }
//            cell.passHourDatas(hourData: hourdatas)
//            return cell
//
//        case 2...8:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekendTableViewCell.registerID, for: indexPath) as? WeekendTableViewCell,
//                  let weekendDatas = viewModel?.weekendTableViewCell.value else { return UITableViewCell() }
//            var index = 0
//            cell.setWeekendData(weekendData: weekendDatas[index])
//            index += 1
//            return cell
//
//        case 9:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "longdescriptioncell", for: indexPath)
//            cell.textLabel?.text = viewModel?.weatherDescription ?? ""
//            return cell
//
//        case 10:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.registerID, for: indexPath) as? DetailTableViewCell,
//                let detailDatas = viewModel?.detailTableViewCell  else { return UITableViewCell() }
//            cell.passDetailDatas(detailData: detailDatas)
//            return cell
//
//        case 11:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "linkcell", for: indexPath)
//            cell.textLabel?.text = "자료가 없습니다"
//            return cell
//        default:
//            print("해당하는 셀을 생성하지 못했습니다")
//            return UITableViewCell()
//        }
//        return UITableViewCell()
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
               headerView.backgroundConfiguration = .clear()
               return headerView
             }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 380
        
        if section == 0 {
        return CGFloat(380)
        }

        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 1:
//            return 133
//        case 2...8:
//            return 44
//        case 9:
//            return 43.5
//        case 10:
//            return 330
//        case 11:
//            return 43.5
//        default: return 0
//        }
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

//        let headerViewMaxHeight: CGFloat = 380
//        let headerViewMinHeight: CGFloat = 44 + UIApplication.shared.statusBarFrame.height
//        let newHeaderViewHeight: CGFloat = headerView.stackViewHeightAnchor.constant - offset
//
//        if offset > 400 {
//            headerView.stackViewHeightAnchor.constant = 100
//        }
//
//        let offsetDiff = previousOffsetState - offset
//        print("curretnOffset \(offset)")
//        print("previous offset \(previousOffsetState)")
//        print("offset Difference \(offsetDiff)")
//        previousOffsetState = offset
//        var constraintHeight = headerView.stackViewHeightAnchor.constant - offsetDiff
//        headerView.stackViewHeightAnchor.constant = constraintHeight
//        print("headerView.stackViewHeightAnchor.constant \(headerView.stackViewHeightAnchor.constant)")
//        }
    }
}

extension MainTableViewController: ImageDownloadCompleteDelegate {
    func ImageDownloadCompleteDelegate() {
        mainTableView.reloadSections([1, 2], with: .automatic)
    }
}

//
//  searchViewController.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/07.
//

import UIKit

class LocationListViewController: UIViewController {
    static let identifier: String = "\(LocationListViewController.self)"
    private let coreDatas = CoreDataManager()
    
    weak var delegate: LocationListViewDelegate?
    
    @IBOutlet weak var weatherListView: UITableView!
    @IBOutlet weak var tempButton: UIButton!
    
    var listViewModel = WeatherListViewModel()
    var tempBtnImage = CoreDataManager.getCurrentTempBool() {
        didSet {
            if tempBtnImage {
                tempButton.setImage(UIImage(named: "C"), for: .normal)
            } else {
                tempButton.setImage(UIImage(named: "F"), for: .normal)
            }
            weatherListView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherListView.register(UINib(nibName: "ListViewTableViewCell", bundle: nil), forCellReuseIdentifier: ListViewTableViewCell.registerID)
        self.weatherListView.delegate = self
        self.weatherListView.dataSource = self
        self.listViewModel.locationList.bind { [weak self] _ in
            self!.weatherListView.reloadData()
            }
        self.listViewModel.temperatureUnit.bind { [weak self] _ in
            self!.weatherListView.reloadData()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let temperatureUnit = TemperatureUnit.shared.unit
        if listViewModel.temperatureUnit.value != temperatureUnit {
            listViewModel.temperatureUnit.value = temperatureUnit
        }
    }
    
    @IBAction func addLocationBtnTouched(_ sender: Any) {
        let subStoryBoard = UIStoryboard(name: "Mainsub", bundle: nil)
        guard let searchViewController = subStoryBoard.instantiateViewController(identifier: SearchViewController.identifier) as? SearchViewController else {
            print(CreationError.toSearchViewController)
            return
        }
        searchViewController.delegate = self
        self.present(searchViewController, animated: true, completion: nil)
    }
    
    @IBAction func tempBtnTouched(_ sender: Any) {
        coreDatas.toggleTempBool()
        TemperatureUnit.shared.setUnit(with: CoreDataManager.getCurrentTempBool())
        tempBtnImage.toggle()
        print("tempBtnImage.toggle() \(tempBtnImage)")
    }
    
    @IBAction func wepIconTouched(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.weather.go.kr/weather/forecast/timeseries.jsp")!, options: [:], completionHandler: nil)
    }
}

extension LocationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listViewModel.locationList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let cellType = LocationListCellType(rowIndex: indexPath.row) else {
            return false
        }
        return cellType.canEditRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = listViewModel.locationList.value else { return UITableViewCell()}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListViewTableViewCell.registerID , for: indexPath) as? ListViewTableViewCell else { return UITableViewCell() }
        cell.setWeatherData(from: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDatas.deleteDataLocation(stateName: listViewModel.locationList.value![indexPath.row].state, entityName: coreDatas.dataLocationModelName)
            coreDatas.deleteDataLocation(stateName: listViewModel.locationList.value![indexPath.row].state, entityName: coreDatas.listViewDataModelName)
            listViewModel.locationList.value!.remove(at: indexPath.row)
            }
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.delegate?.userDeleteLocation(at: indexPath.row)
        }
    }

extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let time = self.listViewModel.locationList.value?[indexPath.row].backgrounTime ?? "0"
        let image = UIColor(patternImage: UIImage(named: ImageBackgroundType(Int(time) ?? 0).rawValue)!)
        self.delegate?.userDidSelectLocation(at: indexPath.row,
                                             image: image)
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationListViewController: SearchViewDelegate {
    func userSelected(newLocation: Location) {
        self.listViewModel.convertLocationToCellData(newLocation)
        self.delegate?.userAdd(newLocation: newLocation)
    }
}

extension LocationListViewController: WeatherListCellDelegate {
    func WeatherListCellDelegate(cellData: WeatherListViewCell, index: Int) {
        coreDatas.saveOrUpdateListViewData(cellData)
        listViewModel.locationList.value?[index] = cellData
    }
}

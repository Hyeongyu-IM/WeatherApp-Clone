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
//    var locations = [Location]()
    
    weak var delegate: LocationListViewDelegate?
    
    
    @IBOutlet weak var weatherListView: UITableView!
    @IBOutlet weak var tempToggleBtn: UIButton!
    
    var listViewModel = WeatherListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherListView.register(UINib(nibName: "ListViewTableViewCell", bundle: nil), forCellReuseIdentifier: ListViewTableViewCell.registerID)
        self.weatherListView.delegate = self
        self.weatherListView.dataSource = self
        self.tempToggleBtn.isSelected = !TemperatureUnit.shared.boolValue
        listViewModel.locationList.bind { [weak self] _ in
            self!.weatherListView.reloadData()
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
    
    @IBAction func tempChangeBtnTouched(_ sender: UIButton) {
        TemperatureUnit.shared.setUnit(with: sender.isSelected)
    }
    
    
    
}

extension LocationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.listViewModel.locationList.value?.count)
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
        print("data[indexPath.row]-->\(data[indexPath.row])")
        cell.setWeatherData(from: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDatas.deleteDataLocation(stateName: listViewModel.locationList.value![indexPath.row].state, entityName: coreDatas.dataLocationModelName)
            coreDatas.deleteDataLocation(stateName: listViewModel.locationList.value![indexPath.row].state, entityName: coreDatas.listViewDataModelName)
            listViewModel.locationList.value!.remove(at: indexPath.row)
            }
        print([indexPath])
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.delegate?.userDeleteLocation(at: indexPath.row)
        }
    }

extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print( "현재 인덱스가 클릭되었습니다 \(indexPath)" )
        let time = self.listViewModel.locationList.value?[indexPath.row].backgrounTime ?? "0"
        let image = UIColor(patternImage: UIImage(named: ImageBackgroundType(Int(time) ?? 0).rawValue)!)
        self.delegate?.userDidSelectLocation(at: indexPath.row,
                                             image: image)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LocationListViewController: SearchViewDelegate {
    func userSelected(newLocation: Location) {
//        let savingList = Array(locations[1..<locations.count])
        // 추가되고 리스트뷰에 데이터를 표시
        self.listViewModel.convertLocationToCellData(newLocation)
        self.delegate?.userAdd(newLocation: newLocation)
//        self.weatherListView.reloadData()
    }
}

extension LocationListViewController: WeatherListCellDelegate {
    func WeatherListCellDelegate(cellData: WeatherListViewCell, index: Int) {
        print("WeatherListCellDelegate --> 리스트뷰 델리게잇 메서드가 실행되었습니다. ")
        coreDatas.saveOrUpdateListViewData(cellData)
        listViewModel.locationList.value?[index] = cellData
    }
}

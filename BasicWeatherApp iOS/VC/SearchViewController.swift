//
//  ViewController.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/07.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController {
    @IBOutlet weak var customSearchBar: UISearchBar!
    @IBOutlet weak var blurView: UIView!
    
    static let identifier: String = "\(SearchViewController.self)"
    private var tableView: UITableView!
    private var tableDataSource: GMSAutocompleteTableDataSource!
    
    weak var delegate: SearchViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configAutoComplete()
    }
    
    private func configAutoComplete() {
        customSearchBar.delegate = self
        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource.delegate = self
        tableView = UITableView(frame: CGRect(x: 0, y: 105, width: self.view.frame.size.width, height: self.view.frame.size.height - 44))
            tableView.delegate = tableDataSource
            tableView.dataSource = tableDataSource
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        tableDataSource.autocompleteFilter = filter
        blurView.addSubview(tableView)
        
        // tableView 속성 편집
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableDataSource.tableCellBackgroundColor = .clear
        tableDataSource.tableCellSeparatorColor = .clear
        tableDataSource.primaryTextHighlightColor = .white
        
        // searchBar 속성 편집
        customSearchBar.barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}

extension SearchViewController: GMSAutocompleteTableDataSourceDelegate, UISearchBarDelegate  {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        tableView.reloadData()
      
    }

      func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        tableView.reloadData()
      }

      func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
            self.delegate?.userSelected(newLocation: Location(name: place.name, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
            self.dismiss(animated: true, completion: nil)
      }

      func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
      }

      func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
      }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableDataSource.sourceTextHasChanged(searchText)
      }
}




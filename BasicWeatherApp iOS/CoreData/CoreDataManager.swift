//
//  CoreDataManager.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/12.
//

import UIKit
import CoreData

class CoreDataManager {
    
    let dataLocationModelName: String = "DataLocation"
    let listViewDataModelName: String = "ListViewData"
    private let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    private let dataFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DataLocation")
    private let locationListfetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListViewData")
    
    // 저장된 데이터 받아오기
    func getDataLocationList() -> [Location] {
           var models = [Location]()

            do {
                if let result: [DataLocation] = try context?.fetch(dataFetchRequest) as? [DataLocation] {
                  models = result.map { Location(name: $0.stateName ?? "" , latitude: $0.latitude, longitude: $0.longitude) }
                   }
               } catch let error as NSError {
                   print("Could not fetch: \(error), \(error.userInfo)")
               }
//            print("models 입니다 \(models)")
        return models
        }
    
    func getListViewData() -> [WeatherListViewCell] {
        var models = [WeatherListViewCell]()
        do {
            if let result: [ListViewData] = try context?.fetch(locationListfetchRequest) as? [ListViewData] {
                models = result.map { WeatherListViewCell(time: $0.time ?? "" , state: $0.stateName ?? "", currentTempC: $0.temperature ?? "") }
               }
           } catch let error as NSError {
               print("Could not fetch: \(error), \(error.userInfo)")
           }
            print("models 입니다 \(models)")
    return models
    }

    // saveLocation
    func saveORUpdateDataLocation(_ location: Location ) {
        let entity = NSEntityDescription.entity(forEntityName: dataLocationModelName, in: context!)
        let filter = filteredDataLocationRequest(lattitude: location.latitude)
        
        do {
            let datas = try context!.fetch(filter) as! [NSManagedObject]
            var cell: DataLocation! = nil
            if datas.count == 0 {
                cell = NSManagedObject(entity: entity!, insertInto: context!) as? DataLocation
            } else {
                cell = datas.first as? DataLocation
            }
            cell.latitude = location.latitude
            cell.longitude = location.longitude
            cell.stateName = location.name ?? ""
        } catch {
            print("Failed")
        }
        
        do {
            try context?.save()
            print("Save Succes")
        } catch {
            print("Failed To Saving")
        }
//
//        let object = NSEntityDescription.insertNewObject(forEntityName: dataLocationModelName, into: context!)
//        object.setValue(location.latitude, forKey: "latitude")
//        object.setValue(location.longitude, forKey: "longitude")
//        object.setValue(location.name, forKey: "stateName")
//
//        do{
//            try context?.save()
//            return
//        } catch {
//            context?.rollback()
//            }
//        return
        }
    
    // saveListViewData
    func saveOrUpdateListViewData(_ cellData: WeatherListViewCell) {
        let entity = NSEntityDescription.entity(forEntityName: listViewDataModelName, in: context!)
        let filter = filteredListLocationRequest(stateName: cellData.state)
        
        do {
            let datas = try context!.fetch(filter) as! [NSManagedObject]
            var cell: ListViewData! = nil
            if datas.count == 0 {
                cell = NSManagedObject(entity: entity!, insertInto: context!) as? ListViewData
            } else {
                cell = datas.first as? ListViewData
            }
            cell.stateName = cellData.state
            cell.temperature = cellData.currentTempC
            cell.time = cellData.time
        } catch {
            print("Failed")
        }
        
        do {
            try context?.save()
            print("Save Succes")
        } catch {
            print("Failed To Saving")
        }
        
//        let object = NSEntityDescription.insertNewObject(forEntityName: listViewDataModelName, into: context!)
//        object.setValue(cellData.dt, forKey: "time")
//        object.setValue(cellData.currentTempC, forKey: "temperature")
//        object.setValue(cellData.state, forKey: "stateName")
//
//        do{
//            try context?.save()
//            print("데이터 저장성공")
//            return
//        } catch {
//            context?.rollback()
//            print("데이터 저장실패")
//            }
//        print("데이터 저장실패")
//        return
        }
    
    // deleteLocation 셀 지울때 메서드 호출 ( latitude 매개변수 )
    func deleteDataLocation(stateName: String, entityName: String) {
        let deleteRequest: NSFetchRequest<NSFetchRequestResult> = filteredListLocationRequest(stateName: stateName)
        switch entityName {
        case dataLocationModelName:
            do {
                if let results: [DataLocation] = try context?.fetch(deleteRequest) as? [DataLocation] {
                if results.count != 0 {
                             context?.delete(results[0])
                           }
                       }
                   } catch let error as NSError {
                       print("Could not fatch: \(error), \(error.userInfo)")
                   }
            do {
                    try context?.save()
                    print("코어데이터 삭제 성공")
                    return
                } catch {
                    context?.rollback()
                    print("실행 불가능 합니다")
                    return
                    }
        case listViewDataModelName:
            do {
                if let results: [DataLocation] = try context?.fetch(deleteRequest) as? [DataLocation] {
                if results.count != 0 {
                             context?.delete(results[0])
                           }
                       }
                   } catch let error as NSError {
                       print("Could not fatch: \(error), \(error.userInfo)")
                   }
            do {
                    try context?.save()
                    print("코어데이터 삭제 성공")
                    return
                } catch {
                    context?.rollback()
                    print("실행 불가능 합니다")
                    return
                    }
        default: break
        }
    }
    
    // 현재위치 업데이트 앱 시작시 메서드 호출
    func updateListViewDatas(_ cellData: WeatherListViewCell,_ pageIndex: Int) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: listViewDataModelName)
        do {
            let data: [ListViewData] = try (context?.fetch(fetchRequest) as? [ListViewData])!
            let objectUpdate = data[pageIndex]
            objectUpdate.setValue(cellData.time, forKey: "time")
            objectUpdate.setValue(cellData.currentTempC, forKey: "temperature")
            objectUpdate.setValue(cellData.state, forKey: "stateName")
            do {
                try context?.save()
            } catch {
                print("update Error \(error)")
            }
        } catch {
            print(error)
        }
    }
    
    
    func deleteAllDataLocation() {
        let fetrequest = NSFetchRequest<NSFetchRequestResult>(entityName: dataLocationModelName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetrequest)
        
        do {
            try context?.execute(batchDeleteRequest)
            print("데이터 모두 삭제")
        } catch {
            print(error)
        }
    }
    
    //MARK: -ListViewData
    
}
   

extension CoreDataManager {
    fileprivate func filteredDataLocationRequest(lattitude: Double) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: dataLocationModelName)
        fetchRequest.predicate = NSPredicate(format: "latitude = %@", "\(lattitude)")
        return fetchRequest
    }
    
    fileprivate func filteredListLocationRequest(stateName: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: listViewDataModelName)
        fetchRequest.predicate = NSPredicate(format: "stateName = %@", NSString(string: stateName))
        return fetchRequest
    }
}

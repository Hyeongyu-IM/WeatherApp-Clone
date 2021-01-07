//
//  DetailTableViewCell.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/28.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    static let registerID: String = "\(DetailTableViewCell.self)"
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.backgroundColor = .clear
        collectionView.backgroundColor = .clear
    }
    
    private var detailData: DetailCell?
    
    func registerCell() {
        collectionView.register(UINib(nibName: "DetailTableCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DetailTableCollectionViewCell.registerID)
    }
    
    func passDetailDatas( detailData: DetailCell) {
        self.detailData = detailData
        collectionView.reloadData()
    }
}

extension DetailTableViewCell: UICollectionViewDelegate {
    
}

extension DetailTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let detailData = self.detailData {
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailTableCollectionViewCell.registerID, for: indexPath) as? DetailTableCollectionViewCell,
              let detailData = detailData else { return UICollectionViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.setDetailData("일출", detailData.sunrise)
            return cell
            
        case 1:
            cell.setDetailData("일몰", detailData.sunset)
            return cell
            
        case 2:
            cell.setDetailData("눈 올 확률", detailData.snow ?? "")
            return cell
            
        case 3:
            cell.setDetailData("습도", detailData.humidity)
            return cell
            
        case 4:
            cell.setDetailData("바람", detailData.wind)
            return cell
            
        case 5:
            cell.setDetailData("체감", detailData.feelsLike)
            return cell
            
        case 6:
            cell.setDetailData("강수량", detailData.rain ?? "")
            return cell
            
        case 7:
            cell.setDetailData("기압", detailData.pressure)
            return cell
            
        case 8:
            cell.setDetailData("가시거리", detailData.visibility)
            return cell
            
        case 9:
            cell.setDetailData("자외선지수", detailData.uvi)
            return cell
            
        default:
            break
            }
        return cell
    }
}

extension DetailTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.maxX - 80) / 2, height: 60)
    }
}

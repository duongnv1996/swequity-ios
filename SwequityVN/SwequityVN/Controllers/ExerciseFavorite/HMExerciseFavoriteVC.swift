//
//  HMExerciseFavoriteVC.swift
//  SwequityVN
//
//  Created by Tung QT on 8/2/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HMExerciseFavoriteVC: HMBaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var categoryId: String?
    var sessionId: String?
    var type:HMListType = .list
    
    // MARK: - Constants
    private let disposeBag = DisposeBag()
    private let listTasks: BehaviorRelay<[HMExDetailEntity]> = BehaviorRelay(value: [])

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        setupTableView()
    }
    
    private func setupTableView() {
        collectionView.registerNibCellFor(type: HMExerciseFavoriteCell.self)
        
        listTasks.bind(to: collectionView.rx.items(cellIdentifier: "HMExerciseFavoriteCell", cellType: HMExerciseFavoriteCell.self)) { row, model, cell in
            cell.delegate = self
            cell.data = model
            }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(HMExDetailEntity.self).subscribe(onNext: { exercise in
            if (self.type == .list) {
                HMExeciseDetailVC.push(prepare: { vc in
                    vc.exerciseId = exercise.id
                })
            } else {
                HMAddExerciseInSessionAPI.init(sessionId: self.sessionId ?? "", exId: exercise.id).execute(target: self, success: { (response) in
                    switch response.errorId {
                    case HMErrorCode.success.rawValue:
                        self.pop()
                        break
                    case HMErrorCode.error.rawValue:
                        UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
                    default:
                        break
                    }
                }, failure: { (error) in
                    
                })
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Management Data
    private func fetchData() {
        if let categoryId = categoryId {
            HMExerciseFavouriteListAPI(categoryId: categoryId).execute(target: self, success: {[weak self] (response) in
                self?.listTasks.accept(response.favouriteList)
            }) { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            }
        }
    }
}

extension HMExerciseFavoriteVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 35, left: 22, bottom: 35, right: 22)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 74) / 2
        let height = width + 75
        return CGSize(width: width, height: height)
    }
}

extension HMExerciseFavoriteVC: HMExerciseFavoriteDelegate {
    func tapToFavorite(data: HMExDetailEntity?, type: HMFavouriteType) {
        if let data = data {
            HMExerciseFavouriteAPI(id: data.id, type: type).execute(target: self, success: {[weak self] (response) in
                self?.fetchData()
                }, failure: { (error) in
                    UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            })
        }
    }
}

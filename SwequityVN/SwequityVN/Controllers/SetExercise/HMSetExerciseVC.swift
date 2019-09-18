//
//  HMSetExerciseVC.swift
//  SwequityVN
//
//  Created by Tung QT on 8/7/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON
import Alamofire

protocol HMSetExerciseVCDelegate: NSObject {
    func moveToNextEx(id: String?, exId: String?)
    func moveToPreviousEx(exId: String?)
    func moveToEx(id: String, exId: String?)
    func moveToRootEx()
}

class HMSetExerciseVC: HMBaseVC {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let listExercise: BehaviorRelay<[HMSetsDetailEntity]> = BehaviorRelay(value: [])
    
    var programId: String?
    var sessionId:String?
    var exId:String?
    var id:String?
    var img:String?
    var breakTime:String?
    var sets:String?
    var isLinked:Bool = true
    
    weak var delegate: HMSetExerciseVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURL = URL(string: self.img ?? "") {
            self.bannerImageView.kf.setImage(with: imageURL)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        HMSharedData.timeStartWithEx = Date()
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNibCellFor(type: HMSetExerciseCell.self)
        
        listExercise.bind(to: tableView.rx.items(cellIdentifier: "HMSetExerciseCell", cellType: HMSetExerciseCell.self)) { row, model, cell in
            cell.delegate = self
            let roundOfEx = Int (self.getRoundOfExercise()) ?? 0
            if row <= roundOfEx {
                cell.type = .highlight
            } else {
                cell.type = .normal
            }
            cell.setContentWithEntity(entity: model, with: row)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HMSetExerciseCell.self).subscribe(onNext: {exercise in
            
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Management data
    private func fetchData() {
        HMExerciseInSessionDetailAPI.init(sessionId: self.sessionId ?? "", exId: self.exId ?? "").execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                self.listExercise.accept(response.listEx)
                self.heightTableView.constant = CGFloat(46 * response.listEx.count)
                break
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            
        })
    }

    @IBAction func tapToSave(_ sender: Any) {
        var parameter: Parameters = Parameters()
        let listParameterDict = self.getParameterForEx()
        
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: listParameterDict),
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8) {
            parameter = [
                "user_id": HMSharedData.userId!,
                "session_id": self.sessionId ?? "",
                "ex_id": self.exId ?? "",
                "sets": theJSONText]
            HMUpdateRoundAPI.init(parameter: parameter).execute(target: self, success: { (response) in
                
            }, failure: { (error) in
                
            })
        }
    }
    
    @IBAction func tapToCountAndSave(_ sender: Any) {
        var parameter: Parameters = Parameters()
        let listParameterDict = self.getParameterForEx()
        
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: listParameterDict),
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8) {
            parameter = [
                "user_id": HMSharedData.userId!,
                "session_id": self.sessionId ?? "",
                "ex_id": self.exId ?? "",
                "sets": theJSONText]
            HMUpdateRoundAPI.init(parameter: parameter).execute(target: self, success: { (response) in
                if (self.listExercise.value.count > 0) {
                    self.presentCountDownView()
                } else {
                    self.delegate?.moveToNextEx(id: self.id, exId: self.exId)
                }
            }, failure: { (error) in
                
            })
        }
    }
    
    @IBAction func didTapEndSession(_ sender: UIButton) {
        let date = Date()
        let dateStr = date.stringBy(format: Date.dateFormat)
        var parameter: Parameters = Parameters()
        parameter = [
            "session_id": self.sessionId ?? "",
            "name": self.exId ?? "",
            "date": dateStr,
            "user_id": HMSharedData.userId!,
            "program_id": self.programId ?? ""]
        let timeEndEx = Date()
        let second = Date.secondBetween(start: HMSharedData.timeStartWithEx ?? Date(), end: timeEndEx)
        HMUpdateTimeCompleteExAPI.init(sessionId: self.sessionId ?? "", exId: self.exId ?? "", time: String(second)).execute(target: self, success: { (response) in
            HMUpdateDiaryTrainingAPI.init(programId: self.programId ?? "", exId: self.exId ?? "").execute(target: self, success: { (response) in
                HMUpdateSessionAPI.init(parameter: parameter).execute(target: self, success: { (response) in
                    self.resetValueWithEx()
                    HMStatisticalSessionVC.push(prepare: { vc in
                        vc.sessionId = self.sessionId
                        vc.programId = self.programId
                    }, completion: nil)
                }, failure: {(error) in
                    
                })
            }, failure: { (error) in
                
            })
        }, failure: { (error) in
            
        })
    }
    
    
    //MARK - Private methods
    func presentCountDownView() {
        let countDownVC = HMCountDownVC.create()
        countDownVC.sessionId = self.sessionId
        countDownVC.exId = self.exId
        countDownVC.listExercise = self.listExercise.value
        countDownVC.delegate = self
        countDownVC.timeCountDown = Double(self.breakTime ?? "0") ?? 0
        let popupVC = HMPopUpViewController(contentController: countDownVC, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
        popupVC.backgroundAlpha = 0.3
        popupVC.cornerRadius = 0
        popupVC.shadowEnabled = false
        present(popupVC, animated: true, completion: nil)
    }
    
    func getRoundOfExercise() -> String {
        var value = "0"
        let dictSession:Dictionary = HMSharedData.exerciseHadTrain ?? [:]
        if let sessionId = self.sessionId {
            if Array(dictSession.keys).contains(sessionId) {
                let dictEx:Dictionary = dictSession[sessionId] ?? [:]
                if let exerciseId = self.exId {
                    if Array(dictEx.keys).contains(exerciseId) {
                        value = dictEx[exerciseId] ?? "0"
                    }
                }
            }
        }
        
        return value
    }
    
    func updateRoundOfExercise() {
        var round = Int(getRoundOfExercise()) ?? 0
        round = round + 1
        var dictSession = HMSharedData.exerciseHadTrain ?? [:]
        if let sessionId = self.sessionId {
            var dictEx = dictSession[sessionId] ?? [:]
            if let exerciseId = self.exId {
                dictEx.updateValue(String(round), forKey: exerciseId)
            }
            dictSession.updateValue(dictEx, forKey: sessionId)
        }
        HMSharedData.exerciseHadTrain = dictSession
    }
    
    func moveToNexExAndUpdateRound() {
        var round = Int(getRoundOfExercise()) ?? 0
        round = round + 1
        var dictSession = HMSharedData.exerciseHadTrain ?? [:]
        if let sessionId = self.sessionId {
            var dictEx = dictSession[sessionId] ?? [:]
            if let exerciseId = self.exId {
                dictEx.updateValue(String(round), forKey: exerciseId)
            }
            dictSession.updateValue(dictEx, forKey: sessionId)
        }
        HMSharedData.exerciseHadTrain = dictSession
        
        if (round >= self.listExercise.value.count) {
            self.delegate?.moveToEx(id: self.id!, exId: self.exId ?? "0")
        }
    }
    
    func resetValueWithEx() {
        let dictSession:Dictionary = HMSharedData.exerciseHadTrain ?? [:]
        if let sessionId = self.sessionId {
            var dictEx = dictSession[sessionId] ?? [:]
            if let exId = self.exId {
                dictEx.removeValue(forKey: exId)
            }
        }
        HMSharedData.exerciseHadTrain = dictSession
    }
    
    func getParameterForEx() -> [[String: Any]] {
        var listParameterDict = [[String: Any]]()
        for entity in self.listExercise.value {
            let parameterDict:[String: Any] = ["rm": Int(entity.rm) ?? 0,
                                               "isCount": false,
                                               "number": Int(entity.number) ?? 0,
                                               "break_time": Int(entity.break_time ?? "0") ?? 0,
                                               "weight": Int(entity.weight) ?? 0]
            listParameterDict.append(parameterDict)
        }
        return listParameterDict
    }
    
    func isHaveLinked(id: String) -> Bool {
        var dictEx:Dictionary = HMSharedData.linkExercise ?? [:]
        if Array(dictEx.keys).contains(id) {
            guard let _ = dictEx[id] else {
                return false
            }
            return true
        }
        return false
    }
    
    func isLinked(id: String) -> Bool {
        let dictEx:Dictionary = HMSharedData.linkExercise ?? [:]
        for (_, value) in dictEx {
            if value == id {
                return true
            }
        }
        return false
    }
    
}

extension HMSetExerciseVC : HMSetExerciseCellDelegate {
    func didTapDeleteEx(at cell: HMSetExerciseCell) {
        var listEx = self.listExercise.value
        if let indexPath = tableView.indexPath(for: cell) {
            listEx.remove(at: indexPath.row)
        }
        self.listExercise.accept(listEx)
    }
    
    func changeValueEx(weight: String, reps: String, rm: String, at cell: HMSetExerciseCell) {
        var listEx = self.listExercise.value
        if let indexPath = tableView.indexPath(for: cell) {
            var entity:HMSetsDetailEntity = listEx[indexPath.row]
            entity.weight = weight
            entity.number = reps
            entity.rm = rm
            listEx[indexPath.row] = entity
        }
        self.listExercise.accept(listEx)
    }
}

extension HMSetExerciseVC : HMCountDownVCDelegate {
    func updateValueRoundEx() {
        if let id = self.id {
            //Check bài tập đấy có link bài khác không
            if self.isHaveLinked(id: id) {
                updateRoundOfExercise()
                self.delegate?.moveToNextEx(id: self.id, exId: self.exId)
                return
            } else {
                //Check bài tập đấy có đc bài khác link không
                if self.isLinked(id: id) {
                    //Check đủ số hiệp chưa. Nếu chưa thì rollback, rồi thì chuyển bài tiếp
                    let round = Int(getRoundOfExercise()) ?? 0
                    if let setString = self.sets {
                        if let sets = Int(setString) {
                            if round < sets - 1 {
                                updateRoundOfExercise()
                                self.delegate?.moveToRootEx()
                                return
                            } else {
                                updateRoundOfExercise()
                                self.delegate?.moveToEx(id: id, exId: self.exId)
                                return
                            }
                        }
                    }
                }
            }
        }
        self.moveToNexExAndUpdateRound()
        self.tableView.reloadData()
    }
}

//
//  HMListSetExVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 8/11/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class HMListSetExVC: HMBasePageMenuVC {

    var menuIds: [HMExerciseInSessionDetailEntity?] = []
    var sessionId: String?
    var programId: String?
    var dictExLinked:[String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dictExLinked = HMSharedData.linkExercise ?? [:]
        iconTitles = Array(repeating: "icon_analysis", count: menuTitles.count)
        viewControllers = menuIds.compactMap({
            let vc = HMSetExerciseVC.create()
            vc.sessionId = self.sessionId
            vc.programId = self.programId
            vc.exId = $0?.ex_id
            vc.img = $0?.img
            vc.breakTime = $0?.break_time
            vc.sets = $0?.sets
            vc.id = $0?.id
            vc.delegate = self
            return vc
        })
        
        if self.menuIds.count > 0 {
            HMSharedData.rootEx = self.menuIds[0]?.id
        }
    }
    
    override func setupView() {
        super.setupView()
        titleScreen = "Bắt đầu buổi tập"
    }
    
    func resetValueWithEx(exId: String?) {
        let dictSession:Dictionary = HMSharedData.exerciseHadTrain ?? [:]
        if let sessionId = self.sessionId {
            var dictEx = dictSession[sessionId] ?? [:]
            if let exId = exId {
                dictEx.removeValue(forKey: exId)
            }
        }
        HMSharedData.exerciseHadTrain = dictSession
    }

}

extension HMListSetExVC :HMSetExerciseVCDelegate {
    func moveToNextEx(id: String?, exId: String?) {
        let date = Date()
        let dateStr = date.stringBy(format: Date.dateFormat)
        var parameter: Parameters = Parameters()
        parameter = [
            "session_id": self.sessionId ?? "",
            "name": exId ?? "",
            "date": dateStr,
            "user_id": HMSharedData.userId!,
            "program_id": self.programId ?? ""]
        let timeEndEx = Date()
        let second = Date.secondBetween(start: HMSharedData.timeStartWithEx ?? Date(), end: timeEndEx)
        HMUpdateTimeCompleteExAPI.init(sessionId: self.sessionId ?? "", exId: exId ?? "", time: String(second)).execute(target: self, success: { (response) in
            HMUpdateDiaryTrainingAPI.init(programId: self.programId ?? "", exId: exId ?? "").execute(target: self, success: { (response) in
                HMUpdateSessionAPI.init(parameter: parameter).execute(target: self, success: { (response) in
                    if let entityLast = self.menuIds.last {
                        if entityLast?.id == id {
                            self.resetValueWithEx(exId: exId)
                            HMStatisticalSessionVC.push(from: self, prepare: { vc in
                                vc.sessionId = self.sessionId
                                vc.programId = self.programId
                            }, completion: nil)
                        } else {
                            self.pagingViewController.pageViewController.scrollForward(animated: true, completion: nil)
                        }
                    }
                }, failure: {(error) in
                    
                })
            }, failure: { (error) in
                
            })
        }, failure: { (error) in
            
        })
        
    }
    
    //Call để di chuyển sang vòng tập tiếp theo, các bài tập là xong hết
    func moveToEx(id: String, exId: String?) {
        for (index, value) in self.menuIds.enumerated() {
            if value?.id == id && index < self.menuIds.count - 1 {
                HMSharedData.rootEx = self.menuIds[index + 1]?.id
            }
        }
        self.moveToNextEx(id: id, exId: exId)
    }
    
    //Call khi quay lại vòng của bài tập
    func moveToRootEx() {
        let id = HMSharedData.rootEx
        for (index, value) in self.menuIds.enumerated() {
            if value?.id == id {
                self.pagingViewController.select(index: index)
            }
        }
    }
    
    func moveToPreviousEx(exId: String?) {
        if let entityFirst = self.menuIds.first {
            if entityFirst?.ex_id != exId {
                self.pagingViewController.pageViewController.scrollReverse(animated: true, completion: nil)
            }
        }
    }
}

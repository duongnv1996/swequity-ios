//
//  HMNutritionGoalEntity.swift
//  SwequityVN
//
//  Created by Tung QT on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMNutritionGoal001Entity: NSObject {
    var titleName: String = ""
    var subTitle001: String = ""
    var subTitle002: String = ""
    var subTitle003: String = ""
    var weightCurrent: String = ""
    var weightTarget: String = ""
    var fatPercent: String = ""
    var currentDate: String = ""
    var targetDate: String = ""
    
    init(titleName: String = "", subTitle001: String = "", subTitle002: String = "", subTitle003: String = "", weightCurrent: String = "", weightTarget: String = "", fatPercent: String = "", currentDate: String = "", targetDate: String = "") {
        self.titleName = titleName
        self.subTitle001 = subTitle001
        self.subTitle002 = subTitle002
        self.subTitle003 = subTitle003
        self.weightCurrent = weightCurrent
        self.weightTarget = weightTarget
        self.fatPercent = fatPercent
        
        let newCurrentDateFormat = Date.getDateBy(string: currentDate, format: Date.dateTimeFullFormat)
        self.currentDate = newCurrentDateFormat?.stringBy(format: Date.dateFormat) ?? ""
        let newTargetDateFormat = Date.getDateBy(string: targetDate, format: Date.dateTimeFullFormat)
        self.targetDate = newTargetDateFormat?.stringBy(format: Date.dateFormat) ?? ""
    }
}

class HMNutritionGoal002Entity: NSObject {
    var titleName: String = ""
    var foods: [HMFoodDetailEntity] = []
    var favFoods: [HMFoodDetailEntity] = []
    var subTitleName: String = ""
    var caloValue: String = ""
    
    init(titleName: String = "", foods: [HMFoodDetailEntity] = [], favFoods: [HMFoodDetailEntity] = [], subTitleName: String = "", caloValue: String = "") {
        self.titleName = titleName
        self.foods = foods
        self.subTitleName = subTitleName
        self.caloValue = caloValue
    }
}

class HMNutritionGoal003Entity: NSObject {
    var titleName: String = ""
    var foods: [HMFoodDetailEntity] = []
    
    init(titleName: String = "", foods: [HMFoodDetailEntity] = []) {
        self.titleName = titleName
        self.foods = foods
    }
}

class HMNutritionGoal004Entity: NSObject {
    var titleName: String = ""
    var statusTort: String = ""
    
    init(titleName: String = "", statusTort: String = "") {
        self.titleName = titleName
        self.statusTort = statusTort
    }
}

class HMNutritionGoal005Entity: NSObject {
    var titleName: String = ""
    var caloValue: String = ""
    var elementFoods: [ElementFood] = []
    
    init(titleName: String = "", caloValue: String = "", elementFoods: [ElementFood]) {
        self.titleName = titleName
        self.caloValue = caloValue
        self.elementFoods = elementFoods
    }
}

class ElementFood: NSObject {
    var titleName: String = ""
    var percent: Int = 0
    var calo: Double = 0
    
    init(titleName: String = "", percent: Int = 0, calo: Double = 0) {
        self.titleName = titleName
        self.percent = percent
        self.calo = calo
    }
}

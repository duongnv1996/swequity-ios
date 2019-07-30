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
        self.currentDate = currentDate
        self.targetDate = targetDate
    }
}

class HMNutritionGoal002Entity: NSObject {
    var titleName: String = ""
    var foods: [String] = []
    var subTitleName: String = ""
    var caloValue: String = ""
    
    init(titleName: String = "", foods: [String] = [], subTitleName: String = "", caloValue: String = "") {
        self.titleName = titleName
        self.foods = foods
        self.subTitleName = subTitleName
        self.caloValue = caloValue
    }
}

class HMNutritionGoal003Entity: NSObject {
    var titleName: String = ""
    var foods: [String] = []
    
    init(titleName: String = "", foods: [String] = []) {
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
    var percent: String = ""
    var calo: String = ""
    
    init(titleName: String = "", percent: String = "", calo: String = "") {
        self.titleName = titleName
        self.percent = percent
        self.calo = calo
    }
}

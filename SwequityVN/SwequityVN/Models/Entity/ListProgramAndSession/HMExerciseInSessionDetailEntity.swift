//
//  HMExerciseDetailEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMExerciseInSessionDetailEntity: Decodable {
    let id: String
    let session_id: String
    let ex_id: String
    let name: String
    let sets: String
    let reps: String
    let break_time: String
    let date: String
    let time_finish: String
    let position: String
    let number_sets: String
    let is_working: String
    let key_join: String
    let active: String
    let img: String
    let finish: String
}

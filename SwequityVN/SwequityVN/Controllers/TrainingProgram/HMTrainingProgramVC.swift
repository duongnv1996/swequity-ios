//
//  HMTrainingProgramVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import TYCyclePagerView
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyJSON
import Alamofire

enum TrainingProgramCellModel<T> {
    case normal(T)
    case add
}
class HMTrainingProgramVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Detail View
    @IBOutlet weak var detailView: UIView!
    @IBOutlet private weak var pagerView: TYCyclePagerView!
    @IBOutlet private weak var pageControl: TYPageControl!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private var tableFooterView: UIView!
    
    // MARK: - Variables
    private var isDisplayList: Bool = true {
        didSet {
            collectionView.isHidden = !isDisplayList
            detailView.isHidden = isDisplayList
        }
    }
    private var isInvokeAddFromList: Bool = false {
        didSet {
            if isInvokeAddFromList &&  (pagerView.curIndex == listPrograms.count) {
                showCalender(type: .add)
            }
        }
    }
    private var sessionList: [HMSessionExDetailEntity] = []
    private var programTitle: String = ""
    private var programId: String?
    private var listPrograms: [HMProgramExDetailEntity] = [] {
        didSet {
            var datas: [TrainingProgramCellModel<HMProgramExDetailEntity>] = listPrograms.compactMap({
                return TrainingProgramCellModel.normal($0)
            })
            
            datas.append(TrainingProgramCellModel.add)
            listProgramDatas.accept(datas)
        }
    }
    
    // MARK: - Constants
    private let disposeBag = DisposeBag()
    private let listTasks: BehaviorRelay<[HMSessionExDetailEntity]> = BehaviorRelay(value: [])
    private let listProgramDatas: BehaviorRelay<[TrainingProgramCellModel<HMProgramExDetailEntity>]> = BehaviorRelay(value: [])
    
    var type:HMCalendarType = .add
    var dateString:String?
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.programId?.isEmpty ?? true {
            fetchData()
        } else {
            for (index, value) in self.listPrograms.enumerated()
            {
                if value.id == self.programId! {
                    self.pagerView.scrollToItem(at: index, animate: true)
                }
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        titleScreen = "Chương trình tập"
        
        isDisplayList = true
        setupTableView()
        setupPagerView()
        setupCollectionView()
        addRightBarbutton()
    }
    
    private func setupCollectionView() {
        collectionView.registerNibCellFor(type: HMTrainingProgramSlideCell.self)
        collectionView.registerNibCellFor(type: HMTrainingProgramAddSlideCell.self)
        
        listProgramDatas.bind(to: collectionView.rx.items) { collectionView, row, cellType in
            let indexPath = IndexPath(row: row, section: 0)
            switch cellType {
            case .normal(let data):
                guard let cell = collectionView.reusableCell(type: HMTrainingProgramSlideCell.self, indexPath: indexPath) else { return UICollectionViewCell() }
                cell.isDisplayDeleteButton = true
                cell.data = data
                cell.delegate = self
                return cell
            case .add:
                guard let cell = collectionView.reusableCell(type: HMTrainingProgramAddSlideCell.self, indexPath: indexPath) else { return UICollectionViewCell() }
                return cell
            }
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.pagerView.scrollToItem(at: indexPath.row, animate: false)
                self?.isDisplayList = false
                self?.isInvokeAddFromList = true
            }).disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.tableFooterView = tableFooterView
        
        tableView.registerNibCellFor(type: HMTrainingProgramDetailCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        listTasks.bind(to: tableView.rx.items(cellIdentifier: "HMTrainingProgramDetailCell", cellType: HMTrainingProgramDetailCell.self)) { row, model, cell in
            cell.delegate = self
            cell.setData(dto: model)
            cell.programId = self.programId
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HMSessionExDetailEntity.self).subscribe(onNext: { session in
            if self.type == .add {
                HMExerciseProgramVC.push(prepare: { vc in
                    vc.sessionDetail = session
                    vc.programId = self.programId
                })
            } else {
                let dateString = self.dateString ?? Date().stringBy(format: Date.dateFormat)
                var parameter: Parameters = Parameters()
                parameter = [
                    "session_id": session.id,
                    "name": "",
                    "date": dateString]
                HMUpdateSessionAPI.init(parameter: parameter).execute(target: self, success: { (response) in
                    self.pop()
                }, failure: {(error) in
                    
                })
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setupPagerView() {
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(UINib(nibName: "HMTrainingProgramSlideCell", bundle: nil), forCellWithReuseIdentifier: "HMTrainingProgramSlideCell")
        pagerView.register(UINib(nibName: "HMTrainingProgramAddSlideCell", bundle: nil), forCellWithReuseIdentifier: "HMTrainingProgramAddSlideCell")
        
        pagerView.isInfiniteLoop = false
        
        pageControl.numberOfPages = listPrograms.count + 1
        pageControl.pageIndicatorTintColor = UIColor(red: 151, green: 151, blue: 151)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 221, green: 110, blue: 53)
        pageControl.pageIndicatorSize = CGSize(width: 10, height: 10)
        pageControl.contentHorizontalAlignment = .center
    }
    
    // MARK: - Data management
    private func fetchData() {
        fetchListProgram()
    }
    
    private func fetchListProgram(programId: String? = nil) {
        HMListProgramAPI().execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                sSelf.listPrograms = response.programList
                sSelf.pageControl.numberOfPages = response.programList.count + 1
                
                var programs = response.programList
                if let programId = programId {
                    programs = programs.filter({ $0.id == programId})
                }
                
                if let program = programs.first {
                    sSelf.programTitle = program.title
                    sSelf.programId = program.id
                    sSelf.fetchListSession(by: program.id)
                    sSelf.tableView.tableFooterView?.isHidden = false
                    let index = sSelf.listPrograms.firstIndex(where: { $0.id == programId })
                    sSelf.pagerView.scrollToItem(at: index ?? 0, animate: false)
                }
                sSelf.pagerView.reloadData()
            case HMErrorCode.error.rawValue:
                sSelf.listPrograms = []
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
            }, failure: { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    private func fetchListSession(by programId: String) {
        HMSessionListInProgramAPI(idProgram: programId).execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                sSelf.sessionList = response.sessionList
                sSelf.listTasks.accept(response.sessionList)
            default:
                sSelf.sessionList = []
                sSelf.listTasks.accept([])
            }
            }, failure: { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }

    // MARK: - Actions
    @IBAction func invokeAddSessionButton(_ sender: UIButton) {
        let date = Date()
        let dateStr = date.stringBy(format: Date.dateFormat)
        HMAddTrainingSessionAPI.init(programId: self.programId ?? "0", name: "", date: dateStr).execute(target: self, success: { (response) in
            self.fetchListSession(by: self.programId ?? "0")
        }, failure: { (error) in
            
        })
    }
    
    @objc private func invokeListButton(_ sender: Any) {
        isDisplayList = !isDisplayList
    }
    
    // MARK: - Private methods
    private func addRightBarbutton() {
        let listView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let listButton = UIButton(frame: listView.frame)
        listButton.addTarget(self, action: #selector(invokeListButton(_:)), for: .touchUpInside)
        
        let listImageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        listImageView.image = UIImage(named: "icon_menu_yellow")
        listView.addSubview(listImageView)
        listView.addSubview(listButton)
        
        let listItem = UIBarButtonItem.init(customView: listView)
        
        navigationItem.rightBarButtonItems = [listItem]
    }
    
    private func showCalender(type: HMCalendarType, programId: String = "", dateStart: String = "", dateEnd: String = "") {
        let addProgramVC = HMAddProgramVC.create()
        addProgramVC.type = type
        addProgramVC.delegate = self
        switch type {
        case .update:
            addProgramVC.firstTimeStartDate = Date.getDateBy(string: dateStart, format: Date.dateFormatS)
            addProgramVC.firstTimeEndDate = Date.getDateBy(string: dateEnd, format: Date.dateFormatS)
            addProgramVC.programId = programId
        case .add:
            break
        }
        
        let popupVC = HMPopUpViewController(contentController: addProgramVC, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
        popupVC.backgroundAlpha = 0.3
        popupVC.cornerRadius = 0
        popupVC.shadowEnabled = false
        present(popupVC, animated: true, completion: nil)
    }
    
    func showAlertWithTextField(startDate: String, endDate: String) {
        let alertController = UIAlertController(title: "Tên chương trình tập", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Đồng ý", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let _ = txtField.text {
                HMUpdateTrainingProgramAPI(programId: self.programId ?? "", title: txtField.text ?? "Thiết lập thời gian tập luyện", dateStart: startDate, dateEnd: endDate).execute(target: self, success: { (response) in
                    switch response.errorId {
                    case HMErrorCode.success.rawValue:
                        self.fetchListProgram(programId: self.programId)
                    case HMErrorCode.error.rawValue:
                        UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
                    default:
                        break
                    }
                }, failure: { (error) in
                    UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Nhập tên chương trình tập"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension HMTrainingProgramVC: TYCyclePagerViewDataSource {
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return listPrograms.count + 1
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: pageView.frame.width, height: pageView.frame.height)
        layout.itemSpacing = 8
        layout.itemVerticalCenter = true
        return layout
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        if index == listPrograms.count {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HMTrainingProgramAddSlideCell", for: index) as! HMTrainingProgramAddSlideCell
            return cell
        } else {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HMTrainingProgramSlideCell", for: index) as! HMTrainingProgramSlideCell
            cell.isDisplayDeleteButton = false
            cell.data = listPrograms[index]
            cell.delegate = self
            return cell
        }
    }
    
}

extension HMTrainingProgramVC: TYCyclePagerViewDelegate {
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        self.pageControl.currentPage = toIndex;
        // id from list program
        if toIndex == listPrograms.count {
            if isInvokeAddFromList {
                showCalender(type: .add)
            }
            listTasks.accept([])
            tableView.tableFooterView?.isHidden = true
        } else {
            programTitle = listPrograms[toIndex].title
            programId = listPrograms[toIndex].id
            fetchListSession(by: listPrograms[toIndex].id)
            tableView.tableFooterView?.isHidden = false
        }
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        let addProgramVC = HMAddProgramVC.create()
        addProgramVC.delegate = self
        if index < listPrograms.count {
            showCalender(type: .update, programId: listPrograms[index].id, dateStart: listPrograms[index].date_start, dateEnd: listPrograms[index].date_end)
        } else {
            isInvokeAddFromList = false
            showCalender(type: .add)
        }
        
    }
}

extension HMTrainingProgramVC: HMAddProgramDelegate {
    func didAddProgram(programId: Int) {
        HMListProgramAPI().execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                sSelf.listPrograms = response.programList
                sSelf.pageControl.numberOfPages = response.programList.count + 1
                
                var programs = response.programList
                programs = programs.filter({ $0.id == String(programId)})
                
                var startDate: String = ""
                var endDate: String = ""
                if let program = programs.first {
                    sSelf.programTitle = program.title
                    sSelf.programId = program.id
                    startDate = program.date_start
                    endDate = program.date_end
                    sSelf.fetchListSession(by: program.id)
                    sSelf.tableView.tableFooterView?.isHidden = false
                    let index = sSelf.listPrograms.firstIndex(where: { $0.id == String(programId) })
                    sSelf.pagerView.scrollToItem(at: index ?? 0, animate: false)
                }
                sSelf.showAlertWithTextField(startDate: startDate, endDate: endDate)
                sSelf.pagerView.reloadData()
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
            }, failure: { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
}

extension HMTrainingProgramVC :HMTrainingProgramDetailCellDelegate {
    func updateTrainingProgram(name: String, programId: String) {
        let date = Date()
        let dateStr = date.stringBy(format: Date.dateFormat)
        HMAddTrainingSessionAPI.init(programId: programId, name: name, date: dateStr).execute(target: self, success: { (response) in
            self.fetchListSession(by: self.programId ?? "0")
        }, failure: { (error) in
            
        })
    }
}

extension HMTrainingProgramVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension HMTrainingProgramVC:HMTrainingProgramSlideCellDelegate {
    func updateProgramName(name: String, startDate: String, endDate: String) {
        HMUpdateTrainingProgramAPI(programId: self.programId ?? "", title: name, dateStart: startDate, dateEnd: endDate).execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                self.fetchListProgram(programId: self.programId)
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    func didTapDeleteProgramButton() {
        HMDeleteProgramAPI.init(courseId: self.programId ?? "0").execute(target: self, success: { response in
            self.fetchData()
            self.pagerView.reloadData()
        }, failure: { error in
            
        })
    }
}

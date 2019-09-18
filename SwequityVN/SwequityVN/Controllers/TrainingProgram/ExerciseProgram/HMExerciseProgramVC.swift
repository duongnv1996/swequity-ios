//
//  HMExerciseProgramVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 8/1/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum ExCellModel<T> {
    case normal(T)
    case link(T)
}

struct ExCellEntity {
    let exInSection: HMExerciseInSessionDetailEntity
    var exLinkedItem: HMExerciseInSessionDetailEntity?
}

class HMExerciseProgramVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var startTrainingButton: HMShadowButton!
    @IBOutlet weak var linkedExButton: HMShadowButton!
    
    // MARK: - Variables
    var sessionDetail: HMSessionExDetailEntity?
    var programId: String?
    var sourceIndexPath: IndexPath?
    var snapshot: UIView?
    var preIndexPath: IndexPath?
    
    private var isNotReloadData: Bool = false
    private let disposeBag = DisposeBag()
    private let listTasks: BehaviorRelay<[SectionModel<String, ExCellModel<ExCellEntity>>]> = BehaviorRelay(value: [])
    private var listExsInSection: [ExCellEntity] = [] {
        didSet {
            let sectionValues = listExsInSection.compactMap({
                return  ExCellModel.normal(ExCellEntity(exInSection: $0.exInSection, exLinkedItem: $0.exLinkedItem))
            })
            
            let section = SectionModel(model: "Standard Items", items: sectionValues)
            listTasks.accept([section])
        }
    }
    
    private var isDisplayLinked = false {
        didSet {
            let sectionValues = listExsInSection.compactMap({
                return  ExCellModel.normal(ExCellEntity(exInSection: $0.exInSection, exLinkedItem: $0.exLinkedItem))
            })
            
            var values = sectionValues
            
            if isDisplayLinked {
                let sectionLinkValues = listExsInSection.compactMap({
                    return  ExCellModel.link(ExCellEntity(exInSection: $0.exInSection, exLinkedItem: $0.exLinkedItem))
                })
                values = zip(sectionValues, sectionLinkValues).flatMap{ [$0, $1] }
                if values.count > 0 {
                    values.removeLast()
                }
            }
            
            let section = SectionModel(model: "Standard Items", items: values)
            listTasks.accept([section])
        }
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        HMSharedData.numberExercise = "0"
        HMSharedData.relaxTime = "0"
        self.isDisplayLinked = false
        self.linkedExButton.isHidden = !isDisplayLinked
        self.linkedExButton.isEnabled = isDisplayLinked
        self.startTrainingButton.isHidden = isDisplayLinked
        self.startTrainingButton.isEnabled = !isDisplayLinked
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isNotReloadData == false {
            fetchData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isDisplayLinked = false
    }
    
    override func setupView() {
        super.setupView()
        titleScreen = self.sessionDetail?.name.isEmpty ?? true ? "Chương trình tập " : self.sessionDetail?.name
        
        setupTableView()
        addRightNavigationBarbutton()
    }
    
    private func setupTableView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressToTable))
        tableView.addGestureRecognizer(longPress)
        tableView.registerNibCellFor(type: HMExProgramCell.self)
        tableView.registerNibCellFor(type: HMExLinkedCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ExCellModel<ExCellEntity>>>(configureCell: { dataSource, table, indexPath, cellType in
            switch cellType {
            case .normal(let data):
                return self.makeCell(with: data, from: table, row: indexPath.row)
            case .link(let data):
            return self.makeLinkedCell(with: data, from: table, row: indexPath.row)
            }
        })
        
        dataSource.canEditRowAtIndexPath = { section, indexPath in
            print(section, indexPath)
            return !self.isDisplayLinked
        }

        dataSource.canMoveRowAtIndexPath = { section, indexPath in
            print(section, indexPath)
            return !self.isDisplayLinked
        }
        
        listTasks
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ExCellModel<ExCellEntity>.self).subscribe(onNext: { cellTye in
            switch cellTye {
            case .normal(let data):
                self.presentEditAlert(task: data.exInSection)
            case .link:
                break
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemMoved.subscribe(onNext: { [weak self] indexPath in
            let entity: ExCellEntity = (self?.listExsInSection[indexPath.sourceIndex.row])!
            self?.listExsInSection.remove(at: indexPath.sourceIndex.row)
            self?.listExsInSection.insert(entity, at: indexPath.destinationIndex.row)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            self?.deleteLinked(index: indexPath.row)
            self?.fetchDelete(at: indexPath.row)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Data management
    private func fetchData() {
        
        if let sessionDetail = sessionDetail {
            HMSessionDetailAPI(idSession: sessionDetail.id).execute(target: self, success: {[weak self] (response) in
                guard let sSelf = self else { return }
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    sSelf.listExsInSection = response.listExsInSection.compactMap({
                        return ExCellEntity(exInSection: $0, exLinkedItem: nil)
                    })
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
    
    private func fetchDelete(at index: Int) {
        let exId = listExsInSection[index].exInSection.id
        HMDeleteExInSessionAPI(id: exId).execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                sSelf.listExsInSection.remove(at: index)
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    // MARK: - Actions
    @IBAction func invokeStartTrainingButton(_ sender: UIButton) {
        self.isNotReloadData = true
        if self.validateLinkedEx() {
            HMStartProgramAPI.init(sessionId: self.sessionDetail?.id ?? "", programId: self.sessionDetail?.program_user_set_id ?? "").execute(target: self, success: { (response) in
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    HMSharedData.timeStartEx = Date()
                    HMListSetExVC.push(prepare: { vc in
                        vc.sessionId = self.sessionDetail?.id
                        vc.programId = self.sessionDetail?.program_user_set_id
                        vc.menuTitles = self.listExsInSection.compactMap({ return $0.exInSection.name})
                        vc.menuIds = self.listExsInSection.compactMap({ return $0.exInSection})
                        HMSharedData.numberExercise = String(self.listExsInSection.count)
                        var totalBreakTime = 0
                        for entity in self.listExsInSection {
                            totalBreakTime = (Int(entity.exInSection.break_time) ?? 0) + totalBreakTime
                        }
                        HMSharedData.relaxTime = String(totalBreakTime)
                    })
                    break
                case HMErrorCode.error.rawValue:
                    UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
                default:
                    break
                }
            }, failure: { (error) in
                
            })
        } else {
            UIAlertController.showQuickSystemAlert(message: "Số hiệp của các bài đã ghép không đồng nhất. Vui lòng kiểm tra  ", cancelButtonTitle: "Đồng ý")
        }
    }
    
    @IBAction func invokeLinkedEx(_ sender: UIButton) {
        isDisplayLinked = !isDisplayLinked
        self.linkedExButton.isHidden = !isDisplayLinked
        self.linkedExButton.isEnabled = isDisplayLinked
        self.startTrainingButton.isHidden = isDisplayLinked
        self.startTrainingButton.isEnabled = !isDisplayLinked
    }
    
    
    // MARK: - Private methods
    @objc private func longPressToTable(_ recognizer: UILongPressGestureRecognizer) {
        if isDisplayLinked { return }
        
        let location = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: location)
        
        switch recognizer.state {
        case .began:
            if (indexPath != nil) {
                sourceIndexPath = indexPath
                preIndexPath = sourceIndexPath
                guard let indexPath = indexPath,
                    let cell = tableView.cellForRow(at: indexPath) else { return}
                snapshot = customSnapshot(from: cell)
                
                if let snapshot = snapshot {
                    
                    // Add the snapshot as subview, centered at cell's center...
                    var center = cell.center
                    snapshot.center = center
                    snapshot.alpha = 0.0
                    tableView.addSubview(snapshot)
                    UIView.animate(withDuration: 0.25, animations: {
                        
                        // Offset for gesture location.
                        center.y = location.y
                        snapshot.center = center
                        snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                        snapshot.alpha = 0.98
                        
                        // Fade out.
                        cell.alpha = 0.0
                        
                    }) { finished in
                        cell.isHidden = true
                    }
                }
            }
        case .changed:
            guard let snapshot = snapshot else { return }
            var center = snapshot.center
            center.y = location.y
            snapshot.center = center
            
            // Is destination valid and is it different from source?
            if let indexPath = indexPath,
            let sIndexPath = sourceIndexPath,
                !(indexPath == sIndexPath) {
                self.preIndexPath = sourceIndexPath
                // ... move the rows.
                tableView.moveRow(at: sIndexPath, to: indexPath)
                
                let entity: ExCellEntity = (self.listExsInSection[sIndexPath.row])
                self.listExsInSection.remove(at: sIndexPath.row)
                self.listExsInSection.insert(entity, at: indexPath.row)
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath
            }
        case .ended:
            guard let sIndexPath = sourceIndexPath,
                let cell = tableView.cellForRow(at: sIndexPath),
                let ss = snapshot else { return}
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                
                ss.center = cell.center
                ss.transform = CGAffineTransform.identity
                ss.alpha = 0.0
                
                // Undo fade out.
                cell.alpha = 1.0
                
                if self.preIndexPath != sIndexPath {
                    self.deleteLinked(index: sIndexPath.row)
                    if let preIndexPath = self.preIndexPath {
                        self.deleteLinked(index: preIndexPath.row)
                    }
                }
                
            }) { finished in
                self.preIndexPath = nil
                self.sourceIndexPath = nil
                ss.removeFromSuperview()
                self.snapshot = nil
                self.tableView.reloadData()
            }
            
        default:
            guard let sIndexPath = sourceIndexPath,
                let cell = tableView.cellForRow(at: sIndexPath),
                let ss = snapshot else { return}
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                
                ss.center = cell.center
                ss.transform = CGAffineTransform.identity
                ss.alpha = 0.0
                
                // Undo fade out.
                cell.alpha = 1.0
                
            }) { finished in
                self.preIndexPath = nil
                self.sourceIndexPath = nil
                ss.removeFromSuperview()
                self.snapshot = nil
                
            }
        }
    }
    
    func customSnapshot(from inputView: UIView?) -> UIView? {
        
        // Make an image from the input view.
        UIGraphicsBeginImageContextWithOptions(inputView?.bounds.size ?? CGSize.zero, _: false, _: 0)
        if let context = UIGraphicsGetCurrentContext() {
            inputView?.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Create an image view.
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }

    
    private func addRightNavigationBarbutton() {
        let linkedButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        linkedButton.setImage(UIImage(named: "icon_link"), for: .normal)
        linkedButton.addTarget(self, action: #selector(invokeLinkedButton(_:)), for: .touchUpInside)
        let linkedItem = UIBarButtonItem.init(customView: linkedButton)
        
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        addButton.setImage(UIImage(named: "icon_add_yellow"), for: .normal)
        addButton.addTarget(self, action: #selector(invokeAddButton(_:)), for: .touchUpInside)
        let addItem = UIBarButtonItem.init(customView: addButton)
        
        navigationItem.rightBarButtonItems = [addItem, linkedItem]
    }
    
    @objc private func invokeListButton(_ sender: Any) {
        
    }
    
    @objc private func invokeLinkedButton(_ sender: Any) {
        self.linkedExButton.isHidden = isDisplayLinked
        self.linkedExButton.isEnabled = !isDisplayLinked
        self.startTrainingButton.isHidden = !isDisplayLinked
        self.startTrainingButton.isEnabled = isDisplayLinked
        isDisplayLinked = !isDisplayLinked
        tableView.reloadData()
    }
    
    @objc private func invokeAddButton(_ sender: Any) {
        self.isNotReloadData = false
        HMCategoryAPI().execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                HMListExVC.push(prepare: { vc in
                    vc.isFavorite = false
                    vc.menuTitles = response.categoryList.compactMap({ return $0.title})
                    vc.menuIds = response.categoryList.compactMap({ return $0.id})
                    vc.type = .choose
                    vc.sessionId = self.sessionDetail?.id ?? ""
                })
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    private func makeCell(with entity: ExCellEntity, from table: UITableView, row: Int) -> UITableViewCell {
        guard let cell = table.reusableCell(type: HMExProgramCell.self) else { return UITableViewCell() }
        var indexRow = row
        if self.isDisplayLinked {
            indexRow = indexRow / 2
        }
        let isLinkViewEx = self.isDisplayLinkedView(index: indexRow)
        cell.setContentWithEntity(entity: entity.exInSection, isDisplayLinkedView: isLinkViewEx)
        return cell
    }
    
    private func makeLinkedCell(with entity: ExCellEntity, from table: UITableView, row: Int) -> UITableViewCell {
        guard let cell = table.reusableCell(type: HMExLinkedCell.self) else { return UITableViewCell() }
        let isLinkButtonEx = isDisplayLinkedButton(index: (row - 1)/2)
        cell.setContentWithEntity(isDisplayLinkedButton: isLinkButtonEx)
        cell.delegate = self
        cell.layer.zPosition = CGFloat(row)
        return cell
    }
    
    private func presentEditAlert(task: HMExerciseInSessionDetailEntity) {
        let editExAlertVC = HMEditExAlertVC.create()
        editExAlertVC.exDetail = task
        editExAlertVC.delegate = self
        let popupVC = HMPopUpViewController(contentController: editExAlertVC, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
        popupVC.backgroundAlpha = 0.3
        popupVC.cornerRadius = 0
        popupVC.shadowEnabled = false
        self.present(popupVC, animated: true, completion: nil)
    }
    
    private func isDisplayLinkedView(index: Int) -> Bool {
        let dictLinkEx:Dictionary = HMSharedData.linkExercise ?? [:]
        let id = self.listExsInSection[index].exInSection.id
        if Array(dictLinkEx.keys).contains(id) {
            return true
        }
        for entity in dictLinkEx {
            if entity.value == id {
                return true
            }
        }
        return false
    }
    
    private func isDisplayLinkedButton(index: Int) -> Bool {
        let dictLinkEx:Dictionary = HMSharedData.linkExercise ?? [:]
        let id = self.listExsInSection[index].exInSection.id
        if Array(dictLinkEx.keys).contains(id) {
            return true
        }
        return false
    }
    
    private func deleteLinked (index: Int) {
        //Delete linked
        var dictEx = HMSharedData.linkExercise ?? [:]
        let id = self.listExsInSection[index].exInSection.id
        
        for (key, value) in dictEx {
            if value == id || key == id {
                dictEx.removeValue(forKey: key)
            }
        }
        
        HMSharedData.linkExercise = dictEx
    }
    
    private func validateLinkedEx() -> Bool {
        let dictEx = HMSharedData.linkExercise ?? [:]
        for index in 0..<self.listExsInSection.count-1 {
            let numberSet = Int(self.listExsInSection[index].exInSection.sets) ?? 0
            let nextNumberSet = Int(self.listExsInSection[index + 1].exInSection.sets) ?? 0
            let id = self.listExsInSection[index].exInSection.id
            if (numberSet > nextNumberSet) && Array(dictEx.keys).contains(id) {
                return false
            }
        }
        return true
    }

}

extension HMExerciseProgramVC: HMExLinkedCellDelegate {
    func invokeLinkedButton(at: HMExLinkedCell, ischecked: Bool) {
        if let indexPath = self.tableView.indexPath(for: at) {
            let index = (indexPath.row - 1)/2
            if index == self.listExsInSection.count { return}
            var dictLinkEx:Dictionary = HMSharedData.linkExercise ?? [:]
            let id = self.listExsInSection[index].exInSection.id
            let preId = self.listExsInSection[index + 1].exInSection.id
            if ischecked {
                dictLinkEx.updateValue(preId, forKey: id)
            } else {
                dictLinkEx.removeValue(forKey: id)
            }
            HMSharedData.linkExercise = dictLinkEx
        }
    }
}

extension HMExerciseProgramVC: HMEditExAlertVCDelegate {
    func updateExList() {
        fetchData()
    }
    
}

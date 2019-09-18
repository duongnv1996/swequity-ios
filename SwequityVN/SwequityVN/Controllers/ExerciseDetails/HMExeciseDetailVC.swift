//
//  HMExeciseDetail.swift
//  SwequityVN
//
//  Created by Tung QT on 8/2/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import YoutubePlayerView

class HMExeciseDetailVC: HMBaseVC {

    @IBOutlet weak var titleExerciseLabel: UILabel!
    @IBOutlet weak var detailsExerciseLabel: UILabel!
    @IBOutlet weak var detailsStepLabel: UILabel!
    @IBOutlet weak var videoView: YoutubePlayerView!
    @IBOutlet weak var leftVideoButton: UIButton!
    @IBOutlet weak var rightVideoButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var exerciseId: String?
    
    private let disposeBag = DisposeBag()
    private let listVideo: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    private var indexCurrent: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        setupUI()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.registerNibCellFor(type: HMExeciseDetailCell.self)
        
        listVideo.bind(to: collectionView.rx.items(cellIdentifier: "HMExeciseDetailCell", cellType: HMExeciseDetailCell.self)) { row, model, cell in
            cell.url = model
            }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(HMExeciseDetailCell.self).subscribe(onNext: {task in
            // TODO : Tap To cell
            print(task)
        }).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe({ [weak self] indexPath in
                print("listTasks.value[indexPath.row]")
            }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        videoView.delegate = self
        leftVideoButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    func setupData(dto: HMExDetailEntity) {
        
        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "autoplay": 0,
            "origin": "https://youtube.com"
        ]
        titleExerciseLabel.text = dto.name
        detailsExerciseLabel.text = dto.content
        detailsStepLabel.text = ""
        if let link = dto.link_instruction.youtubeID {
            videoView.loadWithVideoId(link, with: playerVars)
        }
        
        listVideo.accept([dto.link_support_1,dto.link_support_2])
    }
    
    private func fetchData() {
        if let exerciseId = exerciseId {
            HMExerciseAPI(id: exerciseId).execute(target: self, success: { (response) in
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    if let data = response.exDetail {
                        self.setupData(dto: data)
                    }
                    print(response)
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
    
}

extension HMExeciseDetailVC: YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.fetchPlayerState { (state) in
            print("Fetch Player State: \(state)")
        }
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        print("Changed to state: \(state)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Play time: \(time)")
    }
    
    func playerViewPreferredInitialLoadingView(_ playerView: YoutubePlayerView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
}

extension HMExeciseDetailVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        return CGSize(width: width, height: 92)
    }
}

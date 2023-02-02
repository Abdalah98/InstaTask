//
//  ViewController.swift
//  InstaBostaTask
//
//  Created by Abdallah on 01/02/2023.
//


import UIKit
import RxCocoa
import RxSwift
class ProfileVc: UIViewController {
  
  @IBOutlet weak var nameUserLabel: UILabel!
  @IBOutlet weak var addressUserlabel: UILabel!
  @IBOutlet weak var albumTableView: UITableView!
  @IBOutlet weak var albumsView: UIView!
  
  let disposeBag       = DisposeBag()
  let profileViewModel = ProfileViewModel()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initViewModel()
    
  }
  
  
  private func initViewModel(){
    
    setupTableView()
    bindLabelToViewModel()
    subscribeToLoading()
    subscribeToShowAlert()
    subscribeToResponseAlbum()
    subscribeToAlbumSelection()
  }
  
  
  
  // MARK: Binding
  // bind data with Label
  func bindLabelToViewModel() {
    profileViewModel.nameUserBehavior.asObservable().map{ $0}.bind(to: self.nameUserLabel.rx.text).disposed(by: disposeBag)
    profileViewModel.addressUserBehavior.asObservable().map{ $0}.bind(to: self.addressUserlabel.rx.text).disposed(by: disposeBag)
  }
  
  // if no there data the table view hidden
  func bindToHiddenTable() {
    profileViewModel.isTableHiddenObservable.bind(to: self.albumsView.rx.isHidden).disposed(by: disposeBag)
  }
  
  // Show Activity Loading
  func subscribeToLoading() {
      profileViewModel.loadingObserver.subscribe(onNext: { [weak self]  (isLoading) in
        guard let self = self else {return}
          if isLoading {
              self.showLoadingView()
          } else {
              self.dismissLoadingView()
          }
      }).disposed(by: disposeBag)
  }
  
  // Show Alert Massege
  func subscribeToShowAlert() {
      profileViewModel.showAlertObserver.subscribe(onNext: { [weak self](title) in
        guard let self = self else {return}
        if title != ""{
          self.view.makeToast(title)
        }
      }).disposed(by: disposeBag)
  }
  
  
  // MARK: Binding TableView
  
  func subscribeToResponseAlbum() {
    self.profileViewModel.albumModelObservable.bind(to: self.albumTableView.rx.items(cellIdentifier:  Cell.albumTableViewCell,
        cellType:  AlbumTableViewCell.self)) { row, album, cell in
      cell.albumNameLabel.text = album.title
    }.disposed(by: disposeBag)
  }
  
  // when i itemSelected in  TableView pass data
  func subscribeToAlbumSelection() {
    Observable
      .zip(albumTableView.rx.itemSelected, albumTableView.rx.modelSelected(Albums.self))
      .bind { [weak self] selectedIndex, album in
        guard let self = self else{return}
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.photo, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: StoryBoard.userPhotosVC) as! UserPhotosVC
        resultViewController.albumTitle = album.title
        resultViewController.userId = String(album.userID)
        self.navigationController?.pushViewController(resultViewController, animated: true)
      }.disposed(by: disposeBag)
  }
  
  // TableViewCell
  func setupTableView() {
    albumTableView.delegate = self
    albumTableView.register(UINib(nibName: Cell.albumTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.albumTableViewCell)
  }
  
}

// MARK: UITableViewDelegate

extension ProfileVc: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

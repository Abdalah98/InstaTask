//
//  UserPhotosVC.swift
//  InstaBostaTask
//
//  Created by Abdallah on 01/02/2023.
//


import UIKit
import RxSwift
import RxCocoa
class UserPhotosVC: UIViewController, UISearchBarDelegate {
  
    @IBOutlet weak var userPhotoCollectionView: UICollectionView!
    @IBOutlet weak var photosView: UIView!
    
    var disposeBag = DisposeBag()
  
    let userPhotoViewModel = UserPhotoViewModel()
  
    var albumTitle: String?
    var userId =  String()
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        bindToHiddenCollectionView()
        getAlbum()
    }
    

  private func initViewModel(){
    title = albumTitle
    userPhotoViewModel.PickedAlbumId.accept(userId)
    setupCollectionView()
    subscribeToLoading()
    subscribeToShowAlert()
    //tableView
    subscribeToImagesesponse()
    subscribeToPhotoSelection()
    //search
    configureSearch()
    bindToSearchValue()
  }
  
  
  // MARK: Binding
      
  // Show Activity Loading
  func subscribeToLoading() {
    userPhotoViewModel.loadingObserver.subscribe(onNext: { [weak self]  (isLoading) in
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
    userPhotoViewModel.showAlertObserver.subscribe(onNext: { [weak self](title) in
        guard let self = self else {return}
        if title != ""{
          self.view.makeToast(title)
        }
      }).disposed(by: disposeBag)
  }
    
    // fetch data
    func getAlbum() {
        userPhotoViewModel.fetchPhotos()
    }
    
    // MARK: UICollectionView

  func subscribeToImagesesponse() {
    userPhotoCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
    userPhotoViewModel.imagesBehavior.bind(to: userPhotoCollectionView.rx.items(cellIdentifier: Cell.photosCollectionViewCell,
                         cellType: PhotosCollectionViewCell.self)) { index, image, cell in
          cell.set(photo: image)
      }.disposed(by: disposeBag)
  }

  
  // if no there data the CollectionView  hidden
  func bindToHiddenCollectionView() {
      userPhotoViewModel.isCollectionHiddenObservable.bind(to: self.photosView.rx.isHidden).disposed(by: disposeBag)
  }
  
    // when i itemSelected in  CollectionView pass data
  func subscribeToPhotoSelection() {
          Observable
              .zip(userPhotoCollectionView.rx.itemSelected, userPhotoCollectionView.rx.modelSelected(Photos.self))
              .bind { [weak self] selectedIndex, photo in
                  guard let self = self else{return}
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "photoDetails") as! PhotoDetailsVC
                vc.photoSelect = photo.url
                vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                
              }.disposed(by: disposeBag)
      }
  
  
  //CollectionViewCell
  func setupCollectionView() {
      userPhotoCollectionView.register(UINib(nibName:  Cell.photosCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cell.photosCollectionViewCell)
  }
  
  
  // MARK: Binding Search
  
  func bindToSearchValue() {
    searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: {query in
              self.userPhotoViewModel.filterWith(name: query )
            })            .disposed(by: disposeBag)

        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { () in
            })
            .disposed(by: self.disposeBag)

        searchController.searchBar.rx.textDidEndEditing
            .subscribe(onNext: { () in
            })
            .disposed(by: self.disposeBag)

  }


  // add search in  navigationItem
  fileprivate func configureSearch() {
      searchController.searchBar.placeholder = "Search in images.."
      searchController.searchBar.delegate = self
      searchController.searchBar.sizeToFit()
      navigationItem.searchController = searchController
      navigationItem.hidesSearchBarWhenScrolling = false
      searchController.obscuresBackgroundDuringPresentation = false
  }
}


// MARK: UICollectionViewDelegateFlowLayout

extension UserPhotosVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let sizeCell  = collectionView.frame.width / 3
        return CGSize(width: sizeCell , height:sizeCell)
    }
}

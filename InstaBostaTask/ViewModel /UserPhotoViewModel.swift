//
//  UserPhotoViewModel.swift
//  InstaBostaTask
//
//  Created by Abdallah on 01/02/2023.
//

import Foundation
import RxCocoa
import RxSwift
class UserPhotoViewModel {
    
    var PickedAlbumId                 = BehaviorRelay<String>(value: "")
    private  var showAlertBehavior    = BehaviorRelay<String>(value: "")
    private  var loadingBehavior      = BehaviorRelay<Bool>(value: false)
    private  let searchValue          = BehaviorRelay<String>(value: "")
    private  var isCollectionHidden   = BehaviorRelay<Bool>(value: false)
    private var allImages = BehaviorRelay<[Photos]>(value: [])
    var imagesBehavior = BehaviorRelay<[Photos]>(value: [])

    var loadingObserver: Observable<Bool>{ return loadingBehavior.asObservable()}
    var showAlertObserver: Observable<String>{return showAlertBehavior.asObservable()}
    var isCollectionHiddenObservable: Observable<Bool> {return isCollectionHidden.asObservable()}
  
    private  let networkManager        =  NetworkManager()


  func fetchPhotos() {
      // to show Activity
      // fetch data and call api
      loadingBehavior.accept(true)
      networkManager.fetchPhotos(albumId: PickedAlbumId.value, completion: { [weak self] result in
          guard let self = self else { return }
          self.loadingBehavior.accept(false)
          switch result {
          case .success(let photos):
              if  photos.count  > 0 {
                  self.allImages.accept(photos)
                  self.imagesBehavior.accept(photos)

                  self.isCollectionHidden.accept(false)
              }else{
                  self.isCollectionHidden.accept(true)
              }
          case .failure(let error):
              self.showAlertBehavior.accept(error.rawValue)
              self.isCollectionHidden.accept(true)
          }
      })
  }
  
  func filterWith(name:String){
      if name == ""{
          self.imagesBehavior.accept(allImages.value)
      }else{
        let filterd = allImages.value.filter({$0.title.contains(name) == true})
          self.imagesBehavior.accept(filterd)
      }
  }
}


//
//  ProfileViewModel.swift
//  InstaBostaTask
//
//  Created by Abdallah on 01/02/2023.
//

import Foundation
import RxCocoa
import RxSwift
class ProfileViewModel {
    
    var nameUserBehavior              = BehaviorRelay<String>(value: "")
    var addressUserBehavior           = BehaviorRelay<String>(value: "")
    private  var showAlertBehavior    = BehaviorRelay<String>(value: "")
    private  var loadingBehavior      = BehaviorRelay<Bool>(value: false)
    private  var isTableHidden        = BehaviorRelay<Bool>(value: false)

    private  var albumModelSubject     = PublishSubject<[Albums]>()
    private  var userModleSubject      = PublishSubject<User>()


    var albumModelObservable: Observable<[Albums]> {return albumModelSubject}
    var userModelObservable: Observable<User> {return userModleSubject}
    var loadingObserver: Observable<Bool>{return loadingBehavior.asObservable()}
    var showAlertObserver: Observable<String>{return showAlertBehavior.asObservable()}
    var isTableHiddenObservable: Observable<Bool> {return isTableHidden.asObservable()}


    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
      self.networkManager = networkManager
         fetchUserData()
    }
  
  func fetchUserData(){
      // to show Activity
      // fetch data and call api
      loadingBehavior.accept(true)
      networkManager.getUser( completion: { [weak self] result in
          guard let self = self else { return }
          self.loadingBehavior.accept(false)
          switch result {
          case .success(let user):
            self.nameUserBehavior.accept(user.name ?? "")
            let street = user.address?.street ?? ""
            let suite = user.address?.suite ?? ""
            let city = user.address?.city ?? ""
            let zipCode = user.address?.zipcode ?? ""
            let address =  street + ", " + suite + ", " + city + ", "  + zipCode
              self.addressUserBehavior.accept(address)
            self.fetchUserAlbums(userId: String(user.id ?? 0))
          case .failure(let error):
              self.isTableHidden.accept(true)
              self.showAlertBehavior.accept(error.rawValue)
          }
      })
  }

  
  func fetchUserAlbums(userId: String) {
      // to show Activity
      // fetch data and call api
      loadingBehavior.accept(true)
      networkManager.fetchUserAlbums(userId: userId, completion: { [weak self] result in
          guard let self = self else { return }
          self.loadingBehavior.accept(false)
          switch result {
          case .success(let albums):
              if  albums.count > 0 {
                  self.albumModelSubject.onNext(albums)
                  self.isTableHidden.accept(false)
              }else{
                  self.isTableHidden.accept(true)
              }
          case .failure(let error):
              self.isTableHidden.accept(true)
              self.showAlertBehavior.accept(error.rawValue)
          }
      })
  }
  
}

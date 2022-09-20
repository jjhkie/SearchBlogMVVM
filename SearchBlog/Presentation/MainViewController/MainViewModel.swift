

import RxSwift
import RxCocoa
import Foundation
import SwiftUI

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListVM = BlogListViewModel()
    let searchBarVM = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainVIewController.AlertAction>()
    
    let shouldPresentAlert: Signal<MainVIewController.Alert>
    
    init(model: MainModel = MainModel()){
        
        let blogResult = searchBarVM.shouldLoadResult
            .flatMapLatest(model.searchBlog)
            .share()
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        
        //네트워크를 통해 가져온 값을 cell Data 로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData)
    
        
        //FilterView를 선택했을 때 나오는 alertsheet 를 선택했을 때 type
        let sortedType = alertActionTapped
            .filter{
                switch $0{
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        //MainVIewController -> ListView
        Observable
            .combineLatest(sortedType, cellData, resultSelector: model.sort)
            .bind(to: blogListVM.blogCellData)
            .disposed(by: disposeBag)
        
//            .combineLatest(
//                sortedType,cellData){type, data -> [BlogListCellData] in
//                    switch type{
//                    case .title:
//                        return data.sorted{ $0.title ?? "" < $1.title ?? ""}
//                    case .datetime:
//                        return data.sorted{ $0.datetime ?? Date() > $1.datetime ?? Date()}
//                    default:
//                        return data
//                    }
//                }
//                .bind(to: blogListVM.blogCellData)
//                .disposed(by: disposeBag)
//        
        
        let alertSheetForSorting = blogListVM.filterViewModel.sortButtonTapped
            .map { _ -> MainVIewController.Alert in
                return (title: nil, message: nil, actions: [.title,.datetime, .cancel], style: .actionSheet)
            }
        
        let aleertForErrorMessage = blogError
            .map{ message -> MainVIewController.Alert in
                return (
                    title: "앗",
                    message: "잠시 후 다시 시도해주세요,\(message)",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        self.shouldPresentAlert = Observable
            .merge(
                alertSheetForSorting,
                aleertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
    
    }
}

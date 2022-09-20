

import RxSwift
import RxCocoa


struct BlogListViewModel {
    
    ///BlogListView가 FilterView를 Header로 사용하기 때문에
    let filterViewModel = FilterViewModel()
    
    //MainViewController = > BlogListView
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init(){
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
    
}

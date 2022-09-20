

import RxSwift
import RxCocoa

struct SearchBarViewModel {
    
    let queryText = PublishRelay<String?>()
    
    //SearchBar Button Tap Event
    let searchButtonTapped = PublishRelay<Void>()
    
    let shouldLoadResult: Observable<String>
    
    init(){
        
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText){$1 ?? ""}
            .filter { !$0.isEmpty}
            .distinctUntilChanged()
    }
 
}





/// withLatestFrom  : 두 Observable 중 첫 번째 Observable에서 아이템이 방출될 때마다
///              그 아이템을 두 번째 Observable의 가장 최근 아이템과 결합해 방출한다.
///

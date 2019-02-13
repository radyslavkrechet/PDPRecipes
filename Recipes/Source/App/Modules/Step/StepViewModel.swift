import RxSwift

class StepViewModel: ViewModel {
    let stepVariable = Variable<String>(String())
    var step: Observable<String> {
        return stepSubject.asObservable()
    }
    var isDataProvided: Observable<Bool> {
        return stepVariable.asObservable().map { !$0.isEmpty }
    }
    var addDidTap: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                self?.addStep()
            default:
                break
            }
        }
    }

    private let stepSubject = PublishSubject<String>()

    // MARK: - Private

    private func addStep() {
        stepSubject.onNext(stepVariable.value)
    }
}

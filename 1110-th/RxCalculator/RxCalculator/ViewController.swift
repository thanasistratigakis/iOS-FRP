//
//  ViewController.swift
//  RxCalculator
//
//  Created by Nikolas Burk on 09/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstValueTextField: UITextField!
    @IBOutlet weak var secondValueTextField: UITextField!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calculator = Calculator()
        
        let operationObservable: Observable<Calculator.Operation> = operationSegmentedControl.rx.value.map { value in
            return Calculator.Operation(rawValue: value)!
        }
        
        let firstValueObservable: Observable<Int> = firstValueTextField.rx.text.map { text in
            return Int(text!)!
        }
        
        firstValueObservable.subscribe(onNext: { string in
            print(string)
        }).addDisposableTo(disposeBag)
        
        
        let secondValueObservable: Observable<Int> = secondValueTextField.rx.text.map { text in
            return Int(text!)!
        }
        
        secondValueObservable.subscribe(onNext: { string in
            print(string)
        }).addDisposableTo(disposeBag)
        
        Observable.combineLatest(operationObservable, firstValueObservable, secondValueObservable) { operation, first,second in
            switch operation {
            case Addition: return calculator.add(a: first, b: second)
            case Subtraction: return calculator.subtract(a: first, b: second)
            }
            }.map { value in
                return String(value)
            }.bindTo(resultLabel.rx.text)
    }
    
}


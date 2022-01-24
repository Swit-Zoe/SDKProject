//
//  ObservableType+Extension.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/23.
//

import Foundation
import RxSwift

extension ObservableType {

  func withPrevious() -> Observable<(E?, E)> {
    return scan([], accumulator: { (previous, current) in
        Array(previous + [current]).suffix(2)
      })
      .map({ (arr) -> (previous: E?, current: E) in
        (arr.count > 1 ? arr.first : nil, arr.last!)
      })
  }
}

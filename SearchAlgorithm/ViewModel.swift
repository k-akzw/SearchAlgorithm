//
//  ViewModel.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/29/24.
//

import SwiftUI

// each node's UI
struct RoundedCircleStyle: ViewModifier {
  var visiting: Bool

  func body(content: Content) -> some View {
    content
      .frame(width: 50, height: 50)
      .background(Circle().stroke())
      // fill the circle red for currently visiting node
      .background(Circle().fill(Color.red.opacity(visiting ? 0.7 : 0)))
      .background(Circle().fill(Color.white))
      .padding(10)
  }
}

// used to get the center point of each node
struct CollectDict<Key: Hashable, Value>: PreferenceKey {
  static var defaultValue: [Key:Value] { [:] }
  static func reduce(value: inout [Key : Value], nextValue: () -> [Key : Value]) {
    value.merge(nextValue(), uniquingKeysWith: { $1 })
  }
}

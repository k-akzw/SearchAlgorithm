//
//  TreeModel.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/29/24.
//

import SwiftUI

struct Tree {
  static let shared = Tree()

  // initial tree
  let tree: TreeNode<Unique<Int>> = TreeNode<Int>(val: 50, children: [
    TreeNode(val: 25, children: [
      TreeNode(val: 12),
      TreeNode(val: 37)
    ]),
    TreeNode(val: 75, children: [
      TreeNode(val: 62),
      TreeNode(val: 87)
    ])
  ]).map(Unique.init)
}

// each tree node has value and children
struct TreeNode<A> {
  var val: A
  var children: [TreeNode<A>] = []
  init(val: A, children: [TreeNode<A>] = []) {
    self.val = val
    self.children = children
  }
}

extension TreeNode {
  // maps each tree node's variable from datatype @A to @B
  //
  // @A - current datatype
  // @B - new datatype
  func map<B>(_ transform: (A) -> B) -> TreeNode<B> {
    TreeNode<B>(val: transform(val), children: children.map { $0.map(transform) })
  }
}

// new variable so that it becomes identifiable
// Note: Int is not identifiable
class Unique<A>: Identifiable {
  let val: A
  init(_ val: A) {
    self.val = val
  }
}

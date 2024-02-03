//
//  TreeModel.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/29/24.
//

import SwiftUI

class Tree: ObservableObject {
  // Singleton instance
  static let shared = Tree()

  // initial tree
  @Published var root: TreeNode<Unique<Int>> = TreeNode<Int>(val: 50, children: [
    TreeNode(val: 25, children: [
      TreeNode(val: 12, children: [
        TreeNode(val: 6, children: [
          TreeNode(val: 3),
          TreeNode(val: 9)
        ]),
        TreeNode(val: 18)
      ]),
      TreeNode(val: 37)
    ]),
    TreeNode(val: 75, children: [
      TreeNode(val: 62),
      TreeNode(val: 87)
    ])
  ]).map(Unique.init)

  // MARK: - Public Functions
  func insertNode(val: Unique<Int>) {
    insertNodeUtils(val: val)

    // to update the UI
    // since @root is @Published
    // UI gets updated if @root changes
    root = root
  }

  private func insertNodeUtils(val: Unique<Int>) {
    var cur = root
    while true {
      if cur.children.isEmpty {
        cur.children.append(TreeNode(val: val))
        return
      }

      // if 1 child
      if cur.children.count == 1 {
        if val < cur.val {
          if cur.children[0].val < cur.val { cur = cur.children[0] }
          else {
            let tmp = cur.children[0]
            cur.children[0] = TreeNode(val: val)
            cur.children.append(tmp)
            return
          }
        } else {
          if cur.children[0].val > cur.val { cur = cur.children[0] }
          else {
            cur.children.append(TreeNode(val: val))
            return
          }
        }
      } 
      // if 2 children
      else {
        if val < cur.val { cur = cur.children[0] }
        else { cur = cur.children[1] }
      }
    }
  }
}

// each tree node has value and children
class TreeNode<A: Equatable>: Equatable, Identifiable {
  let id = UUID()
  var val: A
  @Published var children: [TreeNode<A>] = []

  init(val: A, children: [TreeNode<A>] = []) {
    self.val = val
    // binary tree so the children are at most 2
    self.children = Array(children.prefix(2))
  }

  static func == (lhs: TreeNode<A>, rhs: TreeNode<A>) -> Bool {
    return lhs.val == rhs.val && lhs.children == rhs.children
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
class Unique<A>: Identifiable, Comparable where A: Comparable {
  var val: A

  init(_ val: A) {
    self.val = val
  }

  static func == (lhs: Unique<A>, rhs: Unique<A>) -> Bool {
    return lhs.val == rhs.val
  }

  static func < (lhs: Unique<A>, rhs: Unique<A>) -> Bool {
    return lhs.val < rhs.val
  }
}

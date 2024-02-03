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

  @Published var nodeToDelete: TreeNode<Unique<Int>>?
  @Published var root: TreeNode<Unique<Int>> = TreeNode(val: 50,
    left: TreeNode(val: 25,
      left: TreeNode(val: 12, 
        left: TreeNode(val: 6,
          left: TreeNode(val: 3),
          right: TreeNode(val: 9)),
        right: TreeNode(val: 18)),
      right: TreeNode(val: 37)),
    right: TreeNode(val: 75,
      left: TreeNode(val: 62),
      right: TreeNode(val: 87))
  ).map(Unique.init)

  // MARK: - Public Functions

  // inserts new node with @val
  func insertNode(val: Unique<Int>) {
    insertNodeUtils(val: val)

    // to update the UI
    // since @root is @Published
    // UI gets updated if @root changes
    root = root
  }

  // deletes @nodeToDelete if it's not nil
  // nodeToDelete gets updated when user taps a node
  func deleteNode() {
    if let node = nodeToDelete {
      deleteNodeUtils(node, from: root)
      nodeToDelete = nil

      // to update the UI
      // since @root is @Published
      // UI gets updated if @root changes
      root = root
    }
  }

  // insert new node with @val into binary search tree
  private func insertNodeUtils(val: Unique<Int>) {
    var cur = root
    // continue looping until position for new node is found
    while true {
      if val < cur.val {
        if let newCur = cur.left {
          cur = newCur
        } else {
          // if current node has no left child
          // insert the new node as the left child
          cur.left = TreeNode(val: val)
          return
        }
      } else {
        if let newCur = cur.right {
          cur = newCur
        } else {
          // if current node has no right child
          // insert the new node as the right child
          cur.right = TreeNode(val: val)
          return
        }
      }
    }
  }

  private func deleteNodeUtils(_ node: TreeNode<Unique<Int>>, from root: TreeNode<Unique<Int>>) {
    let parent = findParent(of: node, from: root)
    // Case 1: if node to delete doesn't have any children
    if node.getChildren().isEmpty {
      if node.val < parent.val {
        parent.left = nil
      } else {
        parent.right = nil
      }
      return
    }

    // Case 2: if node has only 1 child
    if node.left == nil || node.right == nil {
      let child = node.getChildren()[0]
      // if node's value is less than parent's value
      // node is parent's left child
      if node.val < parent.val {
        parent.left = child
      } else {
        parent.right = child
      }
      return
    }

    // Case 3: If node has 2 children
    let successor = findSuccessor(node.left!)
    let tmp = successor.val
    // recursively delete successor node
    deleteNodeUtils(successor, from: node)
    node.val = tmp
  }

  // Returns parent of @node
  // node is guranteed to be in the tree
  // so parent is guranteed to be found
  private func findParent(of node: TreeNode<Unique<Int>>, from root: TreeNode<Unique<Int>>) -> TreeNode<Unique<Int>> {
    var cur = root
    while true {
      if node.val < cur.val {
        if let left = cur.left {
          if left.id == node.id { return cur }
          cur = left
        }
      } else {
        if let right = cur.right {
          if right.id == node.id { return cur }
          cur = right
        }
      }
    }
  }

  private func findSuccessor(_ node: TreeNode<Unique<Int>>) -> TreeNode<Unique<Int>> {
    var cur = node
    while let rightChild = cur.right {
      cur = rightChild
    }
    return cur
  }
}

// each tree node has value and children
class TreeNode<A: Equatable>: Equatable, Identifiable {
  let id = UUID()
  var val: A
//  @Published var children: [TreeNode<A>] = []
  @Published var left: TreeNode<A>?
  @Published var right: TreeNode<A>?

  init(val: A, left: TreeNode<A>? = nil, right: TreeNode<A>? = nil) {
    self.val = val
    self.left = left
    self.right = right
  }

  func getChildren() -> [TreeNode<A>] {
    var res = [TreeNode<A>]()
    if let child = left { res.append(child) }
    if let child = right { res.append(child) }
    return res
  }

  static func == (lhs: TreeNode<A>, rhs: TreeNode<A>) -> Bool {
    return lhs.id == rhs.id
  }
}

extension TreeNode {
  // maps each tree node's variable from datatype @A to @B
  //
  // @A - current datatype
  // @B - new datatype
  func map<B>(_ transform: (A) -> B) -> TreeNode<B> {
//    TreeNode<B>(val: transform(val), children: children.map { $0.map(transform) })
    TreeNode<B>(val: transform(val), left: left?.map(transform), right: right?.map(transform))
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

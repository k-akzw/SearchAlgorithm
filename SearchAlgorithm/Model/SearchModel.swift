//
//  SearchModel.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/31/24.
//

import SwiftUI

enum SearchAlgorithms {
  case binarySearch
  case breadthFirstSearch
  case depthFirstSearch
}

class SearchModel: NSObject, ObservableObject {
  static let shared = SearchModel(searchAlgorithm: .depthFirstSearch, root: Tree.shared.root)

  var searchAlgorithm: SearchAlgorithms
  var root: TreeNode<Unique<Int>>
  @Published var cur: TreeNode<Unique<Int>>
  @Published var done = false
  @Published var res = false
  @Published var tmp = 1

  private let duration: UInt32 = 1

  init(searchAlgorithm: SearchAlgorithms, root: TreeNode<Unique<Int>>, done: Bool = false, res: Bool = false) {
    self.searchAlgorithm = searchAlgorithm
    self.root = root
    self.cur = root
    self.done = done
    self.res = res
  }

  func startSearch(key: Unique<Int>) {
    switch searchAlgorithm {
    case .binarySearch:
      res = binarySearch(key: key, root: root)
      done = true
    case .breadthFirstSearch:
      res = breadthFirstSearch(key: key, root: root)
    case .depthFirstSearch:
      depthFirstSearch(key: key, root: root)
      done = true
    }
  }
}

extension SearchModel {
  func binarySearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) -> Bool {

    cur = root
    print(cur.val.val)
    tmp += 1
    // if key found
    if root.val == key { return true }

    // pause
    sleep(duration)

    // if there is no children
    if root.children.isEmpty { return false }

    // if there is only 1 child
    if root.children.count == 1 {
      let child = root.children[0]
      if (root.val < child.val && root.val < key) ||
          (root.val > child.val && root.val > key) { return binarySearch(key: key, root: child) }
      else { return false }
    }

    // if there are 2 children
    if key < root.val {
      return binarySearch(key: key, root: root.children[0])
    } else {
      return binarySearch(key: key, root: root.children[1])
    }
  }

  func breadthFirstSearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) -> Bool {
    var queue = [root]
    while !queue.isEmpty {
      let size = queue.count
      for _ in 0..<size {
        cur = queue.remove(at: 0)
        if cur.val == key { return true }

        // pause
        sleep(duration)

        for child in cur.children {
          queue.append(child)
        }
      }
    }
    return false
  }

  func depthFirstSearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) {
    var stack = [root]
    while !stack.isEmpty {
      cur = stack.remove(at: 0)
      if cur.val == key { return }

      // pause
      sleep(duration)

      for child in cur.children.reversed() {
        stack.insert(child, at: 0)
      }
    }
  }
}

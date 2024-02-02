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
	// Singleton instance
  static let shared = SearchModel(searchAlgorithm: .depthFirstSearch, root: Tree.shared.root)

	// MARK: - Variables
  var searchAlgorithm: SearchAlgorithms
  var root: TreeNode<Unique<Int>>
  @Published var cur: TreeNode<Unique<Int>>
  @Published var done = false
  @Published var res = false

  private let duration: UInt32 = 1

	// MARK: - Initialization
  init(searchAlgorithm: SearchAlgorithms, root: TreeNode<Unique<Int>>, done: Bool = false, res: Bool = false) {
    self.searchAlgorithm = searchAlgorithm
    self.root = root
    self.cur = root
    self.done = done
    self.res = res
  }

	// MARK: - Public Functions
  func startSearch(key: Unique<Int>) {
    switch searchAlgorithm {
    case .binarySearch:
      res = binarySearch(key: key, root: root)
      done = true
    case .breadthFirstSearch:
      res = breadthFirstSearch(key: key, root: root)
			done = true
    case .depthFirstSearch:
      depthFirstSearch(key: key, root: root)
      done = true
    }
  }
}

extension SearchModel {
	// MARK: - Private Functions
  private func binarySearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) -> Bool {
    cur = root
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
					(root.val > child.val && root.val > key) {
				return binarySearch(key: key, root: child)
			}
      else { return false }
    }

    // if there are 2 children
    if key < root.val {
      return binarySearch(key: key, root: root.children[0])
    } else {
      return binarySearch(key: key, root: root.children[1])
    }
  }

  private func breadthFirstSearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) -> Bool {
    var queue = [root]
    while !queue.isEmpty {
      let size = queue.count
      for _ in 0..<size {
        cur = queue.remove(at: 0)
				// key found
        if cur.val == key { return true }

        // pause
        sleep(duration)

				// add all children to queue from left child
        for child in cur.children {
          queue.append(child)
        }
      }
    }
    return false
  }

  private func depthFirstSearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) {
    var stack = [root]
    while !stack.isEmpty {
			// pop from front since adding to the front
			// Note: popping from last gives errors sometimes
      cur = stack.removeFirst()
			// key found
      if cur.val == key { return }

      // pause
      sleep(duration)

			// add all children to stack from right child
      for child in cur.children.reversed() {
        stack.insert(child, at: 0)
      }
    }
  }
}

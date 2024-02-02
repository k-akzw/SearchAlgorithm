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
  static let shared = SearchModel(searchAlgorithm: .binarySearch)

	// MARK: - Variables
  let root: TreeNode<Unique<Int>> = Tree.shared.root
  var searchAlgorithm: SearchAlgorithms
  @Published var cur: TreeNode<Unique<Int>>
  @Published var found = false
  @Published var done = false
  
  private let duration: UInt32 = 1

	// MARK: - Initialization
  init(searchAlgorithm: SearchAlgorithms, found: Bool = false, done: Bool = false) {
    self.searchAlgorithm = searchAlgorithm
    self.cur = root
    self.found = found
    self.done = done
  }

	// MARK: - Public Functions
  func startSearch(key: Unique<Int>) {
    done = false
    
    switch searchAlgorithm {
    case .binarySearch:
      binarySearch(key: key, root: root)
      done = true
    case .breadthFirstSearch:
      breadthFirstSearch(key: key, root: root)
			done = true
    case .depthFirstSearch:
      depthFirstSearch(key: key, root: root)
      done = true
    }
  }
}

extension SearchModel {
	// MARK: - Private Functions
  private func binarySearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) {
    DispatchQueue.global(qos: .background).async { [self] in
      // update currently visiting node on main thread
      // to update the UI
      DispatchQueue.main.async {
        self.cur = root
      }

      // if key found
      if root.val == key { return }

      // pause
      sleep(duration)

      // if there is no children
      if root.children.isEmpty { return }

      // if there is only 1 child
      if root.children.count == 1 {
        let child = root.children[0]
        if (root.val < child.val && root.val < key) ||
            (root.val > child.val && root.val > key) {
          return binarySearch(key: key, root: child)
        }
        else { return }
      }

      // if there are 2 children
      if key < root.val {
        return binarySearch(key: key, root: root.children[0])
      } else {
        return binarySearch(key: key, root: root.children[1])
      }
    }
  }

  private func breadthFirstSearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) {
    var queue = [root]

    DispatchQueue.global(qos: .background).async { [self] in
      while !queue.isEmpty {
        let size = queue.count
        for _ in 0..<size {
          let currentNode = queue.remove(at: 0)

          // update currently visiting node on main thread
          // to update the UI
          DispatchQueue.main.async {
            self.cur = currentNode
          }

          // key found
          if currentNode.val == key { return }

          // pause
          sleep(duration)

          // add all children to queue from left child
          for child in currentNode.children {
            queue.append(child)
          }
        }
      }
    }
    return
  }

  private func depthFirstSearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) {
    var stack = [root]

    DispatchQueue.global(qos: .background).async { [self] in
      while !stack.isEmpty {
        // pop from front since adding to the front
        // Note: popping from last gives errors sometimes
        let currentNode = stack.removeFirst()

        // update currently visiting node on main thread
        // to update the UI
        DispatchQueue.main.async {
          self.cur = currentNode
        }
        
        // key found
        if currentNode.val == key { return }

        // pause
        sleep(duration)

        // add all children to stack from right child
        for child in currentNode.children.reversed() {
          stack.insert(child, at: 0)
        }
      }
    }
  }
}

//
//  SearchModel.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/31/24.
//

import SwiftUI

enum SearchAlgorithms: String, CaseIterable {
  case binarySearch = "Binary Search"
  case breadthFirstSearch = "Breadth First Search"
  case depthFirstSearch = "Depth First Search"
}

class SearchModel: ObservableObject {
	// Singleton instance
  static let shared = SearchModel()

	// MARK: - Variables
  @Published var cur: TreeNode<Unique<Int>>
  @Published var found = false
  @Published var done = false

  private let duration: UInt32 = 1

	// MARK: - Initialization
  init(found: Bool = false, done: Bool = false) {
    self.cur = TreeNode(val: Unique(-1))
    self.found = found
    self.done = done
  }

	// MARK: - Public Functions
  func startSearch(key: Unique<Int>, using searchAlgorithm: SearchAlgorithms, from root: TreeNode<Unique<Int>>) {
    done = false
    
    switch searchAlgorithm {
    case .binarySearch:
      binarySearch(key: key, root: root)
    case .breadthFirstSearch:
      breadthFirstSearch(key: key, root: root)
    case .depthFirstSearch:
      depthFirstSearch(key: key, root: root)
    }
  }

  // MARK: - Private Functions

  // updates @found and @done
  // in main thread to update UI
  private func searchDone(found: Bool) {
    DispatchQueue.main.async {
      self.found = found
      self.done = true
    }
  }
}

// MARK: - Search Functions
extension SearchModel {
	// MARK: - Private Functions
  private func binarySearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) {
    var currentNode = root
    DispatchQueue.global(qos: .background).async { [self] in
      while true {
        // pause
        sleep(duration)

        // update currently visiting node on main thread
        // to update the UI
        DispatchQueue.main.async {
          self.cur = currentNode
        }

        // if key found
        if key == currentNode.val {
          searchDone(found: true)
          return
        }

        if key < currentNode.val {
          if let newCur = currentNode.left {
            currentNode = newCur
          } else {
            searchDone(found: false)
            return
          }
        } else {
          if let newCur = currentNode.right {
            currentNode = newCur
          } else {
            searchDone(found: false)
            return
          }
        }
      }
    }
  }

  private func breadthFirstSearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) {
    var queue = [root]

    DispatchQueue.global(qos: .background).async { [self] in
      while !queue.isEmpty {
        let size = queue.count
        for _ in 0..<size {
          // pause
          sleep(duration)

          let currentNode = queue.remove(at: 0)

          // update currently visiting node on main thread
          // to update the UI
          DispatchQueue.main.async {
            self.cur = currentNode
          }

          // key found
          if currentNode.val == key {
            searchDone(found: true)
            return
          }

          // add all children to queue from left child
          for child in currentNode.getChildren() {
            queue.append(child)
          }
        }
      }
      searchDone(found: false)
    }
  }

  private func depthFirstSearch(key: Unique<Int>, root: TreeNode<Unique<Int>>) {
    var stack = [root]

    DispatchQueue.global(qos: .background).async { [self] in
      while !stack.isEmpty {
        // pause
        sleep(duration)
        
        // pop from front since adding to the front
        // Note: popping from last gives errors sometimes
        let currentNode = stack.removeFirst()

        // update currently visiting node on main thread
        // to update the UI
        DispatchQueue.main.async {
          self.cur = currentNode
        }
        
        // key found
        if currentNode.val == key {
          searchDone(found: true)
          return
        }

        // add all children to stack from right child
        for child in currentNode.getChildren().reversed() {
          stack.insert(child, at: 0)
        }
      }
      searchDone(found: false)
    }
  }
}

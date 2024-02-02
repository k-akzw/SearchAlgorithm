//
//  SearchModel.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/31/24.
//

import SwiftUI

enum SearchAlgorithms: String, CaseIterable, Identifiable {
  case binarySearch = "Binary Search"
  case breadthFirstSearch = "Breadth First Search"
  case depthFirstSearch = "Depth First Search"

  var id: Self { self }
}

class SearchModel: NSObject, ObservableObject {
	// Singleton instance
  static let shared = SearchModel()

	// MARK: - Variables
  let root: TreeNode<Unique<Int>> = Tree.shared.root
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
  func startSearch(key: Unique<Int>, using searchAlgorithm: SearchAlgorithms) {
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
    DispatchQueue.global(qos: .background).async { [self] in
      // pause
      sleep(duration)

      // update currently visiting node on main thread
      // to update the UI
      DispatchQueue.main.async {
        self.cur = root
      }

      // if key found
      if root.val == key {
        searchDone(found: true)
        return
      }

      // if there is no children
      if root.children.isEmpty {
        searchDone(found: false)
        return
      }

      // if there is only 1 child
      if root.children.count == 1 {
        let child = root.children[0]
        if (root.val < child.val && root.val < key) ||
            (root.val > child.val && root.val > key) {
          return binarySearch(key: key, root: child)
        }
        else {
          searchDone(found: false)
          return
        }
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
          for child in currentNode.children {
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
        for child in currentNode.children.reversed() {
          stack.insert(child, at: 0)
        }
      }
      searchDone(found: false)
    }
  }
}

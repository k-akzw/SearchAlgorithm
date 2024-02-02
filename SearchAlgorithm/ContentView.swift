//
//  ContentView.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/29/24.
//

import SwiftUI

struct ContentView: View {

  @ObservedObject var searchModel = SearchModel.shared

  var body: some View {
    VStack {
			ScrollView(.horizontal) {
				DiagramModel(treeNode: searchModel.root, node: { value in
					Text("\(value.val)")
				}, searchModel: searchModel)
			}

      Button(action: {
        searchModel.startSearch(key: Unique(18))
      }, label: {
        Text("Start Searching")
					.bold()
					.frame(width: 280, height: 50)
					.foregroundColor(.white)
					.background(Color.blue)
					.cornerRadius(12)
      })
    }
  }
}

#Preview {
  ContentView()
}

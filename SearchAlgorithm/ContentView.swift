//
//  ContentView.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/29/24.
//

import SwiftUI

struct ContentView: View {

  @StateObject var searchModel = SearchModel.shared

  var body: some View {
    VStack {
			ScrollView(.horizontal) {
				DiagramModel(treeNode: searchModel.root, node: { value in
					Text("\(value.val)")
						.modifier(RoundedCircleStyle())
				}, searchModel: searchModel)
			}

      Button(action: {
        print("Button tapped")
        searchModel.startSearch(key: Unique(60))
      }, label: {
        Text("Button")
      })
    }
  }
}

#Preview {
  ContentView()
}

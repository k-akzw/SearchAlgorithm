//
//  ContentView.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/29/24.
//

import SwiftUI

struct ContentView: View {

  @ObservedObject var searchModel = SearchModel.shared
  @State var searchAlgorithm: SearchAlgorithms = .binarySearch
  @State var key: Int = 50

  var body: some View {
    VStack {
      SearchPicker(searchAlgorithm: $searchAlgorithm, key: $key)

      ResultView(searchModel: searchModel)

      ScrollView(.horizontal) {
        DiagramModel(treeNode: searchModel.root, node: { value in
          Text("\(value.val)")
        }, searchModel: searchModel)
      }

      Button(action: {
        searchModel.startSearch(key: Unique(key), using: searchAlgorithm)
      }, label: {
        Text("Start Searching")
          .bold()
          .frame(width: 280, height: 50)
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(12)
      })
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.secondary.opacity(0.1))
  }
}

struct SearchPicker: View {
  @Binding var searchAlgorithm: SearchAlgorithms
  @Binding var key: Int

  @State private var isShowingPopover = false
  @State private var input: String = ""

  var body: some View {
    List {
      Picker("Search Algorithm", selection: $searchAlgorithm) {
        ForEach(SearchAlgorithms.allCases) { val in
          Text(val.rawValue)
        }
      }
      TextField("Enter key: ", text: $input)
        .keyboardType(.numberPad)
        .onChange(of: input) { oldValue, newValue in
          self.input = String(newValue.filter { "0123456789".contains($0) })
          if let newKey = Int(input) {
            key = newKey
          }
        }
    }
    .frame(height: 150)
    .padding(0)
  }
}

struct ResultView: View {
  @ObservedObject var searchModel: SearchModel

  var body: some View {
    HStack {
      Spacer()
      if searchModel.found {
        Text("Key found")
      } else {
        Text("Key not found")
      }
    }
    .opacity(searchModel.done ? 1 : 0)
    .padding(.horizontal)
  }
}

#Preview {
  ContentView()
}

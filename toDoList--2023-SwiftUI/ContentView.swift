//
//  ContentView.swift
//  toDoList--2023-SwiftUI
//
//  Created by Тимур Калимуллин on 20.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var showingDetail = false
    @State private var detailedItem: TodoItem? = nil

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView() {
                    VStack {
                        HStack {
                            Text("Выполненно - ")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                            Spacer()
                            Button("Скрыть") {
                                print("pop")
                            }.foregroundColor(.blue)
                            .font(.system(size: 15))
                            .bold()
                        }
                        .padding([.trailing, .leading], 20)

                        VStack(alignment: .leading) {
                            ForEach(mockData, id: \.id) {item in
                                ToDoItemCellView(item: item)
                                    .onTapGesture {
                                        detailedItem = item
                                        showingDetail.toggle()
                                    }
                                    .sheet(isPresented: $showingDetail) {
                                        if let detailedItem = detailedItem {
                                            ToDoItemDetailedView(item: detailedItem)
                                        }
                                    }
                            }
                            Button("Новое") {
                                print("new")
                            }.frame(height: 54)
                                .foregroundColor(.gray)
                                .padding([.leading], 52)

                        }.background(.white)
                        .cornerRadius(16)
                        .padding([.leading, .trailing], 16)
                    }.background(Color.init(UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)))
                }
                Button {
                    print("bob")
                } label: {
                    Image(systemName: "plus.circle.fill")

                }.font(.system(size: 44))
            }
            .background(Color.init(UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)))
            .navigationTitle("Мои дела")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

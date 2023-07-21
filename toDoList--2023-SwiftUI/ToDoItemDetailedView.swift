//
//  ToDoItemDetailedView.swift
//  toDoList--2023-SwiftUI
//
//  Created by Тимур Калимуллин on 21.07.2023.
//

import SwiftUI

struct ToDoItemDetailedView: View {
    var item: TodoItem

    @State private var text: String
    @State private var importanceType: String
    @State private var isDeadline: Bool = false
    @State private var date: Date = Date()

    init(item: TodoItem) {
        self.item = item
        self._text = State<String>.init(initialValue: item.getText())
        self._importanceType = State<String>.init(initialValue: item.getImportanceTypeString())

        if let deadline = item.getDeadline() {
            _isDeadline = State<Bool>.init(initialValue: true)
            _date = State<Date>.init(initialValue: deadline)
        }

    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter
    }()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Button("Отменить") {
                        print("pass")
                    }.font(.system(size: 17))
                        .foregroundColor(.blue)
                    Spacer()
                    Text("Дело")
                        .font(.system(size: 17))
                        .bold()
                    Spacer()
                    Button("Cохранить") {
                        print("save")
                    }.font(.system(size: 17))
                        .bold()
                        .foregroundColor(.blue)
                }.padding([.trailing, .leading], 16).frame(height: 56)

                VStack(alignment: .leading, spacing: 16) {
                    VStack{
                        TextField("Что надо сделать", text: $text,  axis: .vertical)
                            .font(.system(size: 17))
                            .frame(minHeight: 120, alignment: .top)
                            .background(.white)
                            .foregroundColor(.black)

                    }.padding(16).background(.white).cornerRadius(16)

                    VStack(spacing: 0) {
                        HStack {
                            Text("Важность")
                                .font(.system(size: 17))

                            Spacer()

                            Picker("", selection: $importanceType) {
                                Image(systemName: "arrow.down")
                                    .foregroundColor(.gray)
                                    .tag("unimportant")
                                Text("нет").tag("reqular")
                                Image(systemName: "exclamationmark.2")
                                    .foregroundColor(.red)
                                    .tag("important")

                            }.pickerStyle(.segmented)
                                .frame(width: 150, height: 36)

                        }.frame(height: 56).background(.white)

                        Divider()

                        HStack {
                            VStack(alignment: .leading){
                                Text("Сделать до")

                                if let deadline = item.getDeadline() {
                                    Text(dateFormatter.string(from: deadline))
                                        .font(.system(size: 13))
                                        .foregroundColor(.blue)
                                        .bold()
                                }
                            }
                            Spacer()
                            Toggle("Сделать до", isOn: $isDeadline).labelsHidden()
                        }.frame(height: 56).background(.white)

                        if let deadline = item.getDeadline() {
                            Divider()
                            DatePicker(
                                "Start Date",
                                selection: $date,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                            .background(.white)

                        }
                    }.padding([.trailing, .leading], 16).background(.white).cornerRadius(16)

                    HStack{
                        Button("Удалить") {
                            print("delete")
                        }.foregroundColor(.red)
                            .frame(height: 56)
                    }
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(16)
                }.padding([.trailing, .leading], 16)
            }.background(Color.init(UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)))
        }.background(Color.init(UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)))
    }
}

struct ToDoItemDetailedView_Previews: PreviewProvider {
    static var item = TodoItem(text: "bdscjsncxzczxcxjnkkljkljkljkljkljkljkljkljkljzcxzcxzcoba", importanceType: .reqular, deadline: Date(timeIntervalSince1970: 1689763444), flag: false)
    static var previews: some View {
        ToDoItemDetailedView(item: item)
    }
}

//
//  ToDoItemCell.swift
//  toDoList--2023-SwiftUI
//
//  Created by Тимур Калимуллин on 20.07.2023.
//

import SwiftUI

struct ToDoItemCellView: View {
    let item: TodoItem
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter
    }()

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.getFlag() ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.getFlag() ? .green : .secondary)
                .font(.system(size: 24))
            HStack(spacing: 8) {
                if item.getImportanceTypeString() == "important" {
                    Image(systemName: "exclamationmark.2")
                        .foregroundColor(.red)
                } else if item.getImportanceTypeString() == "unimportant" {
                    Image(systemName: "arrow.down")
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading) {
                    Text(item.getText())
                        .font(.system(size: 17))
                        .lineLimit(3)
                        .padding(.trailing)
                        .foregroundColor(item.getFlag() ? .gray : .black)
                        .strikethrough(item.getFlag())

                    if let deadline = item.getDeadline() {
                        HStack(spacing: 0) {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                            Text(dateFormatter.string(from: deadline))
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding([.trailing, .leading, .top, .bottom], 12)
    }
}

struct ToDoItemCell_Previews: PreviewProvider {
    static var item = TodoItem(text: "bdscjsncoba", importanceType: .important, deadline: Date(), flag: false)
    static var previews: some View {
        ToDoItemCellView(item: item)
    }
}

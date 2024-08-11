//
//  ShowListViewModel.swift
//  FilterResult-Mintoak
//
//  Created by Tushar on 11/08/24.
//

import Foundation

class ShowListViewModel {
    var dataList: [String] = []
    var selectedItems: [String] = []
    var lblTxt: String?
    var isMIDFilterMode: Bool = false

    func loadData(dataList: [String], label: String?, isMIDFilterMode: Bool) {
        self.dataList = dataList
        self.selectedItems = dataList
        self.lblTxt = label
        self.isMIDFilterMode = isMIDFilterMode
    }

    func toggleSelectAll() {
        if selectedItems.count == dataList.count {
            selectedItems.removeAll()
        } else {
            selectedItems = dataList
        }
    }

    func toggleSelection(at index: Int) {
        let selectedItem = dataList[index]
        if selectedItems.contains(selectedItem) {
            selectedItems.removeAll { $0 == selectedItem }
        } else {
            selectedItems.append(selectedItem)
        }
    }

    func isSelected(item: String) -> Bool {
        return selectedItems.contains(item)
    }
}

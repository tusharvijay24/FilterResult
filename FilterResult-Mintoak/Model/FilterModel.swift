//
//  FilterModel.swift
//  FilterResult-Mintoak
//
//  Created by Tushar on 10/08/24.
//

// FilterModel.swift
import Foundation

struct FilterModel: Codable {
    let filterData: [Company]
}

struct Company: Codable {
    let companyName: String
    let accountList: [String]
    let brandList: [String]
    let locationList: [String]
    let hierarchy: [AccountHierarchy]
}

struct AccountHierarchy: Codable {
    let accountNumber: String
    var brandNameList: [Brand]
}

struct Brand: Codable {
    let brandName: String
    var locationNameList: [Location]
}

struct Location: Codable {
    let locationName: String
    let merchantNumber: [Merchant]
}

struct Merchant: Codable {
    let mid: String
    let outletNumber: [String]
}


//
//  HomeViewModel.swift
//  FilterResult-Mintoak
//
//  Created by Tushar on 11/08/24.
//

import Foundation

class HomeViewModel {
    var companies: [Company] = []
    
    func loadCompanies(from rtfPath: String, completion: @escaping (Error?) -> Void) {
        if let path = Bundle.main.path(forResource: rtfPath, ofType: "rtf") {
            do {
                let rtfData = try Data(contentsOf: URL(fileURLWithPath: path))
                let attributedString = try NSAttributedString(data: rtfData, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                let jsonString = attributedString.string
                
                if let jsonData = jsonString.data(using: .utf8) {
                    let filterModel = try JSONDecoder().decode(FilterModel.self, from: jsonData)
                    self.companies = filterModel.filterData
                    completion(nil)
                } else {
                    completion(NSError(domain: "Conversion Error", code: 1, userInfo: nil))
                }
            } catch {
                completion(error)
            }
        } else {
            completion(NSError(domain: "Path Error", code: 2, userInfo: nil))
        }
    }
}

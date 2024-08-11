//
//  FilterViewModel.swift
//  FilterResult-Mintoak
//
//  Created by Tushar on 11/08/24.
//

import Foundation

class FilterViewModel {
    var selectedCompany: Company?
    
    var selectedAccounts: [String] = []
    var selectedBrands: [String] = []
    var selectedLocations: [String] = []
    
    var filteredAccounts: [String] = []
    var filteredBrands: [String] = []
    var filteredLocations: [String] = []
    
    var categoryPriority: [String] = []
    
    func loadData() {
        guard let company = selectedCompany else { return }
        
        selectedAccounts = company.accountList
        selectedBrands = company.brandList
        selectedLocations = company.locationList
        
        filteredAccounts = selectedAccounts
        filteredBrands = selectedBrands
        filteredLocations = selectedLocations
    }
    
    func clearSelections() {
        guard let company = selectedCompany else { return }
        
        selectedAccounts = company.accountList
        selectedBrands = company.brandList
        selectedLocations = company.locationList
        
        filteredAccounts = selectedAccounts
        filteredBrands = selectedBrands
        filteredLocations = selectedLocations
        
        categoryPriority.removeAll()
    }
    
    func updateFilterForCategory(_ category: String) {
        guard let company = selectedCompany else { return }
        
        switch category {
        case "Account":
            filteredBrands = company.hierarchy.filter { filteredAccounts.contains($0.accountNumber) }
                .flatMap { $0.brandNameList.map { $0.brandName } }
            filteredLocations = company.hierarchy.filter { filteredAccounts.contains($0.accountNumber) }
                .flatMap { $0.brandNameList }
                .flatMap { $0.locationNameList.map { $0.locationName } }
        case "Brand":
            filteredAccounts = company.hierarchy.filter { account in
                account.brandNameList.contains { filteredBrands.contains($0.brandName) }
            }.map { $0.accountNumber }
            filteredLocations = company.hierarchy.flatMap { $0.brandNameList }
                .filter { filteredBrands.contains($0.brandName) }
                .flatMap { $0.locationNameList.map { $0.locationName } }
        case "Location":
            filteredAccounts = company.hierarchy.filter { account in
                account.brandNameList.contains { brand in
                    brand.locationNameList.contains { filteredLocations.contains($0.locationName) }
                }
            }.map { $0.accountNumber }
            filteredBrands = company.hierarchy.flatMap { $0.brandNameList }
                .filter { brand in
                    brand.locationNameList.contains { filteredLocations.contains($0.locationName) }
                }.map { $0.brandName }
        default:
            break
        }
    }
    
    func filterMIDs() -> [String] {
        guard var filteredHierarchy = selectedCompany?.hierarchy else { return [] }
        
        if categoryPriority.contains("Account") {
            filteredHierarchy = filteredHierarchy.filter { filteredAccounts.contains($0.accountNumber) }
        }
        
        if categoryPriority.contains("Brand") {
            filteredHierarchy = filteredHierarchy.map { account in
                var filteredAccount = account
                filteredAccount.brandNameList = account.brandNameList.filter { filteredBrands.contains($0.brandName) }
                return filteredAccount
            }
        }
        
        if categoryPriority.contains("Location") {
            filteredHierarchy = filteredHierarchy.map { account in
                var filteredAccount = account
                filteredAccount.brandNameList = account.brandNameList.map { brand in
                    var filteredBrand = brand
                    filteredBrand.locationNameList = brand.locationNameList.filter { filteredLocations.contains($0.locationName) }
                    return filteredBrand
                }
                return filteredAccount
            }
        }
        
        var midNumbers: [String] = []
        for account in filteredHierarchy {
            for brand in account.brandNameList {
                for location in brand.locationNameList {
                    for merchant in location.merchantNumber {
                        midNumbers.append(merchant.mid)
                    }
                }
            }
        }
        return midNumbers
    }
}


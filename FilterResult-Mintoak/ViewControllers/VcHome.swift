//
//  ViewController.swift
//  FilterResult-Mintoak
//
//  Created by Tushar on 11/08/24.
//


import UIKit

class VcHome: UIViewController {
    
    @IBOutlet weak var btnCompanyOne: UIButton!
    @IBOutlet weak var btnCompanyTwo: UIButton!
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        viewModel.loadCompanies(from: "jsonFile") { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error loading data: \(error)")
                return
            }
            self.setupButtons()
        }
    }
    
    private func setupButtons() {
        if viewModel.companies.count > 0 {
            btnCompanyOne.setTitle(viewModel.companies[0].companyName, for: .normal)
        }
        
        if viewModel.companies.count > 1 {
            btnCompanyTwo.setTitle(viewModel.companies[1].companyName, for: .normal)
        }
    }
    
    @IBAction func didTapCompanyOne(_ sender: UIButton) {
        openFilterScreen(forCompanyAtIndex: 0)
    }

    @IBAction func didTapCompanyTwo(_ sender: UIButton) {
        openFilterScreen(forCompanyAtIndex: 1)
    }

    private func openFilterScreen(forCompanyAtIndex index: Int) {
        guard viewModel.companies.indices.contains(index),
              let filterVC = storyboard?.instantiateViewController(withIdentifier: "VcFilter") as? VcFilter else {
            return
        }
        
        filterVC.modalPresentationStyle = .pageSheet
        filterVC.modalTransitionStyle = .coverVertical
        
        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        filterVC.viewModel.selectedCompany = viewModel.companies[index]
        filterVC.onApplyFilter = { [weak self] filteredMIDs in
            self?.openMIDResultsScreen(with: filteredMIDs)
        }
        present(filterVC, animated: true, completion: nil)
    }

    private func openMIDResultsScreen(with mids: [String]) {
        if let showListVC = storyboard?.instantiateViewController(withIdentifier: "VcShowList") as? VcShowList {
            showListVC.viewModel.loadData(dataList: mids, label: "Filtered MID Numbers", isMIDFilterMode: true)
            present(showListVC, animated: true, completion: nil)
        }
    }


}

//
//  VcFilter.swift
//  FilterResult-Mintoak
//
//  Created by Tushar on 10/08/24.
//

import UIKit

class VcFilter: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAccNo: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnApply: UIButton!
    
    let viewModel = FilterViewModel()
    var onApplyFilter: (([String]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        viewModel.loadData()
        updateLabels()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
    }
    
    func updateLabels() {
        lblName.text = viewModel.selectedCompany?.companyName
        lblAccNo.text = "Account No.: \(viewModel.filteredAccounts.count)"
        lblBrand.text = "Brand: \(viewModel.filteredBrands.count)"
        lblLocation.text = "Location: \(viewModel.filteredLocations.count)"
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        viewModel.clearSelections()
        dismiss(animated: true)
    }
    
    @IBAction func didTapClear(_ sender: UIButton) {
        viewModel.clearSelections()
        updateLabels()
        tblView.reloadData()
    }
    
    @IBAction func didTapApply(_ sender: UIButton) {
        let midNumbers = viewModel.filterMIDs()
        print("Filtered MID Numbers: \(midNumbers)")
        dismiss(animated: true) { [weak self] in
            self?.onApplyFilter?(midNumbers)
        }
    }
}

extension VcFilter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Select Account Numbers"
            cell.detailTextLabel?.text = "(\(viewModel.filteredAccounts.count))"
        case 1:
            cell.textLabel?.text = "Select Brands"
            cell.detailTextLabel?.text = "(\(viewModel.filteredBrands.count))"
        case 2:
            cell.textLabel?.text = "Select Locations"
            cell.detailTextLabel?.text = "(\(viewModel.filteredLocations.count))"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dataToPass: [String] = []
        var title: String = ""
        
        switch indexPath.row {
        case 0:
            dataToPass = viewModel.filteredAccounts
            title = "Select Account Numbers"
        case 1:
            dataToPass = viewModel.filteredBrands
            title = "Select Brands"
        case 2:
            dataToPass = viewModel.filteredLocations
            title = "Select Locations"
        default:
            break
        }
        
        openShowList(with: dataToPass, title: title) { [weak self] selectedItems in
            guard let self = self else { return }
            if !self.viewModel.categoryPriority.contains(title) {
                self.viewModel.categoryPriority.append(title)
            }
            switch indexPath.row {
            case 0:
                self.viewModel.filteredAccounts = selectedItems
                self.viewModel.updateFilterForCategory("Account")
            case 1:
                self.viewModel.filteredBrands = selectedItems
                self.viewModel.updateFilterForCategory("Brand")
            case 2:
                self.viewModel.filteredLocations = selectedItems
                self.viewModel.updateFilterForCategory("Location")
            default:
                break
            }
            self.updateLabels()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func openShowList(with data: [String], title: String, completion: @escaping ([String]) -> Void) {
        if let showListVC = storyboard?.instantiateViewController(withIdentifier: "VcShowList") as? VcShowList {
            showListVC.viewModel.loadData(dataList: data, label: title, isMIDFilterMode: false)
            showListVC.onApplySelection = completion
            present(showListVC, animated: true)
        }
    }
}

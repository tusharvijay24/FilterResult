//
//  VcShowDataList.swift
//  FilterResult-Mintoak
//
//  Created by Tushar on 10/08/24.
//
import UIKit

class VcShowList: UIViewController {
    
    @IBOutlet weak var lblSelectedName: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var selectAllView: UIView!
    
    let viewModel = ShowListViewModel()
    
    var onApplySelection: (([String]) -> Void)? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        lblSelectedName.text = viewModel.lblTxt
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
        updateSelectAllIcon()
        
        selectAllView.isHidden = viewModel.isMIDFilterMode
        btnApply.isHidden = viewModel.isMIDFilterMode
        imgSelect.isHidden = viewModel.isMIDFilterMode
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        viewModel.selectedItems.removeAll()
        dismiss(animated: true)
    }
    
    @IBAction func didTapSelectAll(_ sender: UIButton) {
        viewModel.toggleSelectAll()
        tblView.reloadData()
        updateSelectAllIcon()
    }
    
    @IBAction func didTapClear(_ sender: UIButton) {
        viewModel.selectedItems.removeAll()
        tblView.reloadData()
        updateSelectAllIcon()
    }
    
    @IBAction func didTapApply(_ sender: UIButton) {
        onApplySelection?(viewModel.selectedItems)
        dismiss(animated: true)
    }
    
    private func updateSelectAllIcon() {
        let symbolName = viewModel.selectedItems.count == viewModel.dataList.count ? "check" : "square"
        imgSelect.image = UIImage(named: symbolName)
    }
}

extension VcShowList: UITableViewDelegate, UITableViewDataSource {
    
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TvCellShowList", for: indexPath) as! TvCellShowList
        let item = viewModel.dataList[indexPath.row]
        
        cell.lblShow?.text = item
        
        
        if !viewModel.isMIDFilterMode {
            let symbolName = viewModel.isSelected(item: item) ? "check" : "square"
            cell.imgSelect.image = UIImage(named: symbolName)
        } else {
            cell.imgSelect.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleSelection(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        updateSelectAllIcon()
    }
}

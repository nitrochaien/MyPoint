//
//  PickerTextField.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/31/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Localize

class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataList = [String]()
    
    private var picker: UIPickerView!
    
    private(set) var selectedRow: Int = 0
    
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(dataList: [String], row: Int = 0) {
        self.dataList = dataList
        self.selectedRow = row
        
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        picker.selectRow(row, inComponent: 0, animated: false)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let doneItem = UIBarButtonItem(title: "button_done".localized, style: .done, target: self, action: #selector(done))
//            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(title: "button_cancel".localized, style: .done, target: self, action: #selector(cancel))
//            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelItem, flexibleSpace, doneItem], animated: true)
        
        self.inputView = picker
        self.inputAccessoryView = toolbar
        
        self.text = dataList[selectedRow]
    }
  
    @objc func cancel() {
        // 選択行を元に戻す
        self.picker.selectRow(selectedRow, inComponent: 0, animated: false)
        self.endEditing(true)
    }
    
    @objc func done() {
        // 変化があった時だけ
        if selectedRow != picker.selectedRow(inComponent: 0) {
            selectedRow = picker.selectedRow(inComponent: 0)
            self.text = dataList[selectedRow]
            self.sendActions(for: .valueChanged)
        }
        
        self.endEditing(true)
    }
    
    // 入力カーソル非表示
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    // コピー・ペースト・選択等のメニュー非表示
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
    }
}

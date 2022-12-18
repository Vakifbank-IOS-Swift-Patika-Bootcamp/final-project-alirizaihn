//
//  SortingView.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 14.12.2022.
//


import UIKit

final class SortingView: UIView {
    
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var topCons: NSLayoutConstraint!
    
    @IBOutlet private weak var sortingPickerView: UIPickerView!
    private let viewTag = 1003
    private var completion: ((SortingItems?) -> ())?
    private var selectedRatingItem: SortingItems?
//    private var list: [String] = []
    static let shared:SortingView = {
        return SortingView.instantiate(autolayout: false)
    }()
    
    class func showView(completion: ((SortingItems?) -> ())?){
        
    
        let selfWindow: UIWindow? = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        selfWindow?.windowLevel = .alert
        self.shared.sortingPickerView.delegate = self.shared.self
        self.shared.sortingPickerView.dataSource = self.shared.self
        self.shared.sortingPickerView.showsSelectionIndicator = true
        self.shared.frame = selfWindow?.frame ?? .zero
        self.shared.tag = self.shared.viewTag
        self.shared.completion = completion
        UIView.animate(withDuration: 0.5) {
            self.shared.topCons.constant = -230
        }
       
       
        if selfWindow?.viewWithTag(self.shared.viewTag) == nil {
            selfWindow?.addSubview(self.shared)
        }
    }
    @IBAction func closeRatingFilter(_ sender: Any) {
        SortingView.close()
    }
    
    @IBAction func selectRatingFilter(_ sender: Any) {
        self.completion?(selectedRatingItem)
        SortingView.close()
    }
    
    class func close(){
        UIView.animate(withDuration: 0.5) {
            self.shared.topCons.constant = 0
            let selfWindow: UIWindow = ((UIApplication
                .shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }))!
            selfWindow.viewWithTag(self.shared.viewTag)?.removeFromSuperview()
        }

   
    }
    
}
extension SortingView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        SortingItems.allCases.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        SortingItems.allCases[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRatingItem = SortingItems.allCases[row]
    }
}

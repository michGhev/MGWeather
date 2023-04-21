//
//  BaseVC.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit

class BaseVC: UIViewController, VMToVCExchange {
   
   func performLanguageSensitiveRequests() {
       
   }
   
   func dataFetched<T>(type: T.Type, data: [T], observerName: String) {
       
   }
   
   func dataFetched<T>(type: T.Type, data: T, observerName: String) {
       
   }
   
   func invalidDataErrorReceived<T>(fieldType: T.Type, data: [String: String]) {
       ActivityIndicatorView.shared.stopAnimating()
       popup(title: "Error", data: data.first?.value)
    }
   
   func errorReceived(error: NetworkError) {
       ActivityIndicatorView.shared.stopAnimating()
       popup(title: "Error", data: error.localizedDescription)
   }
    
    func popup(title: String, data: String?) {
        let alert = UIAlertController(title: title, message: data ?? "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                return
            }
        }))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
             self.present(alert, animated: true, completion: nil)
        }
    }
      
   public override func viewDidLoad() {
       super.viewDidLoad()
       self.overrideUserInterfaceStyle = .light
       let vm = self.getVM()
       vm?.baseDelegate = self
   }
    
   public override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
   }

   public override func viewDidDisappear(_ animated: Bool) {
       super.viewDidDisappear(animated)
   }
      
   // MARK: Init UI elements
   
   private func commonInitUIElements() {
       self.view.backgroundColor = .white
   }
    
   // MARK: - Functions

   func endEditing(_ force: Bool) {
       view.endEditing(force)
   }
   
   func getVM() -> BaseVM? {
       let mirror = Mirror(reflecting: self)
       return mirror.children.first(where: { $0.label == "vm" || $0.label == "viewModel" })?.value as? BaseVM
   }
}

extension BaseVC: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       view.endEditing(true)
   }
}

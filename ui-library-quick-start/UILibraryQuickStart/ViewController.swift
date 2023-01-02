//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import AzureCommunicationCalling
import AzureCommunicationUICalling
import SwiftForms
import SwiftUI

class ViewController: UIViewController {
    @Published var loading: Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadForm()
    }
    
    // MARK: Private interface
    
    private func loadForm() {
        let formController = UIHostingController(rootView: ContentView(
//            loading: self.loading,
            name: "Guest",
            showConfiguration: false,
            notificationsEnabled: false))
        
        if let form = formController.view {
            form.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(form)
            form.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = false
            form.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            form.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            
            self.addChild(formController)
        }
    }
}

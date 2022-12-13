//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import AzureCommunicationCalling
import AzureCommunicationUICalling

class ViewController: UIViewController {

    private var callComposite: CallComposite?
    private var startButton: UIButton = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
    private var displayName: UITextField = UITextField(frame: CGRect(x: 100, y: 150, width: 200, height: 50))
    private var teamsLink: UITextField = UITextField(frame: CGRect(x: 100, y: 220, width: 200, height: 50))
    private var acsToken: UITextField = UITextField(frame: CGRect(x: 100, y: 290, width: 200, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        self.startButton.layer.cornerRadius = 10
        self.startButton.backgroundColor = .systemBlue
        self.startButton.setTitle("Start Experience", for: .normal)
        self.startButton.addTarget(self, action: #selector(startCallComposite), for: .touchUpInside)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.startButton)
        self.startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.startButton.isEnabled = false
        self.startButton.alpha = 0.5

        self.displayName.text = "Guest"
        self.teamsLink.placeholder = "Teams Meating Link"
        self.teamsLink.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        intializeTextfield(txtField: self.displayName)
        intializeTextfield(txtField: self.teamsLink)
        intializeTextfield(txtField: self.acsToken)
    }
    
    private func intializeTextfield(txtField: UITextField)
    {
//        self.teamsLink.backgroundColor = .systemBlue
//        self.teamsLink.textColor = .white
        txtField.layer.cornerRadius = 10
        txtField.keyboardType = UIKeyboardType.default
        txtField.returnKeyType = UIReturnKeyType.done
        txtField.autocorrectionType = UITextAutocorrectionType.no
        txtField.font = UIFont.systemFont(ofSize: 13)
        txtField.borderStyle = UITextField.BorderStyle.roundedRect
        txtField.clearButtonMode = UITextField.ViewMode.whileEditing;
        txtField.returnKeyType = .next
        txtField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.view.addSubview(txtField)
    }
    
    private func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if (verifyUrl(urlString: self.teamsLink.text)) {
            self.startButton.isEnabled = false
            self.startButton.alpha = 0.5
        }
        else {
            self.startButton.isEnabled = true
            self.startButton.alpha = 1.0
        }
    }

    @objc private func startCallComposite() {
        let callCompositeOptions = CallCompositeOptions()

        callComposite = CallComposite(withOptions: callCompositeOptions)
        let communicationTokenCredential = try! CommunicationTokenCredential(token: "eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwNiIsIng1dCI6Im9QMWFxQnlfR3hZU3pSaXhuQ25zdE5PU2p2cyIsInR5cCI6IkpXVCJ9.eyJza3lwZWlkIjoiYWNzOmEwNjUzOTA2LWNiNjYtNDA0MC05ZWU0LWVmNjA1NzIwMThiN18wMDAwMDAxNC1lZWIzLWYyMjUtODc0YS1hZDNhMGQwMDg0NTciLCJzY3AiOjE3OTIsImNzaSI6IjE2Njc3Njk3MTYiLCJleHAiOjE2Njc4NTYxMTYsImFjc1Njb3BlIjoidm9pcCIsInJlc291cmNlSWQiOiJhMDY1MzkwNi1jYjY2LTQwNDAtOWVlNC1lZjYwNTcyMDE4YjciLCJyZXNvdXJjZUxvY2F0aW9uIjoiZXVyb3BlIiwiaWF0IjoxNjY3NzY5NzE2fQ.XAGOdHX8GZyr0M_sH6uAELaWh9EuvESA5gx_TKvBjmGSJdAd2NtK_TtpgAV6-1jKNxu8RFL1PGLGsXfGrMBMlWy70L2wFC_8r9HHWaofTlk0vhTsgbvf_eihskGx1HKfpUhRxAg7bDlRD7R-_87YLaltMR_GfYFsQjx7lsPqRXAxWGj380xgxL310_FLCrvK9axvls7Mk3FLFkh3GT6xQr_4UikYxDxhE9Onu_KZ9qIWqivJGl4I29cd7OU8ekFeM_fIngXdMN8Kj6NtaTFA7jJxCnkI-1kDvd-zNA3gVP_gQo5nw2_eqS3JKHYsQ6ExlhsnKsZOyzLPIKBGlqcIMA")

        let remoteOptions = RemoteOptions(
            for:
//              .groupCall(groupId: UUID(uuidString: "<GROUP_CALL_ID>")!),
                .teamsMeeting(teamsLink: self.teamsLink.text!),
            credential: communicationTokenCredential,
            displayName: self.displayName.text)

        callComposite?.launch(remoteOptions: remoteOptions)
    }
}

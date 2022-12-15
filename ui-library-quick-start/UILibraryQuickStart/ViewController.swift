//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import AzureCommunicationCalling
import AzureCommunicationUICalling
import SwiftForms

class ViewController: UIViewController {

    let ACSTokenFunctionUrl: String = "https://acs-services.azurewebsites.net/api/get-acs-token"
    let ACSTokenFunctionCode: String = "jvidI4UrhZw7owoYIbXSBha2f9gqr6vlbWHYqnQXyLNEAzFuiRVoLg=="
    var DefaultTeamsLink: String = "https://teams.microsoft.com/l/meetup-join/19%3ameeting_N2QyN2ZhMjktMGJhOS00ODE3LWI3OWYtODFmYmZkNmUxZDk0%40thread.v2/0?context=%7b%22Tid%22%3a%2272f988bf-86f1-41af-91ab-2d7cd011db47%22%2c%22Oid%22%3a%22306b794d-9ae0-42cc-8e24-56aa267578b0%22%7d"
    
    
    var urlComponents: URLComponents? {
        var urlComponents = URLComponents(string: ACSTokenFunctionUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "code", value: ACSTokenFunctionCode)
        ]

        return urlComponents
    }
    private var callComposite: CallComposite?
    private var displayName: UITextField = UITextField(frame: CGRect(x: 100, y: 150, width: 200, height: 50))
    private var teamsLink: UITextField = UITextField(frame: CGRect(x: 100, y: 220, width: 200, height: 50))
    private var acsToken: UITextField = UITextField(frame: CGRect(x: 100, y: 290, width: 200, height: 100))
    private var acsTokenExpiry: UITextField = UITextField(frame: CGRect(x: 100, y: 360, width: 200, height: 50))
    private var startButton: UIButton = UIButton(frame: CGRect(x: 100, y: 430, width: 200, height: 50))

//    private var displayName: String = "Guest"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // Create form instace
//        var form = FormDescriptor()
//        form.title = "Azure Communication Services"
//
//        // Define first section
//        var section1 = FormSectionDescriptor(headerTitle: "Teams Call Settings", footerTitle: "Enter Teams Meeting Link")
//
//        var row = FormRowDescriptor(tag: "name", type: .text, title: "Display Name")
//        section1.rows.append(row)
//
//        row = FormRowDescriptor(tag: "link", type: .url, title: "Meating Link")
//        section1.rows.append(row)
//
//        row = FormRowDescriptor(tag: "token", type: .multilineText, title: "ACS Token")
//        section1.rows.append(row)
//
//
//        // Define second section
//        var section2 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
//
//        row = FormRowDescriptor(tag: "button", type: .button, title: "Start Experience")
//        section2.rows.append(row)
//
//        form.sections = [section1, section2]
//
//        self.form = form
        
        
        self.displayName.text = "Guest"
        self.teamsLink.placeholder = "Teams Meating Link"
        self.teamsLink.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.teamsLink.text = DefaultTeamsLink;
        self.acsToken.text = "TOKEN UNSET"
        self.acsTokenExpiry.text = "TOKEN Expiry UNSET"

        intializeTextfield(txtField: self.displayName)
        intializeTextfield(txtField: self.teamsLink)
        intializeTextfield(txtField: self.acsToken)
        intializeTextfield(txtField: self.acsTokenExpiry)
        initializeButton(button: self.startButton)
        self.startButton.isEnabled = false
        self.startButton.alpha = 0.5

        fetchToken();
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
        txtField.leftViewMode = .always
        let label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.text = "Hello"
        label.font = UIFont.systemFont(ofSize: 13)
//        txtField.leftView = label
        txtField.leftView?.addSubview(label)

        self.view.addSubview(txtField)
    }
    
    private func initializeButton(button: UIButton){
        button.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.setTitle("Start Experience", for: .normal)
        button.addTarget(self, action: #selector(startCallComposite), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
//        self.startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        self.startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
    private func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    private func fetchToken() -> Void
    {
        if let urlComponents = urlComponents, let url = urlComponents.url?.absoluteURL {
            sendRequest(url) { (result, error) in
                DispatchQueue.main.async {
                    if(result != nil){
                        self.acsToken.text = (result!["token"] as! String)
                        self.acsTokenExpiry.text = (result!["expiresOn"] as! String)
                    }
                }
            }
        }
    }
    
    func sendRequest(_ url: URL, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, // is there data
                let response = response as? HTTPURLResponse, // is there HTTP response
                (200 ..< 300) ~= response.statusCode, // is statusCode 2XX
                error == nil else { // was there no error, otherwise ...
                    completion(nil, error)
                    return
            }
            let responseObject: [String: Any]? = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    // MARK: Actions
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if (!verifyUrl(urlString: self.teamsLink.text)) {
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
        let communicationTokenCredential = try! CommunicationTokenCredential(token: self.acsToken.text!)

        let remoteOptions = RemoteOptions(
            for:
//              .groupCall(groupId: UUID(uuidString: "<GROUP_CALL_ID>")!),
                .teamsMeeting(teamsLink: self.teamsLink.text!),
            credential: communicationTokenCredential,
            displayName: self.displayName.text)

        callComposite?.launch(remoteOptions: remoteOptions)
    }
}

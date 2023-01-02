//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import AzureCommunicationCalling
import AzureCommunicationUICalling
import SwiftForms
import SwiftUI

class ACSToken: ObservableObject {
    @Published var accessToken: String = ""
    @Published var expiresOn: String = ""
}

class ViewController: UIViewController {
    @Published var loading: Bool = false
    @State var _displayName: String = "Guest"
    @State var _teamsLink: String = ""
    @State var _token: ACSToken = ACSToken()
//    @State var _loading = false
    
    struct Tags {
            static let name = "name"
            static let link = "link"
            static let token = "token"
            static let expiresOn = "expiresOn"
            static let button = "button"
        }
    
    let ACSTokenFunctionUrl: String = "https://acs-services.azurewebsites.net/api/get-acs-token"
    let ACSTokenFunctionCode: String = "jvidI4UrhZw7owoYIbXSBha2f9gqr6vlbWHYqnQXyLNEAzFuiRVoLg=="
    var DefaultTeamsLink: String = "https://teams.microsoft.com/l/meetup-join/19%3ameeting_N2QyN2ZhMjktMGJhOS00ODE3LWI3OWYtODFmYmZkNmUxZDk0%40thread.v2/0?context=%7b%22Tid%22%3a%2272f988bf-86f1-41af-91ab-2d7cd011db47%22%2c%22Oid%22%3a%22306b794d-9ae0-42cc-8e24-56aa267578b0%22%7d"
    
//    var urlComponents: URLComponents? {
//        var urlComponents = URLComponents(string: ACSTokenFunctionUrl)
//        urlComponents?.queryItems = [
//            URLQueryItem(name: "code", value: ACSTokenFunctionCode)
//        ]   
//
//        return urlComponents
//    }
    private var callComposite: CallComposite?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start Experience", style: .plain, target: self, action: #selector(self.startCallComposite(_:)))
        self.loadForm()
//        fetchToken();
    }
    
    
    private func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
//    private func fetchToken() -> Void
//    {
//        if let urlComponents = urlComponents, let url = urlComponents.url?.absoluteURL {
//            sendRequest(url) { (result, error) in
//                DispatchQueue.main.async {
//                    if(result != nil){
//                        self._loading = false;
//                        self._token.accessToken = (result!["token"] as! String)
//                        self._token.expiresOn = (result!["expiresOn"] as! String)
//                    }
//                }
//            }
//        }
//    }
//    
//    func sendRequest(_ url: URL, completion: @escaping ([String: Any]?, Error?) -> Void) {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, // is there data
//                let response = response as? HTTPURLResponse, // is there HTTP response
//                (200 ..< 300) ~= response.statusCode, // is statusCode 2XX
//                error == nil else { // was there no error, otherwise ...
//                    completion(nil, error)
//                    return
//            }
//            let responseObject: [String: Any]? = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
//            completion(responseObject, nil)
//        }
//        task.resume()
//    }
    
    // MARK: Actions
    
//    @objc private func startCallComposite(_: UIBarButtonItem!) {
//        let callCompositeOptions = CallCompositeOptions()
//
//        callComposite = CallComposite(withOptions: callCompositeOptions)
//        let communicationTokenCredential = try! CommunicationTokenCredential(token: String(describing: self._token.accessToken))
//
//        let remoteOptions = RemoteOptions(
//            for:
////              .groupCall(groupId: UUID(uuidString: "<GROUP_CALL_ID>")!),
//                .teamsMeeting(teamsLink: String(describing: self._teamsLink)),
//            credential: communicationTokenCredential,
//            displayName: String(describing: self._displayName))
//
//        callComposite?.launch(remoteOptions: remoteOptions)
//    }
    
    
    // MARK: Private interface
    
    private func loadForm() {
        let formController = UIHostingController(rootView: ContentView(
//            loading: self.loading,
            name: "Guest",
            useToken: true,
            notificationsEnabled: false))
        
        if let form = formController.view {
            form.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(form)
            form.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = false
            form.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            form.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            
            self.addChild(formController)
        }
        
        
        
        
        
//        // Create form instace
//        let form = FormDescriptor()
//        form.title = "Azure Communication Services"
//
//        // Define first section
//        let section1 = FormSectionDescriptor(headerTitle: "Teams Call Settings", footerTitle: nil)
//
//        var row = FormRowDescriptor(tag: Tags.name, type: .text, title: "Display Name")
//        section1.rows.append(row)
//
//        row = FormRowDescriptor(tag: Tags.link, type: .url, title: "Meating Link")
//        section1.rows.append(row)
//
//        row = FormRowDescriptor(tag: Tags.link, type: .multilineText, title: "ACS Token")
//        section1.rows.append(row)
//
//        row = FormRowDescriptor(tag: Tags.link, type: .text, title: "Token Expiry")
//        row.configuration = RowConfiguration(Binding)
////        row.isUserInteractionEnabled = false
//
//        section1.rows.append(row)
//
//
////        row = FormRowDescriptor(tag: Tags.token, type: .multilineText, title: "ACS Token", Binding(get: {car.isReadyForSale}, set: { car.isReadyForSale = $0 }))
////        section1.rows.append(row)
//
//
//        // Define second section
//        let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
//
//        row = FormRowDescriptor(tag: Tags.button, type: .button, title: "Start Experience")
//        section2.rows.append(row)
//
//        form.sections = [section1, section2]
//
//        self.form = form
    }
}

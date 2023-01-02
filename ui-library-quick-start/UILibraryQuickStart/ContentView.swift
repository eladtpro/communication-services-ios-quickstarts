import SwiftUI
import AzureCommunicationCalling
import AzureCommunicationUICalling

struct ContentView: View {
    let ACSTokenFunctionUrl: String = "https://acs-services.azurewebsites.net/api/get-acs-token"
    let ACSTokenFunctionCode: String = "jvidI4UrhZw7owoYIbXSBha2f9gqr6vlbWHYqnQXyLNEAzFuiRVoLg=="

//    @Binding var loading: Bool
    //    @State var loading = false

    @State var name: String = ""
    @State var link: String = ""
    @State var token: String = ""
    @State var expiry: String = ""
    @State var showConfiguration: Bool = false
    @State var notificationsEnabled: Bool = false
    @State private var previewIndex = 0
    
    var callComposite: CallComposite = CallComposite(withOptions: CallCompositeOptions())
    var previewOptions = ["Always", "When Unlocked", "Never"]
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)

    
    var urlComponents: URLComponents? {
        var urlComponents = URLComponents(string: ACSTokenFunctionUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "code", value: ACSTokenFunctionCode)
        ]

        return urlComponents
    }
    
    private func fetchToken() -> Void
    {
        if let urlComponents = urlComponents, let url = urlComponents.url?.absoluteURL {
            sendRequest(url) { (result, error) in
                DispatchQueue.main.async {
                    if(result != nil){
//                        self.loading = false;
                        token = (result!["token"] as! String)
                        expiry = (result!["expiresOn"] as! String)
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

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("CALL SETTINGS")) {
                    TextField("Display Name", text: $name)
                    TextField("Meating Link", text: $link)
                    Toggle("Show Configuration", isOn: $showConfiguration)
                        .onAppear{
                            fetchToken();
                        }
//                        .onChange(of: showConfiguration){value in
//                            if(value == true){
//                                print("fetching token")
////                                SwiftSpinner.show("Loading") // Act. indicator found on github
//                                fetchToken();
//                            }
//                        }
                }
                
                if showConfiguration {
                    Section(header: Text("CONFIGURATION")) {
                        TextField("ACS Token", text: $token)
                        TextField("Token Expiry", text: $expiry)
                        Button(action: {
                            print("fetching token")
//                                SwiftSpinner.show("Loading") // Act. indicator found on github
                            fetchToken();
                        }, label: {Text("Refresh Token")})
                        Picker(selection: $previewIndex, label: Text("Show Previews")) {
                            ForEach(0 ..< previewOptions.count, id: \.self) {
                                Text(self.previewOptions[$0])
                            }
                        }
                    }
                }
                
                
//                Section(header: Text("ABOUT")) {
//                    HStack {
//                        Text("Version")
//                        Spacer()
//                        Text("2.2.1")
//                    }
//                }
                
                
                Section(header: Text("")) {
                    Button(action: {
//                        let callCompositeOptions = CallCompositeOptions()

//                        callComposite = CallComposite(withOptions: callCompositeOptions)
                        let communicationTokenCredential = try! CommunicationTokenCredential(token: String(describing: token))

                        let remoteOptions = RemoteOptions(
                            for:
                //              .groupCall(groupId: UUID(uuidString: "<GROUP_CALL_ID>")!),
                                .teamsMeeting(teamsLink: String(describing: link)),
                            credential: communicationTokenCredential,
                            displayName: String(describing: name))

                        callComposite.launch(remoteOptions: remoteOptions)
                    }, label: {Text("Start Experience")})
                }
                
                
//                Section {
//                    Button(action: {
//                        print("Perform an action here...")
//                    }) {
//                        Text("Reset All Settings")
//                    }
//                }
            }
            .navigationBarTitle("ACS Settings")
        }
    }
}

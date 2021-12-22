//
//  WelcomeViewController.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import UIKit
import AppAuth

class WelcomeViewController: UIViewController, OIDAuthStateChangeDelegate {
    func didChange(_ state: OIDAuthState) {
        self.stateChanged()
    }
    

    @IBOutlet weak var bttOAuth: UIButton!
    
    private var authState: OIDAuthState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bttOAuth.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    

    @objc func onClick() {
        buildRequest()
    }
    
    func stateChanged() {
            //self.saveState()
            //self.updateUI()
        }
    
    func setAuthState(_ authState: OIDAuthState?) {
            if (self.authState == authState) {
                return;
            }
            self.authState = authState;
            self.authState?.stateChangeDelegate = self;
            self.stateChanged()
        }
    
    func buildRequest(){
        let authorizationEndpoint = URL(string: "https://oauth2.omnicasa.com/")!
        let tokenEndpoint = URL(string: "https://auth2.omnicasa.com/oauth2/token")!
        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint,
                                                    tokenEndpoint: tokenEndpoint)
        let clientID = "mobile-consumer"
        let clientSecret = "Fg5uofqWhNOG2P1T7JC0uZlspsiviEeJ"
        let scopes = ["openid", "offline", "profile", "email"]
        let redirectURI =  URL(string:  "omnicasa://auth/oauth2/callback")
        
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: scopes,
                                              redirectURL: redirectURI!,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        appDelegate.currentAuthorizationFlow =
            OIDAuthState.authState(byPresenting: request, presenting: self) { authState, error in
          if let authState = authState {
            self.setAuthState(authState)
            print("Got authorization tokens. Access token: " +
                  "\(authState.lastTokenResponse?.accessToken ?? "nil")")
          } else {
            print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
            self.setAuthState(nil)
          }
        }
    }
}

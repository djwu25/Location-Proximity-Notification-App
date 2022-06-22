//
//  LoginViewModel.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/21/22.
//
import SwiftUI
import Firebase
import LocalAuthentication

class LoginViewModel:ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var displayName = ""
    
    // Alerts
    @Published var alert:Bool = false
    @Published var alertMessage = ""
    
    // User Data
    @AppStorage("stored_Email") var storedEmail = ""
    @AppStorage("stored_Password") var storedPassword = ""
    @AppStorage("status") var logged = false
    
    @Published var storeInfo = false
    // Get BiometricType
    func getBioMetricStatus()->Bool {
        let scanner = LAContext()
        if email == storedEmail && email != "" && scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
            return true
        }
        return false
    }
    
    // Authenticate User
    func authenticateUser() {
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Unlock \(email)") { (status, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.password = self.storedPassword
                self.verifyUser()
            }
        }
    }
    
    // Verifying User
    func verifyUser() {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if let error = err {
                self.alert.toggle()
                self.alertMessage = error.localizedDescription
                print("Email and Password Failed")
                return
            }
            // Success
            if self.storedEmail != self.email || self.storedPassword != self.password {
                self.storeInfo = true
                return
            }
            
            // Go to Home
            withAnimation{self.logged = true}
            print("Successfully Logged in with Biometrics")
        }
        
        
    }
}

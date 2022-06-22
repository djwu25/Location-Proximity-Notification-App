//
//  SignUpView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/21/22.
//

import SwiftUI
import Firebase
import LocalAuthentication

struct PrimaryTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .background(Color.gray)
            .cornerRadius(5.0)
            .padding(.all, 5)
    }
}

struct LoginView: View {
    @StateObject var loginVM = LoginViewModel()
    @State var signUp:Bool = false
    
    @AppStorage("stored_Email") var storedEmail = ""
    @AppStorage("stored_Password") var storedPassword = ""
    @AppStorage("status") var logged = false
    
    var body: some View {
        VStack {
            Spacer()
            ProximityTitle()
            HStack {
                Image(systemName: "envelope")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 35)
                TextField("Email", text: $loginVM.email)
                    .textFieldStyle(PrimaryTextFieldStyle())
            }
            HStack {
                Image(systemName: "lock")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 35)
                SecureField("Password", text: $loginVM.password)
                    .textFieldStyle(PrimaryTextFieldStyle())
            }
            HStack {
                Button {
                    loginVM.verifyUser()
                } label: {
                    Text("Login")
                        .padding()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.green))
                        .foregroundColor(Color.white)
                }
                .opacity(loginVM.email != "" && loginVM.password != "" ? 1 : 0.5)
                .disabled(loginVM.email == "" && loginVM.password == "" ? true : false)
                .alert(isPresented: $loginVM.alert, content: {
                    Alert(title: Text("Login Error"), message: Text(loginVM.alertMessage), dismissButton: .destructive(Text("OK")))
                })
                
                if loginVM.getBioMetricStatus() {
                    Button(action: loginVM.authenticateUser, label: {
                        Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                    })
                }
            }
            .padding()
            
            Button("New User? Register an Account Here", action: toSignUp)
                .padding()
                .alert(isPresented: $loginVM.storeInfo, content: {
                    Alert(title: Text("Message"), message: Text("Store Information for Future Login Using Touch/Face ID?"), primaryButton: .default(Text("Accept"), action: {
                        // Store Info with Biometric
                        storedEmail = loginVM.email
                        storedPassword = loginVM.password
                        
                        withAnimation{self.logged = true}
                    }), secondaryButton: .cancel({
                        // Redirecting to Home
                        withAnimation{self.logged = true}
                    }))
                })
            Button(action: {}, label: {
                Text("Forgot Password?")
            })
            .padding()
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $signUp) {
            SignUpView()
        }
    }
    
    func toSignUp() {
        signUp = true
    }
}

struct ProximityTitle: View {
    var body: some View {
        Text("Proximity App")
            .font(.system(size: 54, weight:.semibold))
            .foregroundColor(Color.green)
    }
}

struct LoginButtonContent: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

//
//  SignUpView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/21/22.
//

import SwiftUI
import Firebase

struct PrimaryTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .background(Color.gray)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct LoginView: View {
    @State var email:String = ""
    @State var password:String = ""
    @State var signUp:Bool = false
    @Binding var signedIn:Bool
    
    var body: some View {
        VStack {
            Spacer()
            ProximityTitle()
            TextField("Email", text: $email)
                .textFieldStyle(PrimaryTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(PrimaryTextFieldStyle())
            Button {
                login()
            } label: {
                Text("Login")
                    .padding()
                    .frame(width: 200, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.green))
                    .foregroundColor(Color.white)
            }
            .padding()
            Button("New User? Register an Account Here", action: toSignUp)
            Spacer()
        }
        .padding()
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    signedIn = true
                }
            }
        }
        .sheet(isPresented: $signUp) {
            SignUpView(signedIn: $signedIn)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("X") {
                            self.signUp = false
                        }
                    }
                }
        }
    }
    
    func toSignUp() {
        signUp = true
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        signedIn = true
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
    @State static var signedIn:Bool = false
    
    static var previews: some View {
        LoginView(signedIn: $signedIn)
    }
}

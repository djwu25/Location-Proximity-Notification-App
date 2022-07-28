//
//  SignUpView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/21/22.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State var name:String = ""
    @State var email:String = ""
    @State var password:String = ""
    @AppStorage("status") var logged = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            SignUpTitle()
            TextField("Name", text: $name)
                .textFieldStyle(PrimaryTextFieldStyle())
            TextField("Email", text: $email)
                .textFieldStyle(PrimaryTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(PrimaryTextFieldStyle())
            Button {
                register()
            } label: {
                Text("Sign Up")
                    .padding()
                    .frame(width: 200, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.green))
                    .foregroundColor(Color.white)
            }
            .padding()
            Button {
                dismiss()
            } label: {
                Text("Close")
                    .padding()
                    .frame(width: 200, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.green))
                    .foregroundColor(Color.white)
            }
            Spacer()
        }
        .padding()
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password ) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                let update = Auth.auth().currentUser?.createProfileChangeRequest()
                update?.displayName = self.name
                update?.commitChanges()
                
                self.logged = true
            }
        }
        
    }
}

struct SignUpTitle: View {
    var body: some View {
        Text("Register An Account")
            .font(.system(size: 32, weight:.semibold))
            .foregroundColor(Color.green)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

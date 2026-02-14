//
//  RegisterView.swift
//  FootyHub
//
//  Created by Hassan Iqbal on 2/7/26.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var localError: String = ""

    var body: some View {
        VStack(spacing: 20) {

            Spacer()

            Image(systemName: "person.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)

            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text("Join the FootyHub community")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.oneTimeCode)
                .autocorrectionDisabled()
                .padding(.horizontal)

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.oneTimeCode)
                .autocorrectionDisabled()
                .padding(.horizontal)

            if !localError.isEmpty {
                Text(localError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }

            if !authManager.errorMessage.isEmpty {
                Text(authManager.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }

            Button(action: {
                signUp()
            }) {
                if authManager.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                } else {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || authManager.isLoading)

            Button(action: {
                dismiss()
            }) {
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Text("Sign In")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }
            }

            Spacer()
        }
    }

    private func signUp() {
        localError = ""

        if password != confirmPassword {
            localError = "Passwords do not match"
            return
        }

        if password.count < 6 {
            localError = "Password must be at least 6 characters"
            return
        }

        authManager.signUp(email: email, password: password)
    }
}

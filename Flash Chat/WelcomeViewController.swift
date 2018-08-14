//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper
import SVProgressHUD




class WelcomeViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        //loginButton.delegate = FBSDKApplicationDelegate.self() as! FBSDKLoginButtonDelegate
        
        //읽기권한 추가
        loginButton.readPermissions = ["public_profile","email"]
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func FacebookLogInPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("error: 로그인 실패 \(error)")
            } else if result?.isCancelled == true {
                //사용자가 취소한경우
                print("사용자 로그인 취소")
            } else {
                print("로그인 성공")
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
                
                SVProgressHUD.dismiss()
                if let AccessToken = FBSDKAccessToken.current()
                {
                    
                self.performSegue(withIdentifier: "goToChat", sender: self)
                }
            }
            
        }
        
        
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        //페이어베이스 Auth에 데이터를 전달
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("파이어베이스 로그인 실패")
            } else {
                print("파이어베이스 로그인 성공")
                // 유저가 있으면 로그인 완료 함수로 넘기기 바로 하단에
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    func completeSignIn(id: String) {
        //키체인 래퍼로 받은 값을 KEY_UID로 설정
        //let keychainResult = KeychainWrapper.setString(id, forKey: UID)
        //로그인이 완료 됬으니 세그이동
        self.performSegue(withIdentifier: "goToChat", sender: self)
    }
    
    }
    


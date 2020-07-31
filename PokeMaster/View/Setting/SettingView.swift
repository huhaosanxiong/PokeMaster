//
//  SettingView.swift
//  PokeMaster
//
//  Created by huhsx on 2020/7/31.
//  Copyright © 2020 huhsx. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    
    @ObservedObject var setting = Settings()
    
    var body: some View {
        Form {
            accountSection
            optionView
            actionView
        }
    }
    
    var accountSection: some View {
        
        Section(header: Text("账户")) {
            
            Picker(selection: $setting.accountBehavior, label: Text("")) {
                
                ForEach(Settings.AccountBehavior.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            TextField("电子邮箱", text: $setting.email)
            SecureField("密码", text: $setting.password)
            
            if setting.accountBehavior == .register {
                SecureField("确认密码", text: $setting.verifyPassword)
            }
            
            Button(setting.accountBehavior.text) {
                print("登录/注册")
            }
        }
    }
    
    var optionView: some View {
        
        Section(header: Text("选项")) {
            Toggle(isOn: $setting.showEnglishName) {
                Text("显示英文名")
            }
            Picker(selection: $setting.sorting, label: Text("排序方式")) {
                ForEach(Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle(isOn: $setting.showFavoriteOnly) {
                Text("只显示收藏")
            }
        }
    }
    
    var actionView: some View {
        
        Section() {
            Button(action: {
                print("清空缓存")
            }) {
                Text("清空缓存")
                    .foregroundColor(.red)
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

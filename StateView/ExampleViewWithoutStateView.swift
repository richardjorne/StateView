//
//  ExampleViewWithoutStateView.swift
//  StateView
//
//  Created by mito on 2024/5/7.
//

import SwiftUI

struct ExampleViewWithoutStateView: View {
    
    // You'll need to manage the shown state on your own. In most cases, you just want to pay attention to the action you need to do when the user triggers the toggle, so managing this variable is useless and can increase complexity of your code.
    @State private var nextState: Bool = false
    
    // Also, when syncing the shown state with the actual state, you don't want to trigger the function inside `onChange` or `valueChanged`. Therefore, an extra variable that determines whether you should take action is needed. In most cases you still don't need to care about this, and this variable again increases the complexity of your code.
    @State private var noAction: Bool = false
    
    // The actual state
    @State private var developerModeOn: Bool = false
    @State private var presentWarning: Bool = false
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "person.crop.circle.badge")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)
                            .foregroundColor(.orange)
                        Text("Richard")
                            .font(.system(size: 20, weight: .medium))
                    }
                    
                }
                
                Section (content: {
                    HStack {
                        Text("Developer Mode")
                        Spacer()
                        if nextState != developerModeOn {
                            if #available(iOS 14.0, macOS 11.0, *) {
                                ProgressView()
                            }
                        }
                        Toggle(isOn: $nextState, label: {
                        })
                        .disabled(nextState != developerModeOn)
                    }
                    .valueChanged(value: nextState, onChange: { _ in
                        if noAction {
                            
                        } else {
                            presentWarning = true
                        }
                    })
                    .sheet(isPresented: $presentWarning, onDismiss: {
                        
                        // You need to manually sync the state. If you don't use `Timer`, actions in `onChange` may still be triggered. Therefore you need to turn `noAction` off a bit later.
                        noAction = true
                        nextState = developerModeOn
                        Timer.scheduledTimer(withTimeInterval: 0.0001, repeats: false) { _ in
                            noAction = false
                        }
                    }, content: {
                        SettingsWarningView(stateToBeSet: nextState, realState: $developerModeOn, isPresented: $presentWarning)
                    })
                }, footer: {
                    Text("Developer mode gives you the privilege to change ways of processing fundamental data. \nDon't enable this unless you are clear about what you are doing.")
                })
                
                Section (content: {
                    Text("Actual State: \(developerModeOn)")
                }, header: {
                    Text("For Developers")
                })
            }
            .navigationBarTitle(Text("Settings"))
        }
        
    }
}

#Preview {
    ExampleViewWithoutStateView()
}

//
//  StateViewExampleView.swift
//  StateView
//
//  Created by Richard Jorne on 2024/5/6.
//

import SwiftUI

struct StateViewExampleView: View {
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
                    
                    StateView(actualState: $developerModeOn) { shownState, actualState, syncPresent in
                        HStack {
                            Text("Developer Mode")
                            Spacer()
                            if shownState.wrappedValue != actualState.wrappedValue {
                                if #available(iOS 14.0, macOS 11.0, *) {
                                    ProgressView()
                                }
                            }
                            Toggle(isOn: shownState, label: {
                            })
                            .disabled(shownState.wrappedValue != actualState.wrappedValue)
                        }
                        .sheet(isPresented: $presentWarning, onDismiss: {
                            syncPresent()
                        }, content: {
                            SettingsWarningView(stateToBeSet: shownState.wrappedValue, realState: $developerModeOn, isPresented: $presentWarning)
                        })
                    } setFunction: {_ in
                        presentWarning = true
                    } unsetFunction: {_ in 
                        presentWarning = true
                    }
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

struct SettingsWarningView: View {
    var stateToBeSet: Bool
    @Binding var realState: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 20) {
                    if stateToBeSet {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                            .foregroundColor(.red.opacity(0.8))
                        Text("Developer Mode is Dangerous.")
                            .font(.system(size: 30, weight: .bold))
                        Text("Developer mode gives you the privilege to change ways of processing fundamental data. \n\nIt's easy to mess things up and corrupt your precious data. \n\nDon't enable this unless you are clear about what you are doing.")
                        
                    } else {
                        ZStack {
                            Image(systemName: "hammer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60, alignment: .center)
                            Image(systemName: "slash.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100, alignment: .center)
                                .rotationEffect(.degrees(90))
                                .foregroundColor(.red.opacity(0.8))
                        }
                        Text("You're going to turn off developer mode.")
                            .font(.system(size: 30, weight: .bold))
                        Text("You will lose the privilege to change ways of processing fundamental data.")
                    }
                }
                .padding(.horizontal,20)
                .padding(.vertical, 160)
                .multilineTextAlignment(.center)
            }
            .padding(.bottom,120)
            VStack(spacing: 10) {
                Button(action: {
                    realState = stateToBeSet
                    isPresented = false
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 300, height: 45, alignment: .center)
                            .opacity(0.8)
                        Text(stateToBeSet ? "Turn on" : "Turn off")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                })
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Cancel")
                })
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
    }
}

#Preview {
    StateViewExampleView()
    
}

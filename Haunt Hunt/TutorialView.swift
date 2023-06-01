//
//  TutorialView.swift
//  Haunt Hunt
//
//  Created by Luca on 12/05/23.
//

import SwiftUI

struct TutorialView: View {
    
    @State private var returnToggle = true
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
            
            VStack {
                
                if !returnToggle{
                    PreviousView(entityToggle: false, investigatorToggle: false)
                        .transition(.opacity)
                }
                else{
                    
                    HStack {
                        Button {
                            withAnimation{
                                returnToggle.toggle()
                            }
                            }
                        label:{
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundColor(.purple)
                                .frame(width: 12, height: 21)
                                .padding(.top, 50)
                                .padding(.leading)
                        }
                        Spacer()
                    }
                    Image("howtoplay")
                        .resizable()
                        .frame(width: 230, height: 40)
                        .padding(.top, 30)
                    ScrollView {
                        VStack{
                           
                            
                            Text("There are two classes:")
                                .foregroundColor(.white)
                                .font(Font.custom("GhoulishFrightAOE", size: 30))
                                .offset(y: 30)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            HStack{
                                Text("ENTITY")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 25))
                                    .padding()
                                Text("INVESTIGATOR")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 25))
                                    .padding()
                            }
                            
                            Text("ENTITY:")
                                .foregroundColor(.white)
                                .font(Font.custom("GhoulishFrightAOE", size: 30))
                                .padding(.horizontal)
                                .padding(.top)
                            
                            Text("The Entity is a paranormal creature.\n There may only be one entity per game")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .font(Font.custom("GhoulishFrightAOE", size: 25))
                                .padding(.horizontal)
                            
                            Text("INVESTIGATOR:")
                                .foregroundColor(.white)
                                .font(Font.custom("GhoulishFrightAOE", size: 30))
                                .padding(.horizontal)
                                .padding(.top)
                            
                            Text("The Investigators are paranormal researchers.\n There can be as many investigators as deemed appropriate by the players")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .font(Font.custom("GhoulishFrightAOE", size: 25))
                                .padding(.horizontal)
                            
                            Text("There are three stages:")
                                .foregroundColor(.white)
                                .font(Font.custom("GhoulishFrightAOE", size: 30))
                                .offset(y: 30)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            HStack{
                                Text("PREPARATION")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 25))
                                    .padding()
                                Text("INVESTIGATION")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 25))
                                    .padding()
                                Text("HUNT")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 25))
                                    .padding()
                            }
                            
                            
                            VStack{
                                Text("PREPARATION:")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 30))
                                    .padding(.horizontal)
                                    .padding(.top)
                            
                                Text("To start the game, all players must click on CLICK TO PLAY at the same time. This will start everyone's timer in synchrony.\nIn the PREPARATION stage, the entity is given 2 minutes to hide while the investigators must wait in the starting location")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 25))
                                    .padding(.horizontal)
                                
                                Text("INVESTIGATION:")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 30))
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                Text("After the preparation stage, the countdown will automatically switch to the INVESTIGATION phase.\nIn this stage, the investigators must find the entity to win the game in under 5 minutes. If the entity remains unfound at the end of the investigation countdown, ")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 25))
                                    .padding(.horizontal)
                                
                                Text("HUNT:")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 30))
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                Text("If the entity remains unfound at the end of the investigation countdown, the game now enters the HUNT stage.\nThe entity must now find all the investigators to win the game. If it gives up on finding them all, only the remaining investigators win the game")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 25))
                                    .padding(.horizontal)
                            }
                        }.padding(.bottom, 50)
                    }
                }
            }
        }
    }
}


struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}

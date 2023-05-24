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
                    PreviousView()
                }
                else{
                    
                    HStack {
                        Button {
                                returnToggle.toggle()
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
                            
                            Text("The entity is a paranormal creature.\n In the first phase, PREPARATION,\n it is given 2 minutes to hide from the Investigators.\n After that, it must remain hidden and growing its supernatural powers until the second phase, INVESTIGATION,\n is over. If it fails to do so, the Investigators win.\nIn the next phase, HUNT, ")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .font(Font.custom("GhoulishFrightAOE", size: 25))
                                .padding(.horizontal)
                            
                            Spacer()
                        }
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

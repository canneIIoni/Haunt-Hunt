//
//  Buttons.swift
//  Haunt Hunt
//
//  Created by Luca on 19/05/23.
//

import SwiftUI

struct Buttons: View {
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        
        
        
        
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 350, height: 50)
                        .foregroundColor(Color("Purple"))
                    Image("howtoplay")
                }
            
            
        }
            .frame(width: 350, height: 50)
            .position(x:screenWidth/2,y:screenHeight/2)
            
            
        
           
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Buttons()
    }
}


    

        
        
    


//
//  ContentView.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/17.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        Text("Hello World")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

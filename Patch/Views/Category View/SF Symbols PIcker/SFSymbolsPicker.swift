//
//  SFSymbolsPicker.swift
//
//
//  Created by Alessio Rubicini on 05/01/21.
//

import SwiftUI
import Foundation

public struct SFSymbolsPicker: View {
    
    // MARK: - View properties
    @EnvironmentObject var colors: ColorContent
    
    @Binding public var icon: String
    
    let axis: Axis.Set
    let category: SFCategory
    let haptic: Bool
    
    /// Show a picker to select SF Symbols
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the sheet that you create in the modifier's
    ///   - icon: A binding to a String value that determines which icon has been selected
    ///   - category: Custom enum Category that determines which type of icons should be displayed
    ///   - axis: ScrollView axis (vertical by default)
    ///   - haptic: If true a small haptic feedback is generated when an icon is selected (true by default)
    public init(icon: Binding<String>, category: SFCategory, axis: Axis.Set = .horizontal, haptic: Bool = true) {
        self._icon = icon
        self.category = category
        self.axis = axis
        self.haptic = haptic
    }
    
    
    // MARK: - View body
    
    public var body: some View {
        
        ScrollView(self.axis) {
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 15) {
                
                ForEach(symbols[category.rawValue]!, id: \.hash) { icon in
                    
                    Image(systemName: icon)
                        .font(.system(size: 25))
                        .foregroundColor(self.icon == icon ? colors.InputSelect : colors.InputText)
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            // Assign binding value
                            withAnimation {
                                self.icon = icon
                            }
                            
                            // Generate haptic
                            if self.haptic {
                                self.impactFeedback(style: .medium)
                            }
                        }
                    
                }.padding(.top, 5)
            }
        }
        
        
    }
    
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}




struct SFSymbolsPicker_Previews: PreviewProvider {
    static var previews: some View {
        SFSymbolsPicker(icon: .constant(""), category: .food, axis: .horizontal)
    }
}

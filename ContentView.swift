//
//  ContentView.swift
//  Decimal-Binary-Hex Converter
//
//  Created by Frank Glaser on 3/11/23.
//

import SwiftUI

struct ContentView: View {
    
    // Variable declarations
    @State var decimalString: String = ""
    @State var binaryString: String = ""
    @State var hexString: String = ""
    @State var isValid: Bool = true
    @State var totalDecimals: Int = 0
    @State var totalNumbers: Int = 0
    @State var temp: Int = 0
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                //Decimal section
                VStack(alignment: .leading) {
                    Text("Decimal value:")
                        .font(.system(size:25))
                    TextField("Type a decimal value.", text: $decimalString)
                        .padding(.leading,20)
                        .background(Color.black.opacity(0.7))
                        .font(.system(size:20))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                        //Reset variables and evaluate user input. If valid, perform conversions.
                        .onSubmit {
                            isValid = true
                            totalDecimals = 0
                            temp = 0
                            totalNumbers = 0
                            
                            for i in decimalString {
                                if (i.isNumber == false) {
                                    if (i == ".") {
                                        if (totalNumbers > 0) {
                                            totalDecimals += 1
                                        }
                                        else {
                                            isValid = false
                                        }
                                    }
                                    else if (i == "-") {
                                        if (temp > 0) {
                                            isValid = false
                                        }
                                    }
                                    else {
                                        isValid = false
                                    }
                                }
                                else {
                                    totalNumbers += 1
                                }
                                temp += 1
                            }
                            
                            if (totalDecimals > 1) {
                                isValid = false
                            }
                                
                            if (isValid) {
                                if (decimalString.count > 0) {
                                    binaryString = decimalToBinary(dString: decimalString)
                                    hexString = decimalToHexadecimal(dString: decimalString)
                                }
                                else {
                                    binaryString = ""
                                    hexString = ""
                                }
                            }
                            else {
                                binaryString = "ERROR"
                                hexString = "ERROR"
                            }
                        }
                }
                .padding(20)
                
                VStack(alignment: .leading) {
                    Text("Binary value:")
                        .font(.system(size:25))
                    TextField("Type a binary value.", text: $binaryString).disabled(true)
                        .padding(.leading,20)
                        .font(.system(size:20))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.black.opacity(0.7))
                }
                .padding(20)
                
                VStack(alignment: .leading) {
                    Text("Hexadecimal value:")
                        .font(.system(size:25))
                    TextField("Type a hex value.", text: $hexString).disabled(true)
                        .padding(.leading,20)
                        .font(.system(size:20))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.black.opacity(0.7))
                }
                .padding(20)
            }
            .padding()
        }
        .background(Image("BinaryBackground")     .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func decimalToBinary(dString: String) -> String {
    
    // Function variables
    var isNegative: Bool = false
    var bString: String = ""
    var dFloat: Float = 0.0
    var dInt: Int = 0
    var fractionMult: Float = 0.5
    var decimalPlaces: Int = 0
    var decimalFraction: Float = 0.0
    var tempString: String = ""
    var tempInt: Int = 0
    var tempFloat: Float = 0.0
    
    // Determine if value is a negative and convert to absolute value.
    dFloat = Float(dString) ?? 0
    
    if (dFloat < 0) {
        isNegative = true
        dFloat *= -1
    }
    
    // Separate integer from fraction.
    decimalFraction = dFloat.truncatingRemainder(dividingBy:1)
    dInt = Int(dFloat)
    
    // Fraction conversion
    tempFloat = decimalFraction
    while (decimalFraction != 0) {
        if (decimalFraction / fractionMult >= 1) {
            bString = bString + "1"
            decimalFraction -= fractionMult
        }
        else {
            bString = bString + "0"
        }
        fractionMult = fractionMult / 2
    }
    bString = "." + bString
    decimalFraction = tempFloat
    
    // Integer conversion
    dFloat = Float(dInt)
    while (dFloat != 0) {
        if (dFloat.truncatingRemainder(dividingBy:2) == 1) {
            bString = "1" + bString
        }
        else {
            bString = "0" + bString
        }
        dFloat = dFloat / 2
        dInt = Int(dFloat)
        dFloat = Float(dInt)
    }
    
    // 2's compliment conversion
    if (isNegative) {
        
        // Flip all the bits
        for i in bString {
            if (i == "0") {
                tempString = tempString + "1"
            }
            else if (i == "1") {
                tempString = tempString + "0"
            }
            else if (i == ".") {
                decimalPlaces = bString.count - tempInt - 1
            }
            tempInt += 1
        }
        tempString = "1" + tempString
        bString = tempString
        
        // Add 1 to the right-most bit.
        bString.removeLast()
        bString = bString + "1"
        
        // Reinsert decimal
        tempInt = bString.count - decimalPlaces
        tempString = String(bString.suffix(decimalPlaces))
        tempString = "." + tempString
        tempString = bString.prefix(tempInt) + tempString
        bString = tempString
    }
    else {
        bString = "0" + bString
    }
    
    if (decimalFraction == 0) {
        bString.removeLast()
    }
    
    return bString
}

func decimalToHexadecimal(dString: String) -> String {
    
    // Variable declarations
    var hString: String = ""
    var isNegative: Bool = false
    var decimalPlaces: Int = 0
    var dDouble: Double = 0.0
    var decimalFraction: Double = 0.0
    var dInt: Int = 0
    var tempDouble: Double = 0.0
    var fractionMult: Float = 16
    let hexCharacters =  ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
    var tempInt: Int = 0
    var tempInt2: Int = 0
    var tempInt3: Int = 0
    var tempString: String = ""
    
    // Determine if value is a negative and convert to absolute value.
    let tempDecimal = Decimal(string:dString)!
    dDouble = (tempDecimal as NSDecimalNumber).doubleValue
    
    if (dDouble < 0) {
        isNegative = true
        dDouble *= -1
    }
    
    // Separate integer from fraction.
    decimalFraction = dDouble.truncatingRemainder(dividingBy:1)
    dInt = Int(dDouble)
    tempInt3 = dInt
    
    // Fraction conversion
    tempDouble = decimalFraction
    while (decimalFraction != 0) {
        tempInt = Int(decimalFraction * 16)
        decimalFraction = decimalFraction * 16.0 - Double(tempInt)
        hString = hString + hexCharacters[tempInt]
    }
    hString = "." + hString
    decimalFraction = tempDouble
    
    // Integer conversion
    while (dInt != 0) {
        hString = hexCharacters[dInt % 16] + hString
        dInt = Int(dInt / 16)
    }
    
    // 16's compliment conversion
    if (isNegative) {
        
        // Flip all the bits
        tempInt = 0
        for i in hString {
            if (i == ".") {
                decimalPlaces = hString.count - tempInt - 1
                print(decimalPlaces)
            }
            else {
                for j in 0...15 {
                    if (String(i) == hexCharacters[j]) {
                        tempInt2 = j
                    }
                }
                tempString = tempString + hexCharacters[15 - tempInt2]
            }
            tempInt += 1
        }
        hString = tempString
        
        // Add 1 to right-most bit
        for i in 0...15 {
            if (hString.last == Character(hexCharacters[i])) {
                tempInt = i
            }
        }
        tempInt += 1
        hString.removeLast()
        hString = hString + hexCharacters[tempInt]
        
        // Reinsert decimal
        tempInt = hString.count - decimalPlaces
        tempString = String(hString.suffix(decimalPlaces))
        tempString = "." + tempString
        tempString = hString.prefix(tempInt) + tempString
        if (tempInt3 == 0) {
            tempString = "0" + tempString
        }
        hString = "F" + tempString
    }
    else {
        if (tempInt3 == 0) {
            hString = "0" + hString
        }
    }
    
    if (decimalFraction == 0) {
        hString.removeLast()
    }
    
    return hString
}

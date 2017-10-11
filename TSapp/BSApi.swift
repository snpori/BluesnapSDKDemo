//
//  BSApi.swift
//  Aliks Demo
//
//  Created by Shevie Chen on 26/06/2017.
//  Copyright © 2017 Automation Team. All rights reserved.
//

import Foundation
import BluesnapSDK
import Alamofire


public class BSApi {
    
    private static let BLUESNAP_SERVER: String = "https://sandbox.bluesnap.com/"
    private static let WS_PATH : String = "services/2"
    private static let GET_TOKEN:String = "/payment-fields-tokens"
    private static let CC_TRANSACTION: String = "/transactions"
    private static let CREATE_VAULTED_SHOPPER = "/vaulted-shoppers"
    
    
    static func getUrl(operation: String)-> String {
        return BSApi.BLUESNAP_SERVER + BSApi.WS_PATH + operation;
    }
    
    static func fetchToken(username: String, password: String, callback: @escaping (BSToken)->Void ) {
      
        Alamofire.request(getUrl(operation: GET_TOKEN),method:.post)
            .authenticate(user: username, password: password)
            
            .responseString{ response in
                
                
                print("Request: \(response.request)")
                print("Request: \(response.response)")
              
                let location: String = response.response?.allHeaderFields["Location"] as! String
                print("Location: \(location)")
                let arr = location.components(separatedBy: "/")
                let token: String = arr[arr.count-1]
                callback(BSToken(tokenStr: token, serverUrl: BLUESNAP_SERVER))
        
        }
       
        
        
    }
    
    
    private static func onShopperCreated(shopperId: String, status: Int){
        if (status < 0 ){
            
        }
    }
    
    /**
     This function accepts a callback which will be called with a vaultedShopper Id (is successful) or 
     error details if fails.
     */
    public static func createVaultedShopped(username: String,
                                            password: String,
                                            initialData: BSInitialData,
                                            bsToken : BSToken
                                            ) -> Optional<String> {
        
        var shippingInfo: Optional<Dictionary<String, Any>>
        if let shippingDetails = initialData.shippingDetails {
            shippingInfo = Dictionary<String,String>()
            shippingInfo = addIfNotNil(dic: shippingInfo!, key: "firstName", value: shippingDetails.getSplitName()?.firstName)
            shippingInfo = addIfNotNil(dic: shippingInfo!, key: "lastName", value: shippingDetails.getSplitName()?.lastName)
            shippingInfo = addIfNotNil(dic: shippingInfo!, key: "address", value: shippingDetails.address)
            shippingInfo = addIfNotNil(dic: shippingInfo!, key: "city", value: shippingDetails.city)
            shippingInfo = addIfNotNil(dic: shippingInfo!, key: "country", value: shippingDetails.country)
//            shippingInfo = addIfNotNil(dic: shippingInfo!, key: "email", value: shippingDetails.email)
            shippingInfo = addIfNotNil(dic: shippingInfo!, key: "state", value: shippingDetails.state)
            shippingInfo = addIfNotNil(dic: shippingInfo!, key: "zip", value: shippingDetails.zip)
        
        }
       
        var request : Dictionary<String,Any> = [
            "firstName" : initialData.billingDetails!.getSplitName()!.firstName,
            "lastName": initialData.billingDetails!.getSplitName()!.lastName,
        ]
        
        request = addIfNotNil(dic: request, key: "zip", value: initialData.billingDetails!.zip)
        request = addIfNotNil(dic: request, key: "city", value: initialData.billingDetails!.city)
        request = addIfNotNil(dic: request, key: "country", value: initialData.billingDetails!.country)
        request = addIfNotNil(dic: request, key: "state", value: initialData.billingDetails!.state)
        request = addIfNotNil(dic: request, key: "email", value: initialData.billingDetails!.email)
        request = addIfNotNil(dic: request, key: "address", value: initialData.billingDetails!.address)
       
        
        if (shippingInfo != nil){
            request["shippingContactInfo"] = shippingInfo
        }
        request["pfToken"] = bsToken.getTokenStr()
        
        
        
        var shopperId: Optional<String> = nil
        
        let semaphore = DispatchSemaphore(value: 1)
        
        print(request)
        
        Alamofire.request(getUrl(operation: CREATE_VAULTED_SHOPPER),
                          method: .post,
                          parameters: request,
                          encoding: JSONEncoding.default)
            .authenticate(user: username, password: password)
            
            
            .response {
                response in
                
                print(response.response?.statusCode ?? 404)
                
                let location: String = response.response?.allHeaderFields["Location"] as! String
                print("Location: \(location)")
                let arr = location.components(separatedBy: "/")
                shopperId = arr[arr.count-1] as String!
              
                
                
                
        }
        defer {
            semaphore.signal()
        }
    
        
        semaphore.wait()
        return shopperId

        
       
    }
    
    
//    public static func doPurchase(user: String, password: String, initialData: BSInitialData, bsToken: BSToken, callback: @escaping (String,Int)->Void){
//        if initialData.getResultPaymentDetails()?.paymentType == BSPaymentType.CreditCard{
//
//
//            doCreditCardTransaction(username: user,
//                                    password: password,
//                                    initialData: initialData,
//                                    bsToken: bsToken,
//                                    callback: callback)
//        }
//        else {
//           doApplePayTransation(username: user, password: password, initialData: initialData, bsToken: bsToken, callback: callback)
//        }
//
//
//    }
//
    public static func doCreditCardTransaction(username: String,
                                               password: String,
                                               initialData: BSInitialData,
                                               bsToken:BSToken,
                                               callback: @escaping (String,Int)->Void)
        {
            
            let vaultedShopperId : Optional<String> = nil
        
//            let vaultedShopperId = createVaultedShopped(username: username,
//                                                        password: password,
//                                                        initialData: initialData,
//                                                        bsToken: bsToken)

              let requestBody = getRequestBody(vaultedShopperId:vaultedShopperId,
                                               initialData: initialData,
                                               bsToken: bsToken)
      
        print("requestBody= \(requestBody)")
        
        Alamofire.request(
            getUrl(operation: CC_TRANSACTION),
            method: .post,
            parameters: requestBody,
            encoding: JSONEncoding.default)
            .authenticate(user: username, password: password)
            
            .responseString{
                response in
                
                let responseData =  String(data : response.data!, encoding: String.Encoding.utf8)
                
                print(response.response ?? "No response")
                callback(responseData ?? "",(response.response?.statusCode)!)
                
                
                
        }
        
    }
    
//    private static func doApplePayTransation(username: String,
//                                             password: String,
//                                             initialData: BSInitialData,
//                                             bsToken:BSToken,
//                                             callback: @escaping (String,Int)->Void){
//
//        let applePayData: BSResultApplePayDetails = initialData.getResultPaymentDetails() as! BSResultApplePayDetails
//
//
//        let amount =  initialData.getAmount() + initialData.getTaxAmount()
//        let currency = initialData.getCurrency()!
//
//
//
//        let requestBody = [
//            "recurringTransaction" : "ECOMMERCE",
//            "softDescriptor" : "AliksSDKApplePay",
//            "cardTransactionType" : "AUTH_CAPTURE",
//            "amount" : "\(amount)",
//            "currency": "\(currency)",
//            "pfToken" : "\(bsToken.getTokenStr()!)"
//
//            ] as [String:Any]
//
//        print("requestBody= \(requestBody)")
//
//        Alamofire.request(
//            getUrl(operation: CC_TRANSACTION),
//            method: .post,
//            parameters: requestBody,
//            encoding: JSONEncoding.default)
//            .authenticate(user: username, password: password)
//
//            .responseString{
//                response in
//
//                let responseData =  String(data : response.data!, encoding: String.Encoding.utf8)
//
//                print(response.response ?? "No response")
//                callback(responseData ?? "",(response.response?.statusCode)!)
//
//
//
//        }
//    }
    
    private static func getRequestBody(vaultedShopperId: Optional<String>, initialData : BSInitialData, bsToken: BSToken) -> Dictionary<String, Any>{
        let name = initialData.billingDetails!.getSplitName()!
        let amount = initialData.priceDetails.amount.doubleValue + initialData.priceDetails.taxAmount.doubleValue
        
        var cardHolderInfo: Dictionary<String,Any> = [
            "firstName": "\(name.firstName)",
            "lastName": "\(name.lastName)",
        ]
        if let billingDetails = initialData.billingDetails {
            cardHolderInfo = addIfNotNil(dic: cardHolderInfo, key: "city", value: billingDetails.city) as! [String : String]
            cardHolderInfo = addIfNotNil(dic: cardHolderInfo, key: "address", value: billingDetails.address) as! [String : String]
            cardHolderInfo = addIfNotNil(dic: cardHolderInfo, key: "email", value: billingDetails.email) as! [String : String]
            cardHolderInfo = addIfNotNil(dic: cardHolderInfo, key: "country", value: billingDetails.country) as! [String : String]
            cardHolderInfo = addIfNotNil(dic: cardHolderInfo, key: "state", value: billingDetails.state) as! [String : String]
            cardHolderInfo = addIfNotNil(dic: cardHolderInfo, key: "zip", value: billingDetails.zip) as! [String : String]
           
        }
    
        
        
        var result = [
            "amount": "\(amount)",
            "recurringTransaction": "ECOMMERCE",
            "softDescriptor": "AliksSDKTester",
            "cardHolderInfo": cardHolderInfo,
            "currency": "\(initialData.priceDetails.currency!)",
            "cardTransactionType": "AUTH_CAPTURE",
            "pfToken": "\(bsToken.getTokenStr()!)"
            ] as [String : Any]
        
        
        if (vaultedShopperId != nil) {
            result["vaulted-shopper-id"] = vaultedShopperId as! String
        }
        
        return result;
    }
   
    private static func addIfNotNil(dic: Dictionary<String,Any>, key: String, value: Optional<Any>) -> Dictionary<String,Any>{
        
        if (value == nil){
            return dic
        }
        
        var result =  dic
       
        result[key] = value as! String
        return result
        
    }
    
}

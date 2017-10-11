//
//  ViewController.swift
//  Aliks Demo
//
//  Created by Shevie Chen on 25/06/2017.
//  Copyright © 2017 Automation Team. All rights reserved.
//

import UIKit
import BluesnapSDK

//import BluesnapSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtTax: UITextField!
//    @IBOutlet weak var lblResult: UILabel!
    
    @IBOutlet weak var lblResult: UITextView!
    
    
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnShopNow: UIButton!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var shippingSwitch: UISwitch!
    @IBOutlet weak var billingSwitch: UISwitch!
    
    @IBOutlet weak var ccDetailsField: BSCcInputLine!
    @IBOutlet weak var lblCCDetails: UILabel!
    @IBOutlet weak var btnCustomShop: UIButton!
    @IBOutlet weak var btnTestCustomShop: UIButton!
    
    @IBOutlet weak var showCustomSwitch: UISwitch!

    
    private var bsToken: BSToken?
    private var initialData = BSInitialData()
    private let DEFAULT_CURRENCY = "USD"
   // private let username: String = "Tinapapi101"
    private let username: String = "iosAppDemo"
    private let password: String = "Plimus123"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnShopNow.isEnabled = false
        ccDetailsField.isEnabled = false
        lblResult.isHidden = true;
        
        showCustomSwitch.setOn(false, animated: false)
        toggleCustomControl(on: false)
        
        fetchToken()
        registerTokenExpiration()
        //btnCurrency.setTitle(DEFAULT_CURRENCY,for: UIControlState.normal)
        setCurrencyButton(title: DEFAULT_CURRENCY)
        NSLog("isShipping: \(shippingSwitch.isOn)")
        NSLog("isBilling: \(billingSwitch.isOn)")

        
    }

    @IBAction func customControlSwitch(_ sender: UISwitch) {
        
        toggleCustomControl(on: sender.isOn)
    }
    
    
    func toggleCustomControl(on: Bool){
        btnShopNow.isHidden = on
        
        self.lblCCDetails.isHidden = !on
        self.ccDetailsField.isHidden = !on
      //  self.btnCustomShop.isHidden = !on
        self.btnTestCustomShop.isHidden = !on
        
        if (on) {
            self.ccDetailsField.becomeFirstResponder();
            ccDetailsField.setValue("4111 1111 1111 1111")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func changeCurrency(_ sender: UIButton) {
        let currentCurrency: String  = lblCurrency.text!
        changeCurrency(currentCurrency:currentCurrency)
    }
    
    func fetchToken(){

        BSApi.fetchToken(
            username: username,
            password: password,
            callback: onTokenCreated)
        
      

    }
    
    func changeCurrency(currentCurrency: String) {
        //let currentCurrency: String = btnCurrency.title(for: UIControlState.normal)!
    
//        BlueSnapSDK.showCurrencyList(
//            inNavigationController: self.navigationController,
//            animated: true,
//            selectedCurrencyCode: currentCurrency,
//            updateFunc: onCurrencyChanged)
        
    }
    
    
    func onCurrencyChanged(before:BSCurrency?, after:BSCurrency?) {
        NSLog("Before: \(before?.getCode())")
        NSLog("After: \(after?.getCode())")
        setCurrencyButton(title: (after?.getCode())!)
    }
    
    func setCurrencyButton(title: String){
       lblCurrency.text = title
      
    }
    
    @IBAction func checkOut(_ sender: UIButton) {
        NSLog("Shipping: \(shippingSwitch.isOn)")
        NSLog("Billing: \(billingSwitch.isOn)")
        
        hideLabel()
        fillPaymentRequest()
        
        
        BlueSnapSDK.showCheckoutScreen(
            inNavigationController: self.navigationController,
            animated: true,
            initialData: initialData,
            purchaseFunc: completePurchase)
    }
    
    
    private func completePurchase(paymentRequest: BSBasePaymentRequest!) {
        
        NSLog("Callback called: ")
//        printRequestData(request: paymentRequest)
     
      
//        BSApi.doPurchase(user: username,
//                         password : password,
//                         paymentRequest: paymentRequest,
//                         bsToken: bsToken!,
//                         callback: onResponse)
////        let demo = DemoTreansactions()
//        let result : (success:Bool, data: String?) = demo.createCreditCardTransaction(
//            paymentRequest: paymentRequest,
//            bsToken: bsToken!)
//        logResultDetails(result)
//        if (result.success == true) {
//            resultTextView.text = "BLS transaction created Successfully!\n\n\(result.data!)"
//        } else {
//            let errorDesc = result.data ?? ""
//            resultTextView.text = "An error occurred trying to create BLS transaction.\n\n\(errorDesc)"
//        }
    }

    func fillPaymentRequest() {
        
        let amount = (txtAmount.text! as NSString).doubleValue
        let taxAmount = (txtTax.text! as NSString).doubleValue
        let currency: String = (lblCurrency.text)!//(btnCurrency.titleLabel!.text)!

        let country = txtCountry.text!
        
//        bsRequest.getBillingDetails().country = country.lowercased()
        
//        bsRequest.setAmountsAndCurrency(amount: amount, taxAmount: taxAmount, currency: currency)
    }

    func registerTokenExpiration(){
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(onBSTokenExpiration),
//                                               name: Notification.Name.bsTokenExpirationNotification,
//                                               object: nil)
    }
    func onBSTokenExpiration()  {
        NSLog("Token expired")
        fetchToken()
    }
    
    func printRequestData(request: BSInitialData){
//        print("================Request Data: =============")
//        print("Amount: \(request.getAmount())")
//        print("Currency: \(request.getCurrency())")
//        print("Tax: \(request.getTaxAmount())")
//
//        if (request.getResultPaymentDetails()?.paymentType == BSPaymentType.CreditCard){
//            let ccDetails: BSResultCcDetails =  (request.getResultPaymentDetails() as? BSResultCcDetails)!
//            print("===============CC Details============")
//            print("Last 4 digits: \(ccDetails.last4Digits ?? "nil")")
//            print("Isuing country: \(ccDetails.ccIssuingCountry ?? "nil")")
//            print("CC type: \(ccDetails.ccType ?? "nil")")
//
//        }
//        else {
//            print("Apple Pay!")
//        }
//
//
//
//        if let billingDetails = request.getBillingDetails(){
//            print("=============== Billing details ==========")
//            print("Name: \(billingDetails.name)")
//            print("Split Name: \(billingDetails.getSplitName())")
//            print("Address: \(billingDetails.address ?? "nil")")
//            print("City: \(billingDetails.city ?? "nil")")
//            print("Email: \(billingDetails.email ?? "nil")")
//            print("ZipCode: \(billingDetails.zip ?? "nil")")
//            print("Country: \(billingDetails.country ?? "nil")")
//            print("State: \(billingDetails.state ?? "nil")")
//        }
//        else{
//            print("No billing details!")
//        }
//
//
//        if let shippingDetails = request.getShippingDetails(){
//            print("======== Shipping Details =====")
//            print ("Name: \(shippingDetails.name)")
//            print ("Split Name: \(shippingDetails.getSplitName())")
//            print ("Address: \(shippingDetails.address)")
//            print ("City: \(shippingDetails.city)")
//            print ("Country: \(shippingDetails.country)")
//            print ("Email: \(shippingDetails.email)")
//            print ("State: \(shippingDetails.state)")
//            print ("Zip: \(shippingDetails.zip)")
//
//        }
//        else{
//            print ("No shipping details")
//        }
    }
    
    func onTokenCreated(token: BSToken){
        NSLog("Token created: \(token.getTokenStr())")
        bsToken = token
        BlueSnapSDK.setBsToken(bsToken: bsToken)
        BlueSnapSDK.setApplePayMerchantIdentifier(merchantId: "merchant.com.bluesnap.emporium")
        
        ccDetailsField.isEnabled = true
        btnShopNow.isEnabled = true
        lblResult.text = token.getTokenStr()
        lblResult.isHidden = false
        BlueSnapSDK.KountInit(kountMid: nil, customFraudSessionId: nil);

        
    }
    
    func hideLabel(){
        lblResult.text = ""
        lblResult.isHidden = true
    }
    
    func onResponse(response: String, status: Int) -> Void{
        lblResult.text = response
        lblResult.isHidden = false
        
        if (status < 400){
            lblResult.textColor = UIColor.green
        }
        else {
            lblResult.textColor = UIColor.red
        }
        
        view.endEditing(true)
        
        
    }
    
    
    @IBAction func testCustomShop(_ sender: UIButton) {
        let paymentRequest: BSInitialData = BSInitialData()
        let amount  = Double(txtAmount.text!)
        let taxAmount = Double(txtTax.text!)
        let ccNumber = ccDetailsField.getValue()
        let ccCardType = ccDetailsField.getCardType()
        let expDate = ccDetailsField.getExpDateAsMMYYYY()
        let cvv = ccDetailsField.getCvv()
        let billingDetails = paymentRequest.billingDetails!
        
        billingDetails.name = "Billing Name Alik"
        billingDetails.zip = "Billing Zip"
        
        if shippingSwitch.isOn{
            if let shippingDetails  = paymentRequest.shippingDetails {
                shippingDetails.name = "Shipping Alik Test"
                shippingDetails.zip = "shipping 123535"
                shippingDetails.address = "Shipping Medinat HaYehudim 60"
                shippingDetails.city = "Shipping Herzliya"
                shippingDetails.country = "il"
            }
        }
        
        if billingSwitch.isOn {
            billingDetails.address =  "Billing Medinat Ha Yehudim 60"
            billingDetails.city = "Billing Herzliya"
            billingDetails.country = "il"
            billingDetails.email = "billing@email.com"
            
            
        }
        
        //paymentRequest.setAmountsAndCurrency(amount:amount, taxAmount: taxAmount, currency: lblCurrency.text!)
        
        self.initialData = paymentRequest
        
        submitCCDetails(ccNumber: ccNumber!, ccCardType: ccCardType!, expDate: expDate!, cvv: cvv!)
        
    }
    
    
    
  /*
    @IBAction func customShop(_ sender: UIButton) {
        
        let paymentRequest: BSInitialData = BSInitialData()
        let amount  = Double(txtAmount.text!)
        let taxAmount = Double(txtTax.text!)
        let ccNumber = ccDetailsField.getValue()
        let ccCardType = ccDetailsField.getCardType()
        let expDate = ccDetailsField.getExpDateAsMMYYYY()
        let cvv = ccDetailsField.getCvv()
        let billingDetails = paymentRequest.getBillingDetails()!
        
        billingDetails.name = "Billing Name Alik"
        billingDetails.zip = "Billing Zip"
        
        if shippingSwitch.isOn{
            if let shippingDetails  = paymentRequest.getShippingDetails() {
                shippingDetails.name = "Shipping Alik Test"
                shippingDetails.zip = "shipping 123535"
                shippingDetails.address = "Shipping Medinat HaYehudim 60"
                shippingDetails.city = "Shipping Herzliya"
                shippingDetails.country = "il"
            }
        }
        
        if billingSwitch.isOn {
                billingDetails.address =  "Billing Medinat Ha Yehudim 60"
                billingDetails.city = "Billing Herzliya"
                billingDetails.country = "il"
                billingDetails.email = "billing@email.com"
            
           
        }
        
        paymentRequest.setAmountsAndCurrency(amount:amount, taxAmount: taxAmount, currency: lblCurrency.text!)
        
        self.bsRequest = paymentRequest
        
        submitCCDetails(ccNumber: ccNumber!, ccCardType: ccCardType!, expDate: expDate!, cvv: cvv!)
        
        
       // self.navigationController?.show(self, sender: self)
    
        
    }
    
    */
    
    func submitCCDetails(ccNumber : String, ccCardType : String, expDate: String, cvv: String){
        BlueSnapSDK.submitCcDetails(ccNumber: ccNumber, expDate: expDate, cvv: cvv, completion:onCCSumbited )
       
    }
    
    
    
    func onCCSumbited(ccDetails: BSCcDetails? , ccError: BSErrors?) -> Void{
        NSLog(" ================== CC Submitted ================")
        if ((ccDetails) != nil){
            NSLog(ccDetails!.last4Digits ?? "N/A")
            NSLog(ccDetails!.ccIssuingCountry ?? "N/A")
            NSLog(ccDetails!.ccType ?? "N/A")
        }
        
        if ((ccError) != nil) {
            NSLog("Error Occured")
            NSLog(ccError.debugDescription)
            NSLog("Cancelling transaction")
            return
        }
        
        //initialData.setResultPaymentDetails(resultPaymentDetails: ccDetails)
        
       // BSApi.doPurchase(user: username, password: password, paymentRequest: bsRequest, bsToken: bsToken!, callback: onResponse)
        
    }
    
}


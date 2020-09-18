//
//  IntentHandler.swift
//  TLCIntents
//
//  Created by Justin Lycklama on 2020-09-15.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import Intents

import TLCModel

import Realm
import RealmSwift

import UserNotifications

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        if intent is NewItemIntent {
            return TestIntentHandler()
        }
        
        return self
    }
    
    // MARK: - INSendMessageIntentHandling
    
    // Implement resolution methods to provide additional information about your intent (optional).
    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INSendMessageRecipientResolutionResult]) -> Void) {
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INSendMessageRecipientResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INSendMessageRecipientResolutionResult]()
            for recipient in recipients {
                let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INSendMessageRecipientResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INSendMessageRecipientResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    resolutionResults += [INSendMessageRecipientResolutionResult.unsupported()]
                    
                default:
                    break
                    
                }
            }
            completion(resolutionResults)
        }
    }
    
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Handle the completed intent (required).
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
    
    // Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func handle(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        // Initialize with found message's attributes
        response.messages = [INMessage(
            identifier: "identifier",
            content: "I am so excited about SiriKit!",
            dateSent: Date(),
            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
            )]
        completion(response)
    }
    
    // MARK: - INSetMessageAttributeIntentHandling
    
    func handle(intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        // Implement your application logic to set the message attribute here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}


class TestIntentHandler: INExtension, NewItemIntentHandling, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    var hasUpdateLocation = false
    var onDidSaveCoordinate: ((NewItemIntentResponse) -> Void)?

    
    func handle(intent: NewItemIntent, completion: @escaping (NewItemIntentResponse) -> Void) {
//        guard let title = intent.title else {
//            completion(INStringResolutionResult.needsValue())
//            return
//        }
        
        
        DispatchQueue.main.async {
            self.onDidSaveCoordinate = completion
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager?.startUpdatingLocation()
            }
            
        }
        
        print("Testing!! Intent Ran!")
        
//        let response = NewItemIntentResponse.init(code: .success, userActivity: NSUserActivity.init(activityType: "Hello?"))
//        completion()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if hasUpdateLocation {
            return
        }
        
        hasUpdateLocation = true
        
        guard let coordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
            
            
            let response = NewItemIntentResponse.init(code: .failure, userActivity: nil)
            onDidSaveCoordinate?(response)
            
            locationManager = nil
            onDidSaveCoordinate = nil
            
            return
        }
                
        saveCoordinate(coordinate)
    }
    
    func saveCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        print("location: \(coordinate.latitude), \(coordinate.longitude)")

//        guard let realmPath = TLC_Constants.realmPath else {
//
//            let response = NewItemIntentResponse.init(code: .failure, userActivity: nil)
//            onDidSaveCoordinate?(response)
//
//            locationManager = nil
//            onDidSaveCoordinate = nil
//
//            return
//        }

//        let config = RLMRealmConfiguration.default()
//            config.pathOnDisk = realmPath
//
//            RLMRealmConfiguration.setDefault(config)
        
        
        let realm: Realm!
        
        do {
            realm = try Realm(configuration: TLC_Constants.realmConfig)
        }
        catch {
            
            let response = NewItemIntentResponse.init(code: .failure, userActivity: nil)
            onDidSaveCoordinate?(response)
            
            locationManager = nil
            onDidSaveCoordinate = nil
            
            return
        }
        
//        // Query Realm for all dogs less than 2 years old
//        let puppies = realm.objects(Dog.self).filter("age < 2")
//        puppies.count // => 0 because no dogs have been added to the Realm yet

        let unresolvedLocation = UnResolvedLocation()
        
        
        // Persist your data easily
        do {
            try realm.write {
                realm.add(unresolvedLocation)
            }
            
            print("Success Writing Location")
        } catch {

            let response = NewItemIntentResponse.init(code: .failure, userActivity: nil)
            onDidSaveCoordinate?(response)

            locationManager = nil
            onDidSaveCoordinate = nil

            print("Fail Writing Location")
        }

        
        let locations = realm.objects(UnResolvedLocation.self)
        print(locations.count)
        

        let content = UNMutableNotificationContent()
        content.sound = .none
        content.badge = NSNumber(value: locations.count)
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        
        let response = NewItemIntentResponse.init(code: .success, userActivity: nil)
        onDidSaveCoordinate?(response)
        
        locationManager = nil
        onDidSaveCoordinate = nil
    }
}

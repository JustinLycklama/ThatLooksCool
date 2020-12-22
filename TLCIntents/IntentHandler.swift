//
//  IntentHandler.swift
//  TLCIntents
//
//  Created by Justin Lycklama on 2020-09-15.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        if intent is RememberLocationIntent {
            return LocationIntentHandler()
        }
        else if intent is RememberPhraseIntent {
            return PhraseIntentHandler()
        }
        
        return self
    }
}


//
//  PhraseIntentHandler.swift
//  TLCIntents
//
//  Created by Justin Lycklama on 2020-12-21.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import Intents

class PhraseIntentHandler: INExtension, RememberPhraseIntentHandling {
    func resolveItemToRemember(for intent: RememberPhraseIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        if intent.itemToRemember == nil || intent.itemToRemember?.isEmpty ?? false || intent.itemToRemember == "Nothing" {
            completion(INStringResolutionResult.needsValue())
        } else {
            completion(INStringResolutionResult.success(with: intent.itemToRemember ?? ""))
        }
    }
        
    func handle(intent: RememberPhraseIntent, completion: @escaping (RememberPhraseIntentResponse) -> Void) {
        RealmObjects.shared.addItem(withPhrase: intent.itemToRemember ?? "None") { success in
            intent.itemToRemember = nil
            completion(RememberPhraseIntentResponse.init(code: success ? .success : .failure, userActivity: nil))            
        }
    }
}

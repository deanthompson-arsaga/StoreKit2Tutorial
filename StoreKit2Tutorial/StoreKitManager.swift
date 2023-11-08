//
//  StoreKitManager.swift
//  StoreKit2Tutorial
//
//  Created by Thompson Dean on 2023/11/07.
//

// 本日の勉強会の流れ
// 1. StoreKitのインポート
// 2. 製品情報の取得
// 3. 購入の開始
// 4. 取引ライフサイクルの処理
// 時間があれば
// 5. Listenerを実装
// 6. エラーハンドリング


import Foundation
//import StoreKit

@MainActor
final class StoreKitManager: ObservableObject {
    let storeKitIdentifiers: [String] = ["ArsagaThompson.StoreKit2Tutorial.akaishiPet", "ArsagaThompson.StoreKit2Tutorial.ando", "ArsagaThompson.StoreKit2Tutorial.asakura", "ArsagaThompson.StoreKit2Tutorial.tomoaki", "ArsagaThompson.StoreKit2Tutorial.uchida", "ArsagaThompson.StoreKit2Tutorial.ultra", "ArsagaThompson.StoreKit2Tutorial.yoshida"]
}

//
//  PrefsManager.swift
//  CIUWApp
//
//  Created by Jaelhorton on 5/12/20.
//  Copyright © 2020 ciuw. All rights reserved.
//

import Foundation

class PrefsManager:NSObject{
    
    class func set(key:String,value:Bool){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func get(key:String) -> Bool{
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
    
    class func setString(key:String,value:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getString(key:String) -> String{
        let value = UserDefaults.standard.string(forKey: key) ?? ""
        return value
    }
    
    class func setInt(key:String,value:Int){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getInt(key:String) -> Int{
        let value = UserDefaults.standard.integer(forKey: key)
        return value
    }
    
    class func setDouble(key:String,value:Double){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getDouble(key:String) -> Double{
        let value = UserDefaults.standard.double(forKey: key)
        return value
    }
    
    class func setFCMToken(val : String)
    {
        setString(key: "fcmToken", value: val)
    }
    
    class func  getFCMToken() -> String
    {
        return getString(key: "fcmToken")
    }
    
    class func setUserID(val : Int)
    {
        setInt(key: "userid", value: val)
    }
    
    class func  getUserID() -> Int
    {
        return getInt(key: "userid")
    }
    
    
    class func setEmail(val : String)
    {
        setString(key: "email", value: val)
    }
    
    class func  getEmail() -> String
    {
        return getString(key: "email")
    }
    
    class func setAvatar(val : String)
    {
        setString(key: "avatar", value: val)
    }
    
    class func  getAvatar() -> String
    {
        return getString(key: "avatar")
    }
    

    class func setFirstName(val : String)
    {
        setString(key: "firstname", value: val)
    }
    
    class func  getFirstName() -> String
    {
        return getString(key: "firstname")
    }
    class func setLastName(val : String)
    {
        setString(key: "lastname", value: val)
    }
    
    class func  getLastName() -> String
    {
        return getString(key: "lastname")
    }
    class func setPassword(val : String)
    {
        setString(key: "password", value: val)
    }
    
    class func  getPassword() -> String
    {
        return getString(key: "password")
    }

    class func setLatitude(val: Double)
    {
        setDouble(key: "latitude", value: val)
    }
    
    class func getLatitude() -> Double
    {
        return getDouble(key: "latitude")
    }

    class func setLongitude(val: Double)
    {
        setDouble(key: "longitude", value: val)
    }
    
    class func getLongitude() -> Double
    {
        return getDouble(key: "longitude")
    }

    class func setMatchDistance(val : Int)
    {
        setInt(key: "match distance", value: val)
    }
    
    class func  getMatchDistance() -> Int
    {
        let dist = getInt(key: "match distance")
        if dist == 0 {
            return 50
        }
        return dist
    }

    class func setMatchCost(val : Int)
    {
        setInt(key: "match cost", value: val)
    }
    
    class func  getMatchCost() -> Int
    {
        let cost = getInt(key: "match cost")
        if cost == 0{
            return 10
        }
        return cost
    }

    class func setMatchSizeList(matchList: [Int])
    {
        UserDefaults.standard.set(matchList, forKey: "match size")
    }
    class func getMatchSizeList() -> [Int]
    {
        let value = UserDefaults.standard.array(forKey: "match size") as? [Int] ?? [Int]()
        return value
    }
}

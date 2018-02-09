//
//  Garbage Code.swift
//  teamDB
//
//  Created by Dave Minney on 1/15/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import Foundation
/*
 // MARK: - Users Table
 
 private let users = Table("users")
 private let user_id = Expression<Int64>("id")
 private let user_firstname = Expression<String?>("first_name")
 private let user_lastname = Expression<String?>("last_name")
 private let user_onlineid = Expression<String?>("onlineid")
 private let user_email = Expression<String?>("email")
 private let user_phone = Expression<String>("phone")
 
 
 func createUserTable() {
 do {
 try db!.run(users.create(ifNotExists: true) { table in
 table.column(user_id, primaryKey: true)
 table.column(user_firstname)
 table.column(user_lastname)
 table.column(user_onlineid)
 table.column(user_email)
 table.column(user_phone)
 
 })
 } catch {
 print("Unable to create table")
 }
 }
 
 func addUser(newUser: appUserModel ) ->Int64? {
 do {
 let insert = users.insert(
 user_firstname <- newUser.firstname,
 user_lastname <- newUser.lastname,
 user_email <- newUser.email,
 user_phone <- newUser.phone,
 user_onlineid <- newUser.onlineid)
 let id = try db!.run(insert)
 
 return id
 } catch {
 print("Insert failed")
 return -1
 }
 }
 */


 

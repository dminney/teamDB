//
//  DBAccessor.swift
//  teamDB
//
//  Created by Dave Minney on 1/5/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import Foundation
import SQLite


class DBAccessor {

// the instance of the Database accessor

static let sharedInstance = DBAccessor()

private init () {
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    do {
        db = try Connection("\(path)/XCRunnerDB.sqlite3")
    } catch {
        db = nil
        print ("Unable to open database")
    }
    
    createMeetTable()
    createEventTable()
    createRunnerTable()
    createResultsTable()
   
    }

  private let db: Connection?

    
// MARK: - Meets Table
    
    private let meets = Table("meets")
    private let id = Expression<Int64>("id")
    private let meet_name = Expression<String?>("name")
    private let meet_date = Expression<String>("date")
    private let meet_address = Expression<String>("address")
    private let meet_city = Expression<String>("city")
    private let meet_state = Expression<String>("state")
    private let meet_zipcode = Expression<Int>("zipcode")
    private let meet_onlineid = Expression<String>("onlineid")
    private let last_updated = Expression<String>("updated_at")
    
    func createMeetTable() {
        do {
            try db!.run(meets.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(meet_onlineid)
                table.column(meet_name)
                table.column(meet_date)
                table.column(meet_address)
                table.column(meet_city)
                table.column(meet_state)
                table.column(meet_zipcode)
                table.column(last_updated)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addMeet(meetname: String, meetid:String, meetdate:String, meetaddress:String, meetcity:String, meetstate: String, meetzipcode: Int) ->Int64? {
        do {
            let datestring = "\(Date(timeIntervalSince1970: 0))"
            let insert = meets.insert(
                meet_name <- meetname,
                meet_onlineid <- meetid,
                meet_date <- meetdate,
                meet_address <- meetaddress,
                meet_city <- meetcity,
                meet_state <- meetstate,
                meet_zipcode <- meetzipcode,
                last_updated <- datestring)
            
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func getMeets() -> [MeetModel] {
        var meets = [MeetModel]()
        
        do {
            for meet in try db!.prepare(self.meets){
                let newmeet = MeetModel(
                    id: meet[id],
                    name: meet[meet_name]!,
                    onlineid: meet[meet_onlineid],
                    date: meet[meet_date],
                    address: meet[meet_address],
                    city: meet[meet_city],
                    state: meet[meet_state],
                    zipcode: meet[meet_zipcode],
                    updated_at: meet[last_updated])
                meets.append(newmeet)
                }
        } catch {
            print ("Select failed")
            }
        return  meets
        
    }
    
    func getNextMeet() -> [MeetModel] {
        var newmeets = [MeetModel]()
        let published_at = Expression<Date>("meet_date")

        let meetlist = meets.filter(published_at >= Date())
        do {
            for meet in (try db?.prepare(meetlist))!{
             let newmeet = MeetModel(
            id: meet[id],
            name: meet[meet_name]!,
            onlineid: meet[meet_onlineid],
            date: meet[meet_date],
            address: meet[meet_address],
            city: meet[meet_city],
            state: meet[meet_state],
            zipcode: meet[meet_zipcode],
            updated_at: meet[last_updated])
                newmeets.append(newmeet)
            }
            
        } catch {
                print ("Select failed")
        }
    return newmeets
    }
    
    func deleteMeet(meetid: Int64) -> Bool {
        do {
            let meet = meets.filter(id == meetid)
            try db!.run(meet.delete())
            return true
        } catch {
            print ("Delete failed")
        }
        return false
        
    }
    
    func updateMeet(meetid: Int64, newMeet: MeetModel) -> Bool {
        let meet = meets.filter(id == meetid)
        let datestring = "\(Date(timeIntervalSince1970: 0))"
        do {
            let update = meet.update([
                meet_name <- newMeet.name,
                meet_date <- newMeet.date,
                meet_address <- newMeet.address,
                meet_city <- newMeet.city,
                meet_state <- newMeet.state,
                meet_zipcode <- newMeet.zipcode,
                last_updated <- datestring])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print ("Update Failed: \(error)")
        }
        return false
    }

    // MARK: - Events Table
    
    private let events = Table("events")
    private let event_id = Expression<Int64>("id")
    private let event_name = Expression<String?>("name")
    private let event_onlineid = Expression<String?>("onlineid")
    private let event_time = Expression<String>("time")
    private let event_team = Expression<String>("team")
    private let event_gradeLevel = Expression<String>("gradelevel")
    private let event_meetid = Expression<String>("meetid")
    private let event_gender = Expression<Int>("gender")


    func createEventTable() {
        do {
            try db!.run(events.create(ifNotExists: true) { table in
                table.column(event_id, primaryKey: true)
                table.column(event_name)
                table.column(event_onlineid)
                table.column(event_meetid)
                table.column(event_time)
                table.column(event_team)
                table.column(event_gender)
                table.column(event_gradeLevel)
                table.column(last_updated)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addEvent(eventname: String, onlineid: String, eventmeet: String, eventtime: String, eventteam: String, eventgender: Int, eventgrade: String) ->Int64? {
       let datestring = "\(Date(timeIntervalSince1970: 0))"
        do {
            let insert = events.insert(
                event_name <- eventname,
                event_onlineid <- onlineid,
                event_meetid <- eventmeet,
                event_time <- eventtime,
                event_team <- eventteam,
                event_gender <- eventgender,
                event_gradeLevel <- eventgrade,
                last_updated <- datestring)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func getEvents(meetid: String) -> [EventInfoModel] {
        let eventsinMeet = events.filter(event_meetid == meetid)
        var eventlist = [EventInfoModel]()
        
        do {
            for event in (try db?.prepare(eventsinMeet))!{
                let newevent = EventInfoModel(
                    id: event[id],
                    name: event[event_name]!,
                    onlineid: event[event_onlineid]!,
                    meetid: event[event_meetid],
                    time: event[event_time],
                    team: event[event_team],
                    gender: event[event_gender],
                    grade: event[event_gradeLevel],
                    updated_at: event[last_updated])
                
                eventlist.append(newevent)
            }
        } catch {
            print ("Select failed")
        }
        return  eventlist
        
    }
    
    func deleteEvent(eventid: Int64) -> Bool {
        do {
            let event = events.filter(id == eventid)
            try db!.run(event.delete())
            return true
        } catch {
            print ("Delete failed")
        }
        return false
        
    }
    
    func updateEvent(eventid: Int64, newEvent: EventInfoModel) -> Bool {
        let event = events.filter(id == eventid)
        let datestring = "\(Date(timeIntervalSince1970: 0))"
        do {
            let update = event.update([
                event_name <- newEvent.name,
                event_onlineid <- newEvent.onlineid,
                event_meetid <- newEvent.meet,
                event_time <-  newEvent.time,
                event_team <- newEvent.team,
                event_gender <- newEvent.gender,
                event_gradeLevel <- newEvent.grade,
                last_updated <- datestring])
  
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print ("Update Failed: \(error)")
        }
        return false
    }


    // MARK: - Runners Table
    
    private let runners = Table("runners")
    private let runner_id = Expression<Int64>("id")
    private let runner_firstname = Expression<String?>("first_name")
    private let runner_lastname = Expression<String?>("last_name")
    private let runner_onlineid = Expression<String?>("onlineid")
    private let runner_gender = Expression<Int>("gender")
    private let runner_birthdate = Expression<String>("birthdate")
    private let runner_gradeLevel = Expression<String>("gradelevel")
    private let runner_email = Expression<String?>("email")
    private let runner_phone = Expression<String>("phone")
    private let runner_address = Expression<String>("address")
    private let runner_city = Expression<String>("city")
    private let runner_state = Expression<String>("state")
    private let runner_zipcode = Expression<String>("zipcode")
    private let runner_active = Expression<Bool>("active")
    
    func createRunnerTable() {
        do {
            try db!.run(runners.create(ifNotExists: true) { table in
                table.column(runner_id, primaryKey: true)
                table.column(runner_firstname)
                table.column(runner_lastname)
                table.column(runner_onlineid)
                table.column(runner_gender)
                table.column(runner_gradeLevel)
                table.column(runner_birthdate)
                table.column(runner_email)
                table.column(runner_phone)
                table.column(runner_address)
                table.column(runner_city)
                table.column(runner_state)
                table.column(runner_zipcode)
                table.column(runner_active)
                table.column(last_updated)
               
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addRunner(newRunner: RunnerInfoModel ) ->Int64? {
        let datestring = "\(Date(timeIntervalSince1970: 0))"
        do {
            let insert = runners.insert(
                runner_firstname <- newRunner.firstname,
                runner_lastname <- newRunner.lastname,
                runner_gender <- newRunner.gender,
                runner_gradeLevel <- newRunner.grade,
                runner_email <- newRunner.email,
                runner_phone <- newRunner.phone,
                runner_address <- newRunner.address,
                runner_city <- newRunner.city,
                runner_state <- newRunner.state,
                runner_zipcode <- newRunner.zipcode,
                runner_birthdate <- newRunner.bdate,
                runner_active <- newRunner.active,
                runner_onlineid <- newRunner.onlineid,
                last_updated <- datestring)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func getAllRunners() -> [RunnerInfoModel] {
        var runnerlist = [RunnerInfoModel]()
        
        do {
            for runner in try db!.prepare(self.runners){
                let newrunner = RunnerInfoModel(
                    id: runner[id],
                    firstname: runner[runner_firstname]!,
                    lastname: runner[runner_lastname]!,
                    onlineid: runner[runner_onlineid]!,
                    gender: runner[runner_gender],
                    gradelevel: runner[runner_gradeLevel],
                    birthdate: runner[runner_birthdate],
                    email: runner[runner_email]!,
                    phone: runner[runner_phone],
                    address: runner[runner_address],
                    city: runner[runner_city],
                    state: runner[runner_state],
                    zipcode: runner[runner_zipcode],
                    activerunner : runner[runner_active],
                    updated_at: runner[last_updated])
                runnerlist.append(newrunner)
            }
        } catch {
            print ("Select failed")
        }
        return  runnerlist
        
    }
    
    
    
    
    func deleteRunner(runnerid: Int64) -> Bool {
        do {
            let runner = runners.filter(id == runnerid)
            try db!.run(runner.delete())
            return true
        } catch {
            print ("Delete failed")
        }
        return false
        
    }
    
    func getRunnerInfo(runnerid: String) -> RunnerInfoModel{
        var newrunner = RunnerInfoModel(id: 0)
        let runnerinfo = runners.filter(runner_onlineid == runnerid)
        do {
            for runner in (try db?.prepare(runnerinfo))! {
            newrunner = RunnerInfoModel(
            id: runner[id],
            firstname: runner[runner_firstname]!,
            lastname: runner[runner_lastname]!,
            onlineid: runner[runner_onlineid]!,
            gender: runner[runner_gender],
            gradelevel: runner[runner_gradeLevel],
            birthdate: runner[runner_birthdate],
            email: runner[runner_email]!,
            phone: runner[runner_phone],
            address: runner[runner_address],
            city: runner[runner_city],
            state: runner[runner_state],
            zipcode: runner[runner_zipcode],
            activerunner : runner[runner_active],
            updated_at : runner[last_updated])
            
        }
    } catch {
    print ("Query failed")
    }
            return newrunner
    
    }
    
    func updateRunner(runnerid: Int64, newRunner: RunnerInfoModel) -> Bool {
        let datestring = "\(Date(timeIntervalSince1970: 0))"
        let runner = runners.filter(id == runnerid)
        do {
            let update = runner.update([
                runner_firstname <- newRunner.firstname,
                runner_lastname <- newRunner.lastname,
                runner_gender <- newRunner.gender,
                runner_gradeLevel <- newRunner.grade,
                runner_email <- newRunner.email,
                runner_phone <- newRunner.phone,
                runner_address <- newRunner.address,
                runner_city <- newRunner.city,
                runner_state <- newRunner.state,
                runner_zipcode <- newRunner.zipcode,
                runner_birthdate <- newRunner.bdate,
                runner_active <- newRunner.active,
                runner_onlineid <- newRunner.onlineid,
                last_updated <- datestring])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print ("Update Failed: \(error)")
        }
        return false
    }
    
    func getAvailableRunners(gender: Int, grade: String) -> [RunnerInfoModel]{
        var runnerList = [RunnerInfoModel]()
        
        let genderrunners = runners.filter(runner_gender == gender)
        let competitors = genderrunners.filter(runner_gradeLevel == grade)
        
        do {
            
            for runner in (try db?.prepare(competitors))! {
                let newrunner = RunnerInfoModel(
                    id: runner[id],
                    firstname : runner[runner_firstname]!,
                    lastname : runner[runner_lastname]!,
                    onlineid: runner[runner_onlineid]!,
                    gender : runner[runner_gender],
                    gradelevel : runner[runner_gradeLevel],
                    birthdate : runner[runner_birthdate],
                    email : runner[runner_email]!,
                    phone : runner[runner_phone],
                    address : runner[runner_address],
                    city : runner[runner_city],
                    state : runner[runner_state],
                    zipcode : runner[runner_zipcode],
                    activerunner : runner[runner_active],
                    updated_at : runner[last_updated])
                runnerList.append(newrunner)
            }
        } catch {
            print ("Query failed")
        }
        return  runnerList
    }
    
    // MARK: - Results Table
    
    private let results = Table("results")
    private let result_id = Expression<Int64>("id")
    private let result_eventid = Expression<String?>("event id")
    private let result_runnerid = Expression<String?>("runner id")
    private let result_mile1Time = Expression<Double>("mile 1 Time")
    private let result_mile2Time = Expression<Double>("mile 2 Time")
    private let result_finalTime = Expression<Double>("Final Time")
    private let result_meetid = Expression<String?>("meet id")
    
    
    func createResultsTable() {
        do {
            try db!.run(results.create(ifNotExists: true) { table in
                table.column(result_id, primaryKey: true)
                table.column(result_eventid)
                table.column(result_runnerid)
                table.column(result_mile1Time)
                table.column(result_mile2Time)
                table.column(result_finalTime)
                table.column(result_meetid)
                table.column(last_updated)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addResult(resultEventID: String, resultRunnerID: String, resultMile1Time: Double, resultMile2Time: Double, resultFinalTime: Double, resultmeetid: String) ->Int64? {
        let datestring = "\(Date(timeIntervalSince1970: 0))"
        do {
            let insert = results.insert(
                result_eventid <- resultEventID,
                result_runnerid <- resultRunnerID,
                result_mile1Time <- resultMile1Time,
                result_mile2Time <- resultMile2Time,
                result_finalTime <- resultFinalTime,
                result_meetid <- resultmeetid,
                last_updated <- datestring)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func getAllResulta() -> [ResultsModel] {
        var resultlist = [ResultsModel]()
        
        do {
            for result in try db!.prepare(self.results){
                let newresult = ResultsModel(
                    id: result[id],
                    eventid: result[result_eventid]!,
                    runnerid: result[result_runnerid]!,
                    mile1time: result[result_mile1Time],
                    mile2time: result[result_mile2Time],
                    finaltime: result[result_finalTime],
                    meetid: result[result_meetid]!)
                resultlist.append(newresult)
            }
        } catch {
            print ("Select failed")
        }
        return  resultlist
        
    }
    
    func getMeetRunners(meetid: String) -> [ResultsModel]{
        var resultList = [ResultsModel]()
        
        let competitors = results.filter(result_meetid == meetid)
        
        do {
            
            for result in (try db?.prepare(competitors))! {
                let newrunner = ResultsModel(
                    id: result[id],
                    eventid: result[result_eventid]!,
                    runnerid: result[result_runnerid]!,
                    mile1time: result[result_mile1Time],
                    mile2time: result[result_mile2Time],
                    finaltime: result[result_finalTime],
                    meetid: result[result_meetid]!)
                resultList.append(newrunner)
            }
        } catch {
            print ("Query failed")
        }
        return  resultList
    }
    
    func getEventRunners(eventid: String) -> [ResultsModel]{
        var resultList = [ResultsModel]()
        
        let competitors = results.filter(result_eventid == eventid)
        
        do {
            
            for result in (try db?.prepare(competitors))! {
                let newrunner = ResultsModel(
                    id: result[id],
                    eventid: result[result_eventid]!,
                    runnerid: result[result_runnerid]!,
                    mile1time: result[result_mile1Time],
                    mile2time: result[result_mile2Time],
                    finaltime: result[result_finalTime],
                    meetid: result[result_meetid]!)
                resultList.append(newrunner)
            }
        } catch {
            print ("Query failed")
        }
        return  resultList
    }
    
    func deleteResult(resultid: Int64) -> Bool {
        do {
            let result = results.filter(id == resultid)
            try db!.run(result.delete())
            return true
        } catch {
            print ("Delete failed")
        }
        return false
        
    }
    
    func updateResult(resultid: Int64, newResult: ResultsModel) -> Bool {
        let datestring = "\(Date(timeIntervalSince1970: 0))"
        let result = results.filter(id == resultid)
        do {
            let update = result.update([
                result_eventid <- newResult.eventid,
                result_runnerid <- newResult.runnerid,
                result_mile1Time <- newResult.mile1time!,
                result_mile2Time <- newResult.mile2time!,
                result_finalTime <- newResult.finaltime!,
                result_meetid <- newResult.meetid,
                last_updated <- datestring])
            
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print ("Update Failed: \(error)")
        }
        return false
    }
    
    
   
}

import Foundation
import XCTest
@testable import WordPressKit


class PluginStateTests: XCTestCase {
    
    func testPluginStateEquatable() {
        
        let lhs = MockPluginStateProvider.getPluginState()
        let rhs = MockPluginStateProvider.getPluginState()
        
        XCTAssertEqual(lhs, rhs)
    }
    
    func testSiteDescriptionNotActiveNotAutoupdated() {
        let plugin = MockPluginStateProvider.getPluginState(setToActive:false, autoupdate:false)
        
        let expected = "Inactive, Autoupdates off"
        
        XCTAssertEqual(plugin.active, false)
        XCTAssertEqual(plugin.autoupdate, false)
        XCTAssertEqual(plugin.stateDescription, expected)
        
    }
    
    func testSiteDescriptionNotActiveAutoupdated() {
        let plugin = MockPluginStateProvider.getPluginState(setToActive: false, autoupdate: true)
        
        let expected = "Inactive, Autoupdates on"
        
        XCTAssertEqual(plugin.active, false)
        XCTAssertEqual(plugin.autoupdate, true)
        XCTAssertEqual(plugin.stateDescription, expected)
    }
    
    func testSiteDescriptionActiveNotAutoupdated() {
        let plugin = MockPluginStateProvider.getPluginState(setToActive:true, autoupdate: false)
        
        let expected = "Active, Autoupdates off"
        
        XCTAssertEqual(plugin.active, true)
        XCTAssertEqual(plugin.autoupdate, false)
        XCTAssertEqual(plugin.stateDescription, expected)
    }
    
    func testSiteDescriptionActiveAutoupdated() {
        let plugin = MockPluginStateProvider.getPluginState(setToActive:true, autoupdate: true)
        
        let expected = "Active, Autoupdates on"
        
        XCTAssertEqual(plugin.active, true)
        XCTAssertEqual(plugin.autoupdate, true)
        XCTAssertEqual(plugin.stateDescription, expected)
    }
    
    func testPluginHomeURLEqualsPluginURL() {
        let plugin = MockPluginStateProvider.getPluginState()
        
        let expected = URL(string: "https://akismet.com/")
        
        XCTAssertEqual(plugin.slug, "akismet")
        XCTAssertEqual(plugin.homeURL, plugin.url)
        XCTAssertEqual(plugin.homeURL, expected)
    }
    
    func testPluginDirectoryURL() {
        let plugin = MockPluginStateProvider.getPluginState()
        
        let expected = URL(string: "https://wordpress.org/plugins/\(plugin.slug)")
        
        XCTAssertEqual(plugin.slug, "akismet")
        XCTAssertEqual(plugin.directoryURL, expected)
    }
    
    func testDeactivateAlowed() {
        let plugin = MockPluginStateProvider.getPluginState()
        
        let expected = true
        
        XCTAssertEqual(plugin.slug, "akismet")
        XCTAssertEqual(plugin.automanaged, false)
        XCTAssertEqual(plugin.deactivateAllowed, expected)
    }
    
    func testDeactivateNotAlowed() {
        let plugin = MockPluginStateProvider.getNotDisableablePlugin()
        
        let expected = false
        
        XCTAssertEqual(plugin.slug, "jetpack-dev")
        XCTAssertEqual(plugin.automanaged, false)
        XCTAssertEqual(plugin.deactivateAllowed, expected)
    }
    
    func testUpdateStateEncodeDoesNotThrow() {
        let updateState = PluginState.UpdateState.updated
        let encoder = JSONEncoder()
        
        do {
            XCTAssertNoThrow(try encoder.encode(updateState), "encode did not throw an error")
            let data = try encoder.encode(updateState)
        } catch {
            XCTFail("Ecode Threw an Error")
        }
    }
    
    func testDynmicValuePluginStateEncodeDoesNotThrow() {
        let plugin = MockPluginStateProvider.getDynamicValuePluginState()
        let encoder = JSONEncoder()
        
        do {
            XCTAssertNoThrow(try encoder.encode(plugin), "encode did not throw an error")
            let data = try encoder.encode(plugin)
        } catch {
            XCTFail("Ecode Threw an Error")
        }
    }
    
    func testDynmicValuePluginStateDecodeSucceeds() {
        let plugin = MockPluginStateProvider.getDynamicValuePluginState()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let expectedSlug = plugin.slug
        let expectedVersion = plugin.version
        let expectedid = plugin.id
        
        do {
            let data = try encoder.encode(plugin)
            
            XCTAssertNoThrow(try decoder.decode(PluginState.self, from: data))
            let decoded = try decoder.decode(PluginState.self, from: data)
            
            XCTAssertEqual(decoded.slug, expectedSlug)
            XCTAssertEqual(decoded.version, expectedVersion)
            XCTAssertEqual(decoded.id, expectedid)
        } catch {
            XCTFail("Ecode Threw an Error")
        }
    }
    
    func testPluginStateDecodeFromDynamicJSON() {
        let data = MockPluginStateProvider.getDynamicPluginStateJSON()
        let decoder = JSONDecoder()
        
        do {
            XCTAssertNoThrow(try decoder.decode(PluginState.self, from: data))
            let decoded = try decoder.decode(PluginState.self, from: data)
        } catch {
            XCTFail("Could not decode \(error.localizedDescription)")
        }
    }
    
    func testUpdateStateUpdatedDecodeSucceeds() {
        let data = MockPluginStateProvider.getEncodedUpdateState(state: PluginState.UpdateState.updated)
        
        let decoder = JSONDecoder()
        do {
            XCTAssertNoThrow(try decoder.decode(PluginState.UpdateState.self, from: data), "Decode from JSON successful")
            let decoded = try decoder.decode(PluginState.UpdateState.self, from: data)
            
            XCTAssertEqual(decoded, PluginState.UpdateState.updated)
        } catch {
            XCTFail("Could not decode")
        }
    }
    
    func testUpdateStateAvailableDecodeSucceeds() {
        let data = MockPluginStateProvider.getEncodedUpdateState(state: PluginState.UpdateState.available("4.0"))
        
        let decoder = JSONDecoder()
        do {
            XCTAssertNoThrow(try decoder.decode(PluginState.UpdateState.self, from: data), "Decode from JSON successful")
            let decoded = try decoder.decode(PluginState.UpdateState.self, from: data)
            
            XCTAssertEqual(decoded, PluginState.UpdateState.available("4.0"))
        } catch {
            XCTFail("Could not decode")
        }
    }
    
    func testUpdateStateUpdatingDecodeSucceeds() {
        let data = MockPluginStateProvider.getEncodedUpdateState(state: PluginState.UpdateState.updating("4.0"))
        
        let decoder = JSONDecoder()
        do {
            XCTAssertNoThrow(try decoder.decode(PluginState.UpdateState.self, from: data), "Decode from JSON successful")
            let decoded = try decoder.decode(PluginState.UpdateState.self, from: data)
            
            XCTAssertEqual(decoded, PluginState.UpdateState.updating("4.0"))
        } catch {
            XCTFail("Could not decode")
        }
    }

    
    func testUpdateStateEquatableWhenAvailable() {
        let lhs = PluginState.UpdateState.available("4.4.1")
        let rhs = PluginState.UpdateState.available("4.4.1")
        
        XCTAssertTrue(lhs == rhs)
    }
    
    func testUpdateStateNotEquatableWhenAvailableDifferentVersion() {
        let lhs = PluginState.UpdateState.available("4.4.1")
        let rhs = PluginState.UpdateState.available("3.4.1")
        
        XCTAssertFalse(lhs == rhs)
    }
    
    func testUpdateStateEquatableWhenUpdating() {
        let lhs = PluginState.UpdateState.updating("4.4.1")
        let rhs = PluginState.UpdateState.updating("4.4.1")
        
        XCTAssertTrue(lhs == rhs)
    }
    
    func testUpdateStateNotEquatableWhenUpdatingDifferentVersion() {
        let lhs = PluginState.UpdateState.updating("4.4.1")
        let rhs = PluginState.UpdateState.updating("3.4.1")
        
        XCTAssertFalse(lhs == rhs)
    }
    
    func testUpdateStateNotEquatable() {
        let lhs = PluginState.UpdateState.updated
        let rhs = PluginState.UpdateState.available("4.4.1")
        
        XCTAssertFalse(lhs == rhs)
    }
}

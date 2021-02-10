//
// Error.swift: Error code definitions, matches the values in Godot
//
// Released under the terms of the MIT license
//
// Authors:
//  Miguel de Icaza on 3/4/20.
//

import Foundation

public enum Error: Int {
    case ok
    case failed ///< Generic fail error
    case unavailable ///< What is requested is unsupported/unavailable
    case unconfigured ///< The object being used hasnt been properly set up yet
    case unauthorized ///< Missing credentials for requested resource
    case parameterRangeError ///< Parameter given out of range (5)
    case out_of_memory ///< Out of memory
    case fileNotFound
    case fileBadDrive
    case fileBadPath
    case fileNoPermission // (10)
    case fileAlreadyInUse
    case fileCantOpen
    case fileCantWrite
    case fileCantRead
    case fileUnrecognized // (15)
    case fileCorrupt
    case fileMissingDependencies
    case fileEof
    case cantOpen ///< Can't open a resource/socket/file
    case cantCreate // (20)
    case queryFailed
    case alreadyInUse
    case locked ///< resource is locked
    case timeout
    case cantConnect // (25)
    case cantResolve
    case connectionRrror
    case cantAquireResource
    case cantFork
    case invalidData ///< Data passed is invalid    (30)
    case invalidParameter ///< Parameter passed is invalid
    case alreadyExists ///< When adding item already exists
    case doesNotExist ///< When retrieving/erasing it item does not exist
    case databaseCantRead ///< database is full
    case databaseCantWrite ///< database is full    (35)
    case compilationFailed
    case methodNotFound
    case linkFailed
    case scriptFailed
    case cyclicLink // (40)
    case invalidDeclaration
    case duplicateSymbol
    case parseError
    case busy
    case skip // (45)
    case help ///< user requested help!!
    case bug ///< a bug in the software certainly happened due to a double check failing or unexpected behavior.
    case printerOnFire /// the parallel port printer is engulfed in flames
    case omgThisIsVeryVeryBad ///< shit happens has never been used though
}

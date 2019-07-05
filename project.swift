#!/usr/bin/swift sh
import XcodeGenKit // https://github.com/yonaskolb/XcodeGen ~> 2.5.0
import ProjectSpec

struct Framework {
    let name: String
}

let frameworks: [Framework] = [
    .init(name: "BitriseAPI"),
    .init(name: "CircleCIAPI"),
    .init(name: "TravisCIAPI"),
]

let project = Project(
    name: "Cimon",
    targets: [
        Target(
            name: "Cimon",
            type: .application,
            platform: .iOS,
            settings: Settings(
                buildSettings: [
                    "CODE_SIGN_STYLE": "Manual",
                    "PRODUCT_BUNDLE_IDENTIFIER": "com.bivre.cimon",
                ],
                configSettings: [
                    "Debug" : [
                        "CODE_SIGN_IDENTITY": "iPhone Developer",
                        "PROVISIONING_PROFILE_SPECIFIER": "match Development com.bivre.cimon"
                    ],
                    "Release" : [
                        "CODE_SIGN_IDENTITY": "iPhone Distribution",
                        "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.bivre.cimon"
                    ],
            ]),
            sources: [
                TargetSource(path: "Cimon"),
                TargetSource(path: "Cimon/Sources/Generated/Assets.swift", optional: true),
                TargetSource(path: "GoogleService-Info.plist"),
            ],
            dependencies: [
                Dependency(type: .target, reference: "TravisCIAPI"),
                Dependency(type: .target, reference: "CircleCIAPI"),
                Dependency(type: .target, reference: "BitriseAPI"),
                Dependency(type: .target, reference: "Shared"),
                Dependency(type: .target, reference: "Domain"),
                Dependency(type: .target, reference: "App"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "APIKit"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "Nuke"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "Pipeline"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "ReactiveSwift"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "Reachability"),
            ],
            preBuildScripts: [
                BuildScript(
                    script: .script("mint run SwiftGen/SwiftGen swiftgen config run --config Cimon/swiftgen.yml"),
                    name: "[SwiftGen] Run Script"),
                BuildScript(
                    script: .script("mint run realm/SwiftLint swiftlint"), 
                    name: "[SwiftLint] Run Script"),
            ],
            postBuildScripts: [
                BuildScript(
                    script: .script("${PODS_ROOT}/Fabric/run"), 
                    name: "[Crashlytics] Run Script", 
                    inputFiles: ["$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"]),
            ],
            scheme: TargetScheme(
                testTargets: [
                    Scheme.Test.TestTarget(name: "CimonTests"),
                    Scheme.Test.TestTarget(name: "SharedTests"),
                    Scheme.Test.TestTarget(name: "DomainTests"),
                    Scheme.Test.TestTarget(name: "AppTests"),
                ]
            )
        ),
        Target(
            name: "CimonTests",
            type: .unitTestBundle,
            platform: .iOS,
            sources: [
                TargetSource(path: "CimonTests"),
            ],
            dependencies: [
                Dependency(type: .target, reference: "Cimon"),
            ]
        ),
        Target(
            name: "BitriseAPI",
            type: .framework,
            platform: .iOS,
            settings: Settings(dictionary: [
                "PRODUCT_BUNDLE_IDENTIFIER": "com.bivre.cimon.bitrise"
            ]),
            sources: [
                TargetSource(path: "BitriseAPI"),
            ],
            dependencies: [
                Dependency(type: .carthage(findFrameworks: nil), reference: "APIKit"),
            ]
        ),
        Target(
            name: "CircleCIAPI",
            type: .framework,
            platform: .iOS,
            settings: Settings(dictionary: [
                "PRODUCT_BUNDLE_IDENTIFIER": "com.bivre.cimon.circleci"
            ]),
            sources: [
                TargetSource(path: "CircleCIAPI"),
            ],
            dependencies: [
                Dependency(type: .carthage(findFrameworks: nil), reference: "APIKit"),
            ]
        ),
        Target(
            name: "TravisCIAPI",
            type: .framework,
            platform: .iOS,
            settings: Settings(dictionary: [
                "PRODUCT_BUNDLE_IDENTIFIER": "com.bivre.cimon.travisci"
            ]),
            sources: [
                TargetSource(path: "TravisCIAPI"),
            ],
            dependencies: [
                Dependency(type: .carthage(findFrameworks: nil), reference: "APIKit"),
            ]
        ),
        Target(
            name: "Shared",
            type: .framework,
            platform: .iOS,
            settings: Settings(dictionary: [
                "PRODUCT_BUNDLE_IDENTIFIER": "com.bivre.cimon.shared"
            ]),
            sources: [
                TargetSource(path: "Shared"),
            ],
            scheme: TargetScheme(
                testTargets: [
                    Scheme.Test.TestTarget(name: "SharedTests"),
                ]
            )
        ),
        Target(
            name: "SharedTests",
            type: .unitTestBundle,
            platform: .iOS,
            sources: [
                TargetSource(path: "SharedTests")
            ],
            dependencies: [
                Dependency(type: .target, reference: "Shared"),
                Dependency(type: .target, reference: "Cimon"),
            ]
        ),
        Target(
            name: "Domain",
            type: .framework,
            platform: .iOS,
            settings: Settings(dictionary: [
                "PRODUCT_BUNDLE_IDENTIFIER": "com.bivre.cimon.domain"
            ]),
            sources: [
                TargetSource(path: "Domain"),
            ],
            dependencies: [
                Dependency(type: .target, reference: "Shared"),
            ],
            scheme: TargetScheme(
                testTargets: [
                    Scheme.Test.TestTarget(name: "DomainTests"),
                ]
            )
        ),
        Target(
            name: "DomainTests",
            type: .unitTestBundle,
            platform: .iOS,
            sources: [
                TargetSource(path: "DomainTests")
            ],
            dependencies: [
                Dependency(type: .target, reference: "Domain"),
                Dependency(type: .target, reference: "Cimon"),
            ]
        ),
        Target(
            name: "App",
            type: .framework,
            platform: .iOS,
            settings: Settings(dictionary: [
                "PRODUCT_BUNDLE_IDENTIFIER": "com.bivre.cimon.app"
            ]),
            sources: [
                TargetSource(path: "App"),
                TargetSource(path: "App/Sources/Generated/Assets.swift", optional: true),
            ],
            dependencies: [
                Dependency(type: .target, reference: "TravisCIAPI"),
                Dependency(type: .target, reference: "CircleCIAPI"),
                Dependency(type: .target, reference: "BitriseAPI"),
                Dependency(type: .target, reference: "Shared"),
                Dependency(type: .target, reference: "Domain"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "APIKit"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "Nuke"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "Pipeline"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "ReactiveSwift"),
                Dependency(type: .carthage(findFrameworks: nil), reference: "Reachability"),
            ],
            preBuildScripts: [
                BuildScript(
                    script: .script("mint run SwiftGen/SwiftGen swiftgen config run --config App/swiftgen.yml"), 
                    name: "[SwiftGen] Run Script"),
            ],
            scheme: TargetScheme(
                testTargets: [
                    Scheme.Test.TestTarget(name: "AppTests"),
                ]
            )
        ),
        Target(
            name: "AppTests",
            type: .unitTestBundle,
            platform: .iOS,
            sources: [
                TargetSource(path: "AppTests")
            ],
            dependencies: [
                Dependency(type: .target, reference: "App"),
                Dependency(type: .target, reference: "Cimon"),
            ]
        ),
    ],
    settings: Settings(dictionary: [
        "SWIFT_VERSION": "5.0",
        "DEVELOPMENT_TEAM": "PS98BD6732",
        "CODE_SIGN_STYLE": "Automatic",
    ]),
    options: SpecOptions(
        minimumXcodeGenVersion: .init("2.5.0"),
        carthageExecutablePath: "mint run Carthage/Carthage carthage",
        bundleIdPrefix: "com.bivre",
        deploymentTarget: .init(iOS: "12.0")
    )
)

// Generate
let generator = ProjectGenerator(project: project)
let fileWriter = FileWriter(project: project)
try! fileWriter.writePlists()
let xcodeproj = try! generator.generateXcodeProject()
try fileWriter.writeXcodeProject(xcodeproj, to: "Cimon.xcodeproj")

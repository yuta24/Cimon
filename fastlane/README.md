fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios fetch_certificates
```
fastlane ios fetch_certificates
```
証明書＆プロビジョニングプロファイルの取得
### ios build_beta
```
fastlane ios build_beta
```
ベータアプリのビルド
### ios generate_beta
```
fastlane ios generate_beta
```
ベータアプリの生成
### ios run_auto_tests
```
fastlane ios run_auto_tests
```
自動テストの実行

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

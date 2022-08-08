# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Upgraded `zeebe-client` gem from `0.10.1` to `0.16.2` to be compatible with Zeebe `>= 1.0.0`
- Rename `Beez::Client.create_workflow_instance` into `create_process_instance`
- Rename `Beez::Client.deploy_workflow` into `deploy_process`
- Added `Beez::Client.deploy_resource` method
- Use return value of worker's process method to pass variables into complete_job

### Fixed

- Fix a typo in the code base when requiring a ruby file

## [0.1.0] - 2020-07-18

- First release 🎆

[unreleased]: https://github.com/gottfrois/beez/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/gottfrois/beez/releases/tag/v0.1.0

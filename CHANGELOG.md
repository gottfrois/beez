# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0]

### Changed

- Upgraded `zeebe-client` to be compatible with Zeebe `>= 1.0.0`
- [BREAKING] Rename `Beez::Client.create_workflow_instance` into `create_process_instance`
- [BREAKING] Rename `Beez::Client.deploy_workflow` into `deploy_process`

### Fixed

- Fix a typo in the code base when requiring a ruby file

## [0.1.0] - 2020-07-18

- First release 🎆

[unreleased]: https://github.com/gottfrois/beez/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/gottfrois/beez/compare/v0.1.0...0.2.0
[0.1.0]: https://github.com/gottfrois/beez/releases/tag/v0.1.0

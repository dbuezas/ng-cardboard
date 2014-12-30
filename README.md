ng-cardboard
============
Virtual reality the Angular way
- Demo: http://dbuezas.github.io/ng-cardboard
- iOS 8 (Safari) / Android 4 (Chrome) / Desktop (Chrome/Safari/..) compatible

### Installation:

- npm install
- bower install

### Build:

- `gulp` for building the project to the dist folder

### Testing:
- `gulp test` for running unit-tests
- `gulp protractor` or `gulp protractor:dist` for e2e-tests

REMEMBER: all tests should go to the module they are testing!

### Developing:
- `gulp serve` for serving the development environment
- `gulp serve:dist` for production environment

# Scaffolding

- `gulp add:controller -n name`
- `gulp add:filter -n name`
- `gulp add:factory -n name`
- `gulp add:provider -n name`
- `gulp add:service -n name`
- `gulp add:directive -n name`

# TODO
- [ ] extract vr-modules to allow easy integration in existing programs
- [ ] upload to bower
- [ ] Replace vr-audio implementation to use THREE.js own implementation
- [ ] Add API to vr-container to transition states and use cartesian coordinates
- [ ] Make a cooler demo
- [x] Implement DOM duplication and positioning for VR Webpages 
- [ ] Test performance of making one CSSRenderer per vr-dom to allow stereo paralax corrections
- [ ] Allow directives as attributes, and make them combinable. Requires solving :
-- [ ] 1: One isolated scope per element problem. 
-- [ ] 2: Better API, maybe like vrContainer="{lan: 3, long:4, dist:5}"

ng-cardboard
============
Virtual reality the Angular way
- Demo: http://dbuezas.github.io
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

# Directives API
* for now just an example:
 
```html
    <vr-scene update='update(dt, t)' stereoscopic="true" eye-distance="4">
        <vr-container lat="-30" long="0" altitude="10" >
            <div vr-dom>
                <div ng-repeat="i in ['Kika', 'Cora', 'Anna']" 
                    class="hola" 
                    ng-click="holas.push(holas.length)"
                >
                    HOLA {{i}}
                </div>
            </div>
            
        </vr-container>
        
        <vr-container orientation="'imu'">
            <vr-camera fov="75"></vr-camera>
        </vr-container>

        <vr-sphere radius="600" texture="assets/images/pano.jpg"></vr-sphere>
        
        <vr-container lat="10" long="0" altitude="200" >
            <vr-sound file="assets/dogs.mp3" playing="sound"></vr-sound>
            <vr-image width="100" height="200" texture="assets/images/dog.png"></vr-image>
        </vr-container>
    </vr-scene>
    
```

# Scaffolding

- `gulp add:controller -n name`
- `gulp add:filter -n name`
- `gulp add:factory -n name`
- `gulp add:provider -n name`
- `gulp add:service -n name`
- `gulp add:directive -n name`

# TODO
- [ ] make a propper documentation of each directive
- [ ] extract vr-modules to allow easy integration in existing programs
- [ ] upload to bower
- [ ] Replace vr-audio implementation to use THREE.js own implementation
- [ ] Add API to vr-container to transition states and use cartesian coordinates
- [ ] Make a cooler demo
- [x] Implement DOM duplication and positioning for VR Webpages for Webkit
- [ ] Implement DOM duplication and positioning for VR Webpages for Gecko
- [ ] Test compatibility with Firefox OS 
- [ ] Test performance of making one CSSRenderer per vr-dom to allow stereo paralax corrections
- [ ] Allow directives as attributes, and make them combinable. Requires solving :
- [ ] 1: One isolated scope per element problem. 
- [ ] 2: Better API, maybe like vrContainer="{lan: 3, long:4, dist:5}"

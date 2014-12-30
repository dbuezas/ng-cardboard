
angular.module('ngCardboard')
.directive 'vrDom', (vrAudio, THREE)->
	scope: false # don't create new scope
	require: ['vrDom', '^vrScene', '?^vrContainer']
	controller: ($element)->
		@object3d = new THREE.CSS3DObject $element[0]
	link: ($scope, element, attribs, [vrDom, vrScene, parentvrContainer])->
		if parentvrContainer?
			parentvrContainer.object3d.add vrDom.object3d
		else
			vrScene.scene.add vrDom.object3d
	
		# pre: ($scope, element, iAttrs)-># after controller


		
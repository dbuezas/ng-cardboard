/**
 * DeviceOrientationControls - applies device orientation on object rotation
 *
 * @param {Object} object - instance of THREE.Object3D
 * @constructor
 *
 * @author richt / http://richt.me
 * @author WestLangley / http://github.com/WestLangley
 * @author jonobr1 / http://jonobr1.com
 * @author arodic / http://aleksandarrodic.com
 * @author doug / http://github.com/doug
 * @author David Buezas / http://github.com/dbuezas
 *
 * W3C Device Orientation control
 * (http://w3c.github.io/deviceorientation/spec-source-orientation.html)
 */
// david addition begin
THREE.Vector4.prototype.setAxisAngleFromQuaternion2 = function(q2) {
	// equivalent to setAxisFromQuaternion but avoids axis inversion (analog to slerp algorithm)
	// http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToAngle/index.htm
	// q2 is assumed to be normalized
	
	// begin added part
	var q = q2.clone();
	if (q.w < 0) {
		q.x *= -1;
		q.y *= -1;
		q.z *= -1;
		q.w *= -1;
	}
	// end added part

	this.w = 2 * Math.acos(q.w);
	var s = Math.sqrt(1 - q.w * q.w);
	if (s < 0.0000000000001) {
		this.x = 1;
		this.y = 0;
		this.z = 0;
	} else {
		this.x = q.x / s;
		this.y = q.y / s;
		this.z = q.z / s;
	}


	return this;
};
// david addition end


THREE.DeviceOrientationControls = function(object) {
	// david addition begin
	window.debug = this
	this.updateDegree = function(degree){
		this.old_rates = [];
		this.rates = [];
		this.axisAngles = [];
		this.lastT = +new Date;
		for (var i = 0; i< degree; i++){
			this.old_rates.push(new THREE.Quaternion());
			this.rates.push(new THREE.Quaternion());
			this.axisAngles.push(new THREE.Vector4());
		}
	}
	this.updateDegree(2);
	this.predictms = -20;
	this.errorQuaternion = new THREE.Quaternion()

	// david addition end
	this.object = object;

	this.object.rotation.reorder('YXZ');

	this.freeze = true;

	this.movementSpeed = 1.0;
	this.rollSpeed = 0.005;
	this.autoAlign = true;
	this.autoForward = false;

	this.alpha = 0;
	this.beta = 0;
	this.gamma = 0;
	this.orient = 0;

	this.alignQuaternion = new THREE.Quaternion();
	this.orientationQuaternion = new THREE.Quaternion();

	var quaternion = new THREE.Quaternion();
	var quaternionLerp = new THREE.Quaternion();

	var tempVector3 = new THREE.Vector3();
	var tempMatrix4 = new THREE.Matrix4();
	var tempEuler = new THREE.Euler(0, 0, 0, 'YXZ');
	var tempQuaternion = new THREE.Quaternion();

	var zee = new THREE.Vector3(0, 0, 1);
	var up = new THREE.Vector3(0, 1, 0);
	var v0 = new THREE.Vector3(0, 0, 0);
	var euler = new THREE.Euler();
	var q0 = new THREE.Quaternion(); // - PI/2 around the x-axis
	var q1 = new THREE.Quaternion(- Math.sqrt(0.5), 0, 0, Math.sqrt(0.5));

	this.deviceOrientation = {};
	this.screenOrientation = window.orientation || 0;

	//david removed
	// this.onDeviceOrientationChangeEvent = (function(rawEvtData) {
	// 	document.getElementById("debug").innerHTML = rawEvtData.alpha + ' ' + rawEvtData.beta + ' ' + rawEvtData.gamma

	// 	this.deviceOrientation = rawEvtData;

	// }).bind(this);
	//end david removed
	
	//start david added
	this.onDeviceOrientationChangeEvent = function(){
		var euler = new THREE.Euler(0, 0, 0, 'YXZ');
		var deviceMatrix;

		var now, deltaT;

		var tmp_rates;

		var i;
		var q;
		var qConj = new THREE.Quaternion();
		var d = new THREE.Quaternion();
		return function(event){
			//setTimeout(function(){
				if ( this.freeze ) return;
				this.alpha  = THREE.Math.degToRad( event.alpha || 0 ); // Z
				this.beta   = THREE.Math.degToRad( event.beta  || 0 ); // X'
				this.gamma  = THREE.Math.degToRad( event.gamma || 0 ); // Y''
				this.orient = THREE.Math.degToRad( this.screenOrientation       || 0 ); // O
				// only process non-zero 3-axis data
				if ( this.alpha !== 0 && this.beta !== 0 && this.gamma !== 0) {
					now = event.t || +new Date;

					deltaT = now - this.lastT;

					predictms = -deltaT;

					tmp_rates = this.old_rates;
					this.old_rates = this.rates;
					this.rates = tmp_rates;
					tmp_rates = undefined;

					euler.set(this.beta, this.alpha, - this.gamma, 'YXZ');

					this.orientationQuaternion.multiply(q0.setFromAxisAngle(zee, - this.orient));

					this.rates[0].setFromEuler(euler);
					
					this.axisAngles[0].setAxisAngleFromQuaternion2( this.rates[0] );

					for (i = 1; i < this.rates.length; i++){
						qConj.copy(this.old_rates[i-1]).conjugate(); // conjugate should be the same as invert as q should have modulo 1
						d.copy(this.rates[i-1]).multiply(qConj);
						d.normalize();
						this.axisAngles[i].setAxisAngleFromQuaternion2(d);
						this.axisAngles[i].w *= 1/deltaT;
						this.rates[i].setFromAxisAngle(this.axisAngles[i], this.axisAngles[i].w);
						// Here I am just computing the derivatives of the orientation cuaternion
					}

					window.test = window.test || []
					sample = []
					window.test.push(sample)
					for (i = 0; i < this.rates.length; i++){
						sample.push(this.axisAngles[i].w)
					}
					this.lastT = now;
				}
			//}.bind(this),0)
		}.bind( this );
	}.bind( this )();
	//end david added

	var getOrientation = function() {
		switch (window.screen.orientation || window.screen.mozOrientation) {
			case 'landscape-primary':
				return 90;
			case 'landscape-secondary':
				return -90;
			case 'portrait-secondary':
				return 180;
			case 'portrait-primary':
				return 0;
		}
		// this returns 90 if width is greater then height 
		// and window orientation is undefined OR 0
		// if (!window.orientation && window.innerWidth > window.innerHeight)
		//   return 90;
		return window.orientation || 0;
	};

	this.onScreenOrientationChangeEvent = (function() {

		this.screenOrientation = getOrientation();

	}).bind(this);

	this.extrapolate = function(){
		var now, 
			deltaT,
			extrapolation = new THREE.Quaternion(),
			rate = new THREE.Quaternion(),
			tmp,
			i_factorial,
			i,
			factor;
		return function(){
			now = +new Date;
			deltaT = now - this.lastT;
			if (deltaT > 60) {
				deltaT = 60;
			}
			deltaT += this.predictms;
			extrapolation.copy(this.rates[0]);
			i_factorial = 1;
			for (i = 1; i < this.axisAngles.length; i++) {
				i_factorial *= i;
				factor = Math.pow(deltaT, i) / i_factorial;
				rate.setFromAxisAngle(this.axisAngles[i], this.axisAngles[i].w * factor);
				rate.multiply(extrapolation);
				tmp = extrapolation;
				extrapolation = rate;
				rate = tmp;
			}
			
			return extrapolation; 
		}
	}();
	this.update = function(delta) {
		// start david add
		var extrapolation = new THREE.Quaternion();
		return function(){
			//console.log(+new Date() - test)
			//test = +new Date
			if (this.freeze) return;

			// should not need this
			var orientation = getOrientation(); 
			if (orientation !== this.screenOrientation) {
			  this.screenOrientation = orientation;
			  this.autoAlign = true;
			}

			extrapolation.copy(this.extrapolate())

			// orient the device
			if (this.autoAlign) this.orientationQuaternion.copy(this.rates[0]); // extrapolation breaks the auto alignment
			else this.orientationQuaternion.copy(extrapolation);

			// camera looks out the back of the device, not the top
			this.orientationQuaternion.multiply(q1);

			// adjust for screen orientation
			this.orientationQuaternion.multiply(q0.setFromAxisAngle(zee, - this.orient));

			this.object.quaternion.copy(this.alignQuaternion);
			this.object.quaternion.multiply(this.orientationQuaternion);

			if (this.autoForward) {

			  tempVector3
				.set(0, 0, -1)
				.applyQuaternion(this.object.quaternion, 'ZXY')
				.setLength(this.movementSpeed / 50); // TODO: why 50 :S

			  this.object.position.add(tempVector3);

			}

			if (this.autoAlign && this.alpha !== 0) {
				this.autoAlign = false;
				this.align();
			}

		};
		// end david add
		
		return function() {

			if (this.freeze) return;

			// should not need this
			var orientation = getOrientation(); 
			if (orientation !== this.screenOrientation) {
				this.screenOrientation = orientation;
				this.autoAlign = true;
			}

			this.alpha = this.deviceOrientation.gamma ?
				THREE.Math.degToRad(this.deviceOrientation.alpha) : 0; // Z
			this.beta = this.deviceOrientation.beta ?
				THREE.Math.degToRad(this.deviceOrientation.beta) : 0; // X'
			this.gamma = this.deviceOrientation.gamma ?
				THREE.Math.degToRad(this.deviceOrientation.gamma) : 0; // Y''
			this.orient = this.screenOrientation ?
				THREE.Math.degToRad(this.screenOrientation) : 0; // O

			// The angles alpha, beta and gamma
			// form a set of intrinsic Tait-Bryan angles of type Z-X'-Y''

			// 'ZXY' for the device, but 'YXZ' for us
			euler.set(this.beta, this.alpha, - this.gamma, 'YXZ');

			quaternion.setFromEuler(euler);
			quaternionLerp.slerp(quaternion, .5); // interpolate

			// orient the device
			if (this.autoAlign) this.orientationQuaternion.copy(quaternion); // interpolation breaks the auto alignment
			else this.orientationQuaternion.copy(quaternionLerp);

			// camera looks out the back of the device, not the top
			this.orientationQuaternion.multiply(q1);

			// adjust for screen orientation
			this.orientationQuaternion.multiply(q0.setFromAxisAngle(zee, - this.orient));

			this.object.quaternion.copy(this.alignQuaternion);
			this.object.quaternion.multiply(this.orientationQuaternion);

			if (this.autoForward) {

				tempVector3
					.set(0, 0, -1)
					.applyQuaternion(this.object.quaternion, 'ZXY')
					.setLength(this.movementSpeed / 50); // TODO: why 50 :S

				this.object.position.add(tempVector3);

			}

			if (this.autoAlign && this.alpha !== 0) {

				this.autoAlign = false;

				this.align();

			}

		};

	}();

	// //debug
	// window.addEventListener('click', (function(){
	//   this.align();
	// }).bind(this)); 

	this.align = function() {

		tempVector3
			.set(0, 0, -1)
			.applyQuaternion(tempQuaternion.copy(this.orientationQuaternion).inverse(), 'ZXY');

		tempEuler.setFromQuaternion(
			tempQuaternion.setFromRotationMatrix(
				tempMatrix4.lookAt(tempVector3, v0, up)
			)
		);

		tempEuler.set(0, tempEuler.y, 0);
		this.alignQuaternion.setFromEuler(tempEuler);

	};
	this.connect = function() {

		// run once on load
		this.onScreenOrientationChangeEvent();

		// window.addEventListener('orientationchange', this.onScreenOrientationChangeEvent, false);
		window.addEventListener('deviceorientation', this.onDeviceOrientationChangeEvent, false);

		this.freeze = false;

		return this;

	};

	this.disconnect = function() {

		this.freeze = true;

		// window.removeEventListener('orientationchange', this.onScreenOrientationChangeEvent, false);
		window.removeEventListener('deviceorientation', this.onDeviceOrientationChangeEvent, false);

	};


};


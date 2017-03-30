// WebVR helper for threesrap.js.
// Should work with Oculus Rift and HTC Vive.

THREE.Bootstrap.registerPlugin('webvr', {
  listen: ['render', 'resize', 'update'],

  defaults: {
    standing: true, // true: origin is at the floor in the center of VR space
                    // false: origin is at the initial headset location
    fallbackMessage: true,
  },

  install: function (three) {
    three.vr = {};
    three.vr.effect = new THREE.VREffect( three.renderer );
    // this makes Loop call vrDisplay's requestAnimationFrame method
    three.Loop.window = three.vr.effect;

    if (WEBVR.isAvailable() === true) {
      document.body.appendChild( WEBVR.getButton( three.vr.effect ) );
    } else {
      console.log('WebVR is not supported.');
      if (this.options.fallbackMessage) {
        document.body.appendChild( WEBVR.getMessage() );
      }
    }

    three.vr.controls = new THREE.VRControls( three.camera );
    three.vr.controls.standing = this.options.standing;

    three.vr.controller0 = new THREE.ViveController( 0 );
    three.vr.controller1 = new THREE.ViveController( 1 );
    three.vr.controller0.standingMatrix = three.vr.controls.getStandingMatrix();
    three.vr.controller1.standingMatrix = three.vr.controls.getStandingMatrix();
    three.scene.add( three.vr.controller0 );
    three.scene.add( three.vr.controller1 );
  },

  uninstall: function (three) {
    three.Loop.window = window;
    delete three.vr;
  },

  resize: function (event, three) {
    three.vr.effect.setSize( window.innerWidth, window.innerHeight );
  },

  update: function (event, three) {
    three.vr.controls.update();
    three.vr.controller0.update();
    three.vr.controller1.update();
  },

  render: function (event, three) {
    three.vr.effect.render(three.scene, three.camera);
  }
});

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:three_js/three_js.dart' as three;
import 'package:three_js_controls/orbit_controls.dart';
import 'package:three_js_helpers/point_light_helper.dart';

class DesignLibraryController extends ChangeNotifier {
  three.ThreeJS? threeJs;
  late OrbitControls controls;
  bool threeInitialized = false;

  void init() {
    print("aqui foi11");
    three.ThreeJS(
      setup: () {
        print("aqui foi");
      },
      onSetupComplete: () {
        print("Three.js setup complete");
        threeInitialized = true;
        // notifyListeners();
      },
    );
    print("aqui foi22");
  }

  void end() {
    threeJs!.dispose();
    controls.dispose();
  }

  Future<void> setup() async {
    print("uai");
    // threeJs.scene = three.Scene();
    // threeJs.scene.background = three.Color.fromHex32(
    //   DarkTheme.gray900Color.toARGB32(),
    // );

    // threeJs.camera = three.PerspectiveCamera(
    //   75,
    //   threeJs.width / threeJs.height,
    //   0.1,
    //   5000,
    // );
    // threeJs.camera.aspect = 400 / 400;
    // threeJs.camera.updateProjectionMatrix();

    // threeJs.renderer!.setSize(400, 400);
    // threeJs.renderer!.outputColorSpace = three.LinearSRGBColorSpace;

    // controls = OrbitControls(threeJs.camera, threeJs.globalKey);
    // controls.enablePan = true;
    // controls.enableZoom = true;
    // controls.enableRotate = true;
    // controls.maxPolarAngle = math.pi / 2;
    // controls.object.position.setFrom(
    //   three.Vector3(1, 0.3, 1).setLength(200 * 2),
    // );
    // controls.target.setFrom(three.Vector3(100, 0, 100));
    // controls.update();

    // final ambient = three.AmbientLight(0x000000);
    // threeJs.scene.add(ambient);

    // final camLight = three.DirectionalLight(0xFFFFFF, .75);
    // threeJs.scene.add(camLight);

    // final pointLight1 = three.PointLight(0xFFFFFF, .55, 0, 0.2);
    // pointLight1.position.setFrom(three.Vector3(50, 200, -100));
    // threeJs.scene.add(pointLight1);

    // var sphereSize1 = 10.0;
    // var pointLightHelper1 = PointLightHelper(
    //   pointLight1,
    //   sphereSize1,
    //   0xFF0000,
    // );
    // threeJs.scene.add(pointLightHelper1);

    // final pointLight2 = three.PointLight(0xFFFFFF, .55, 0, 0.2);
    // pointLight2.position.setFrom(three.Vector3(-0, 200, 200));
    // threeJs.scene.add(pointLight2);

    // var sphereSize2 = 10.0;
    // var pointLightHelper2 = PointLightHelper(
    //   pointLight2,
    //   sphereSize2,
    //   0xFF0000,
    // );
    // threeJs.scene.add(pointLightHelper2);

    // final pointLight3 = three.PointLight(0xFFFFFF, .55, 0, 0.2);
    // pointLight3.position.setFrom(three.Vector3(200, 300, 250));
    // threeJs.scene.add(pointLight3);

    // var sphereSize3 = 10.0;
    // var pointLightHelper3 = PointLightHelper(
    //   pointLight3,
    //   sphereSize3,
    //   0xFF0000,
    // );
    // threeJs.scene.add(pointLightHelper3);

    // print("nao é");

    // // await loadObject();

    // threeJs.addAnimationEvent((dt) {
    //   controls.update();
    //   camLight.position.setFrom(threeJs.camera.position);
    //   threeJs.render(threeJs.scene, threeJs.camera);
    // });
  }

  Future<void> loadObject() async {
    final loader = three.STLLoader();
    await loader.fromAsset('examples/benchy.stl').then((mesh) {
      var m = three.Matrix4();
      m = m.premultiply(three.Matrix4().makeScale(1, 1, 1));
      m = m.premultiply(three.Matrix4().makeRotationX((-90 / 180) * math.pi));
      m = m.premultiply(three.Matrix4().makeRotationY(0 / 180 * math.pi));
      m = m.premultiply(three.Matrix4().makeRotationZ((0 / 180) * math.pi));
      mesh!.geometry!.applyMatrix4(m);

      m = bboxToCenter(mesh.geometry!);
      // m = m.premultiply(three.Matrix4().makeTranslation(0, 0, 0));
      mesh.geometry!.applyMatrix4(m);

      var group = three.Group();

      var obj = three.Mesh(
        mesh.geometry,
        three.MeshPhongMaterial({
          three.MaterialProperty.color: three.Color.fromHex64(0x21A452),
          three.MaterialProperty.specular: three.Color.fromHex64(0x111111),
          three.MaterialProperty.shininess: 10,
          three.MaterialProperty.side: three.DoubleSide,
        }),
      );

      group.add(obj);

      threeJs!.scene.add(group);
    });
  }

  three.Matrix4 bboxToCenter(three.BufferGeometry geometry) {
    geometry.computeBoundingBox();
    var minX = geometry.boundingBox!.min.x;
    var minY = geometry.boundingBox!.min.y;
    var minZ = geometry.boundingBox!.min.z;
    var m = three.Matrix4();
    m = m.premultiply(three.Matrix4().makeTranslation(-minX, -minY, -minZ));
    m = m.premultiply(three.Matrix4().makeTranslation(200 / 2, 0, 200 / 2));
    var half = geometry.boundingBox!.max.clone().sub(geometry.boundingBox!.min);
    m = m.premultiply(
      three.Matrix4().makeTranslation(-half.x / 2, 0, -half.z / 2),
    );
    return m;
  }
}

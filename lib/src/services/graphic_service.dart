import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:sevyhub/src/models/design_library_model.dart';
import 'package:sevyhub/src/models/file_model.dart';
import 'package:sevyhub/src/models/vector_3_model.dart';
import 'package:sevyhub/src/utils/exception_util.dart';
import 'package:web/web.dart' as web;
import 'package:three_js/three_js.dart' as three;
import 'package:image/image.dart' as img;

class GraphicService {
  Future<DesignFileModel> getDesignFile(FileModel file) async {
    try {
      var designFile = DesignFileModel(
        id: file.id,
        name: file.name,
        fileSize: file.bytes.lengthInBytes,
        timeCreated: DateTime.now(),
        timeUpdated: DateTime.now(),
      );

      var resultSetupThumbnailScene = setupThumbnailScene();

      three.Scene thumbnailScene = resultSetupThumbnailScene["scene"];
      three.PerspectiveCamera thumbnailCamera =
          resultSetupThumbnailScene["camera"];
      three.WebGLRenderer thumbnailRenderer =
          resultSetupThumbnailScene["renderer"];

      await setupObjectAndScenePosition(
        file.bytes,
        thumbnailCamera,
        thumbnailScene,
        thumbnailRenderer,
      ).then((objSize) {
        designFile.objectLength = objSize.x;
        designFile.objectWidth = objSize.y;
        designFile.objectHeight = objSize.z;
      });

      await Future.delayed(const Duration(milliseconds: 100));

      await generateObjectThumbnail(
        thumbnailRenderer,
        thumbnailScene,
        thumbnailCamera,
      ).then((thumbnail) {
        designFile.thumbnail = thumbnail;
      });

      return designFile;
    } catch (e) {
      throw AppException('Error generating design file: $e');
    }
  }

  Map<String, dynamic> setupThumbnailScene() {
    late three.Scene thumbnailScene;
    late three.PerspectiveCamera thumbnailCamera;
    late three.WebGLRenderer thumbnailRenderer;
    final canvas = web.HTMLCanvasElement();
    canvas.width = 512;
    canvas.height = 512;
    dynamic glBrowser = canvas.getContext('webgl2');

    var gl = three.RenderingContext.create(
      three.LibOpenGLES(glBrowser),
      512,
      512,
    );

    thumbnailRenderer = three.WebGLRenderer(
      three.WebGLRendererParameters(
        width: 512,
        height: 512,
        antialias: true,
        alpha: true,
        gl: gl,
      ),
    );
    thumbnailRenderer.outputColorSpace = three.LinearSRGBColorSpace;

    thumbnailScene = three.Scene();
    // thumbnailScene.background = three.Color.fromHex64(0x141412);

    thumbnailCamera = three.PerspectiveCamera(35, 512 / 512, 0.1, 5000);

    final ambient = three.AmbientLight(0x404040, 1.5);
    thumbnailScene.add(ambient);

    final keyLight = three.DirectionalLight(0xffffff, 1.1);
    keyLight.position.setValues(100, 150, 200);
    keyLight.castShadow = true;
    thumbnailScene.add(keyLight);

    final fillLight = three.DirectionalLight(0xffffff, 0.6);
    fillLight.position.setValues(-100, 50, -150);
    thumbnailScene.add(fillLight);

    final backLight = three.DirectionalLight(0xffffff, 0.3);
    backLight.position.setValues(0, 100, -300);
    thumbnailScene.add(backLight);

    return {
      'scene': thumbnailScene,
      'camera': thumbnailCamera,
      'renderer': thumbnailRenderer,
    };
  }

  Future<Vector3Model> setupObjectAndScenePosition(
    Uint8List bytes,
    three.PerspectiveCamera thumbnailCamera,
    three.Scene thumbnailScene,
    three.WebGLRenderer thumbnailRenderer,
  ) async {
    try {
      final loader = three.STLLoader();
      final objSize = three.Vector3(0, 0, 0);
      await loader.fromBytes(bytes).then((mesh) {
        var obj = three.Mesh(
          mesh.geometry,
          three.MeshPhongMaterial({
            three.MaterialProperty.color: three.Color.fromHex64(0xF5B616),
            three.MaterialProperty.specular: three.Color.fromHex64(0x111111),
            three.MaterialProperty.side: three.DoubleSide,
          }),
        );

        obj.rotateX((-90 / 180) * math.pi);
        obj.geometry!.center();
        obj.geometry!.computeBoundingBox();
        final box = obj.geometry!.boundingBox!;
        final size = box.getSize(three.Vector3());
        final maxDim = math.max(math.max(size.x, size.y), size.z);
        final radius = maxDim * 0.40;

        objSize.setValues(size.x, size.y, size.z);

        final fov = thumbnailCamera.fov * (math.pi / 180);
        final cameraDistance = radius / math.tan(fov / 2);

        thumbnailCamera.position.setValues(
          cameraDistance,
          cameraDistance - 20,
          cameraDistance,
        );
        thumbnailCamera.lookAt(
          three.Vector3(0, (cameraDistance * 0.07) * -1, 0),
        );
        thumbnailCamera.updateProjectionMatrix();

        thumbnailScene.add(obj);
      });
      return Vector3Model(x: objSize.x, y: objSize.y, z: objSize.z);
    } catch (e) {
      throw AppException('Error setting up object and scene position: $e');
    }
  }

  Future<String?> generateObjectThumbnail(
    three.WebGLRenderer thumbnailRenderer,
    three.Scene thumbnailScene,
    three.Camera thumbnailCamera,
  ) async {
    int width;
    int height;
    try {
      final size = three.Vector2(0, 0);
      thumbnailRenderer.getDrawingBufferSize(size);
      width = size.x.toInt();
      height = size.y.toInt();
    } catch (_) {
      width = 512;
      height = 512;
    }

    final renderTarget = three.WebGLRenderTarget(width, height);
    final prevTarget = thumbnailRenderer.getRenderTarget();
    thumbnailRenderer.setRenderTarget(renderTarget);
    thumbnailRenderer.render(thumbnailScene, thumbnailCamera);

    final pixelArray = three.Uint8Array(width * height * 4);
    thumbnailRenderer.readRenderTargetPixels(
      renderTarget,
      0,
      0,
      width,
      height,
      pixelArray,
    );

    final pixelBuffer = Uint8List(pixelArray.length);
    for (var i = 0; i < pixelArray.length; i++) {
      pixelBuffer[i] = pixelArray[i].toInt();
    }

    thumbnailRenderer.setRenderTarget(prevTarget);
    renderTarget.dispose();

    final image = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: pixelBuffer.buffer,
      numChannels: 4,
      order: img.ChannelOrder.rgba,
    );
    final flipped = img.flipVertical(image);

    final pngBytes = img.encodePng(flipped);
    return base64Encode(pngBytes);
  }
}

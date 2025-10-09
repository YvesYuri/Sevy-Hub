import 'dart:math' as math;
import 'dart:typed_data';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:sevyhub/src/models/design_file_model.dart';
import 'package:sevyhub/src/services/storage_service.dart';
import 'package:three_js/three_js.dart' as three;

class DesignLibraryController extends ChangeNotifier {
  final StorageService storageService;

  DesignLibraryController({required this.storageService});

  List<Map<String, String>> designFiles = [];

  void disposeScenes() {
    super.dispose();
  }

  Future<void> getDesignFiles() async {
    designFiles.clear();
    await storageService
        .listFilesAndFolders("/")
        .then((result) {
          for (var item in result.items) {
            designFiles.add({item.name: item.fullPath});
          }
          notifyListeners();
        })
        .catchError((error) {
          print('Error listing files and folders: $error');
        });
  }

  Future<DesignFileModel> getDesignFileDetails(
    Map<String, String> designFile,
  ) async {
    var resultSetupThumbnailScene = setupThumbnailScene();

    three.Scene thumbnailScene = resultSetupThumbnailScene.$1;
    three.PerspectiveCamera thumbnailCamera = resultSetupThumbnailScene.$2;
    three.WebGLRenderer thumbnailRenderer = resultSetupThumbnailScene.$3;
    
    var fileMetadataSizeAndBytes= await storageService.getFileMetadataSizeAndBytes(
      designFile.values.first,
    );

    Uint8List? fileBytes = fileMetadataSizeAndBytes.values.first;

    int? fileSize = fileMetadataSizeAndBytes.keys.first;

    three.Vector3 objSize = await loadSTLDesignFile(fileBytes!, thumbnailCamera, thumbnailScene, thumbnailRenderer);

    await Future.delayed(const Duration(milliseconds: 100));
    
    Uint8List thumbnailBytes = await generateThumbnail(thumbnailRenderer, thumbnailScene, thumbnailCamera);

    return DesignFileModel(
      name: designFile.keys.first,
      url: designFile.values.first,
      objSize: ObjSizeModel(
        height: objSize.y,
        width: objSize.x,
        length: objSize.z,
      ),
      thumbnail: thumbnailBytes,
      fileSize: fileSize! / math.pow(1024, 2),
    );
  }

  (three.Scene, three.PerspectiveCamera, three.WebGLRenderer)
  setupThumbnailScene() {
    late three.Scene thumbnailScene;
    late three.PerspectiveCamera thumbnailCamera;
    late three.WebGLRenderer thumbnailRenderer;
    final canvas = html.CanvasElement(width: 512, height: 512);
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
    thumbnailScene.background = three.Color.fromHex64(0x141412);

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

    return (thumbnailScene, thumbnailCamera, thumbnailRenderer);
  }

  Future<three.Vector3> loadSTLDesignFile(
    Uint8List bytes,
    three.PerspectiveCamera thumbnailCamera,
    three.Scene thumbnailScene,
    three.WebGLRenderer thumbnailRenderer,
  ) async {
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
    return objSize;
  }

  Future<Uint8List> generateThumbnail(three.WebGLRenderer thumbnailRenderer, three.Scene thumbnailScene, three.Camera thumbnailCamera) async {
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
    return Uint8List.fromList(pngBytes);
  }


  // void downloadThumbnail(
  //   Uint8List pngData, [
  //   String filename = 'thumbnail.png',
  // ]) {
  //   final blob = html.Blob([pngData], 'image/png');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.AnchorElement(href: url)
  //     ..download = filename
  //     ..click();
  //   html.Url.revokeObjectUrl(url);
  // }

}

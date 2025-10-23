abstract class DesignLibraryModel {
  String get id;
  String get name;
  DateTime get timeCreated;
  DateTime get timeUpdated;
  Map<String, dynamic> toJson();
  
  DesignLibraryModel copyWith({
    String? name,
    DateTime? timeUpdated,
  });
  
  static DesignLibraryModel fromJson(Map<String, dynamic> json) {
    if (json.containsKey('children')) {
      return DesignFolderModel.fromJson(json);
    } else {
      return DesignFileModel.fromJson(json);
    }
  }
}

class DesignFolderModel implements DesignLibraryModel {
  @override
  String id;
  @override
  String name;
  @override
  DateTime timeCreated;
  @override
  DateTime timeUpdated;
  List<DesignLibraryModel> children;

  DesignFolderModel({
    required this.id,
    required this.name,
    required this.children,
    required this.timeCreated,
    required this.timeUpdated,
  });

  @override
  DesignFolderModel copyWith({
    String? name,
    DateTime? timeCreated,
    DateTime? timeUpdated,
    List<DesignLibraryModel>? children,
  }) {
    return DesignFolderModel(
      id: id,
      name: name ?? this.name,
      timeCreated: timeCreated ?? this.timeCreated,
      timeUpdated: timeUpdated ?? this.timeUpdated,
      children: children ?? this.children,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['timeCreated'] = timeCreated;
    data['timeUpdated'] = timeUpdated;
    data['children'] = children.map((child) => child.toJson()).toList();
    return data;
  }

  factory DesignFolderModel.fromJson(Map<String, dynamic> json) {
    return DesignFolderModel(
      id: json['id'],
      name: json['name'],
      timeCreated: DateTime.now(),
      timeUpdated: DateTime.now(),
      children: (json['children'] as List<dynamic>? ?? [])
          .map<DesignLibraryModel>(
            (v) => DesignLibraryModel.fromJson(v as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class DesignFileModel implements DesignLibraryModel {
  @override
  String id;
  @override
  String name;
  @override
  DateTime timeCreated;
  @override
  DateTime timeUpdated;
  int fileSize;
  double? objectLength;
  double? objectWidth;
  double? objectHeight;
  String? thumbnail;

  DesignFileModel({
    required this.id,
    required this.name,
    required this.fileSize,
    required this.timeCreated,
    required this.timeUpdated,
    this.objectLength,
    this.objectWidth,
    this.objectHeight,
    this.thumbnail,
  });

  @override
  DesignFileModel copyWith({
    String? name,
    DateTime? timeCreated,
    DateTime? timeUpdated,
    int? fileSize,
    double? objectLength,
    double? objectWidth,
    double? objectHeight,
    String? thumbnail,
  }) {
    return DesignFileModel(
      id: id,
      name: name ?? this.name,
      timeCreated: timeCreated ?? this.timeCreated,
      timeUpdated: timeUpdated ?? this.timeUpdated,
      fileSize: fileSize ?? this.fileSize,
      objectLength: objectLength ?? this.objectLength,
      objectWidth: objectWidth ?? this.objectWidth,
      objectHeight: objectHeight ?? this.objectHeight,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fileSize'] = fileSize;
    data['timeCreated'] = timeCreated;
    data['timeUpdated'] = timeUpdated;
    data['objectLength'] = objectLength;
    data['objectWidth'] = objectWidth;
    data['objectHeight'] = objectHeight;
    data['thumbnail'] = thumbnail;
    return data;
  }

  factory DesignFileModel.fromJson(Map<String, dynamic> json) {
    return DesignFileModel(
      id: json['id'],
      name: json['name'],
      fileSize: json['fileSize'],
      timeCreated: json['timeCreated'],
      timeUpdated: json['timeUpdated'],
      objectLength: (json['objectLength'] as num?)?.toDouble(),
      objectWidth: (json['objectWidth'] as num?)?.toDouble(),
      objectHeight: (json['objectHeight'] as num?)?.toDouble(),
      thumbnail: json['thumbnail'],
    );
  }
}
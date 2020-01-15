class Caption {
  final int index;
  String desc;
  String imagePath;
  Caption({this.index});

  setDesc(String desc) {
    this.desc = desc;
  }

  setImage(String imageDir) {
    this.imagePath = imageDir;
  }
}

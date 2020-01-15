class Pregunta {
  String id;
  String pregunta;
  String descripcion;
  String base64Image;

  Pregunta(int id, String pregunta, String descripcion, String image) {
    this.id = id.toString();
    this.pregunta = pregunta;
    this.descripcion = descripcion;
    this.base64Image = image;
  }

  Pregunta.fromJson(Map json)
      : id = json['id'],
        pregunta = json['pregunta'],
        descripcion = json['desc'],
        base64Image = json['image'];

  Map toJson() {
    return {
      'id': id,
      'pregunta': pregunta,
      'desc': descripcion,
      'image': base64Image
    };
  }
}

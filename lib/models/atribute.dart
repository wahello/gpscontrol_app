class Atribute {
  String name;
  String value;
  Atribute({this.name, this.value});


  Atribute.fromJson(Map json)
      : name = json['n'],
      value = json['v'];

  Map toJson() {
    return {
      'name': name,
      'value':value
    };
  }
}

class Intervalo {
  String name;
  String desc;
  int iK;
  int iD;
  int iH;
  int pm;
  int pt;
  int pe;
  int c;
  String value;
  Intervalo({this.name, this.desc, this.iK, this.iD, this.iH, this.pm, this.pt, this.pe, this.c});


  Intervalo.fromJson(Map json)
      : name = json['n'],
      value = json['v'];

  Map toJson() {
    return {
      'name': name,
      'value':value
    };
  }

  calculateInterval(){
    if(this.iK==0){
      if(this.iD==0){
        //es un intervalo de Horas
        var horas = this.iH;
        this.value = "Cada $horas horas"; 
      }else{
        //Es un intervalo de Dias
        var dias = this.iD;
        var val = this.pt;
        var nDias = dias * 86400;
        var nVal = (val + nDias)*1000;
        var hoy = new DateTime.now().millisecondsSinceEpoch;
        var res = (nVal - hoy)/86400000;
        var aux = res.round();
        if(aux>0){
          this.value = "Aun quedan menos de $aux dias.";
        }else{
          this.value = "Vencio hace $aux dias.";
        }
        
      }

    }else{
      //es un intervalo Kilometraje
      var km = this.pm;
      var inter = this.iK;
      this.value = 'Cada $inter . Ultimo cambio $km ';
    }
  }
}

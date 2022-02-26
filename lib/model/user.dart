

class User{
  int? id;
  String? name;
  String? dept;
  int? phone;

  //User({this.id, this.name, this.dept, this.phone});
  User({this.id, required this.name});

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    /*dept: json['dept'],
    phone: json['phone'],*/
  );
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
     /* 'dept': dept,
      'phone': phone*/
    };
  }

}
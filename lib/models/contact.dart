class Contact{
  String id;
  String userID;
  String names;
  String phoneNumber;
  String relationship;

  Contact({this.id,this.userID,this.names,this.phoneNumber,this.relationship});
  
  Contact.fromMap(Map snapshot,String id ):
   id=id ?? '',
   userID=snapshot['userID'] ?? '',
   names=snapshot['names']??'',
   relationship=snapshot['relationship']??'',
   phoneNumber=snapshot['phoneNumber']??'';

   toJson(){
     return {
       "id":id,
       "names":names,
       "userID":userID,
       "phoneNumber":phoneNumber,
       "relationship":relationship
     };
   }

}
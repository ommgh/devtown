class AppwriteContants {
  static const String databaseID = "647c6bc3d7f483aa9967";
  static const String projectID = "647c697a8ea533486648";
  static const String endPoint = "https://cloud.appwrite.io/v1";
  static const String userCollection = "647dc52b02f4722ce02a";
  static const String postCollection = "6480ba959d04f18a751b";
  static const String notificationCollection = "648998302e7df03976bc";
  static const String imagesBucket = "64815a2032f6420147bf";
  static String imageurl(String imageId) =>
      "$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectID&mode=admin";
}

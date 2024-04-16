// Google SSO returns an image that is too small and becomes pixelated.
// Based on the url we change the size in order to request a better quality image
String increaseImageQualityOfGoogleImage(String url) {
  final imageSizeRegex = RegExp(r's\d*-c');
  final newUrl = url.replaceFirst(imageSizeRegex, 's500-c');
  return newUrl;
}
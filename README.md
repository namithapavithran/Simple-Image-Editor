# Simple-Image-Editor
Image editor capabilities
1. Open - from document files and photos library
2. save - to document files and photos library
3. crop
4. flip vertical and horizontal
5. show Exif information.

Classes

ViewController - View controller for first page. It is a delegate to ImagePickerDelegate and DocumentPickerDelegate.
ImagePicker - handles image picking and saving from photos library
ProjectDocumentPicker - handles image picking and saving from files.
OverlayviewController - child view controller of ViewController to show Exif info as overlay.

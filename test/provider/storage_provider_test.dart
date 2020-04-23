import 'package:flutter_clb_tinhban_ui_app/provider/storage_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock/IO_mock.dart';
import '../mock/firebase_mock.dart';

void main() {
  group('StorageProvider', () {
    FirebaseStorageMock firebaseStorageMock = FirebaseStorageMock();
    StorageReferenceMock storageReferenceMock = StorageReferenceMock();
    StorageReferenceMock rootReference =
        StorageReferenceMock(childReference: storageReferenceMock);
    StorageReferenceMock fileReference = StorageReferenceMock();
    StorageUploadTaskMock storageUploadTaskMock = StorageUploadTaskMock();
    StorageTaskSnapShotMock storageTaskSnapShotMock = StorageTaskSnapShotMock();
    String resultUrl = "http://www.adityag.me/";
    StorageProvider storageProvider =
        StorageProvider(firebaseStorage: firebaseStorageMock);
    MockFile mockFile=MockFile();

    /* StorageReference reference = firebaseStorage.ref().child(path);
        StorageUploadTask uploadTask=reference.putFile(file);
        StorageTaskSnapshot result= await uploadTask.onComplete;
        String url= await result.ref.getDownloadURL();
        return url;
    * */
    test('Testing if upload returl a url', () async {
      when(firebaseStorageMock.ref()).thenReturn(rootReference);
      when(storageReferenceMock.putFile(any)).thenReturn(storageUploadTaskMock);
      when(storageUploadTaskMock.onComplete).thenAnswer((_) =>
          Future<StorageTaskSnapShotMock>.value(storageTaskSnapShotMock));
      when(storageTaskSnapShotMock.ref).thenReturn(fileReference);
      when( fileReference.getDownloadURL()).thenAnswer((_)=>Future<String>.value(resultUrl));
      expect( await storageProvider.uploadFile(mockFile, ''),resultUrl);
    });
  });
}

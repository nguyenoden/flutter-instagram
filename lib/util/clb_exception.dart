abstract class ClbException implements Exception {
  String errorMessage();

}
class UserNotException extends ClbException{
  @override
  String errorMessage() {
    // TODO: implement errorMessage
    return 'No user found for provide uid/username';
  }

}
class UsernamMappingUndefinedException extends ClbException{
  @override
  String errorMessage() {
    // TODO: implement errorMessage
    return 'User not found';
  }

}
class ContactAlreadyExistsException extends ClbException{
  @override
  String errorMessage() {
    // TODO: implement errorMessage
    return 'Contact already exists';
  }

}

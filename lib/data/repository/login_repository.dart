import 'dart:io';

import 'package:bloc_structure/configuration/app_logger.dart';
import 'package:bloc_structure/configuration/local_storage.dart';
import 'package:bloc_structure/data/app_api_exception.dart';
import 'package:bloc_structure/data/models/send_otp_request.dart';
import 'package:bloc_structure/data/models/verify_otp_request.dart';

import '../http_utils.dart';
import '../models/jwt_token.dart';
import '../models/user_jwt.dart';

class LoginRepository {
  static final _log = AppLogger.getLogger("LoginRepository");

  LoginRepository();

  Future<JWTToken?> authenticate(UserJWT userJWT) async {
    _log.debug("BEGIN:authenticate repository start username: {}", [userJWT.username]);
    JWTToken? result;
    if (userJWT.username == null || userJWT.username!.isEmpty || userJWT.password == null || userJWT.password!.isEmpty) {
      throw BadRequestException("Invalid username or password");
    }

    final response = await HttpUtils.postRequest<UserJWT>("/authenticate", userJWT);
    result = JWTToken.fromJsonString(response.body);
    _log.debug("END:authenticate successful - response.body: {}", [result.toString()]);
    return result;
  }

  Future<void> logout() async {
    _log.debug("BEGIN:logout repository start");
    await AppLocalStorage().clear();
    _log.debug("END:logout successful");
  }

  Future<void> sendOtp(SendOtpRequest request) async {
    _log.debug("BEGIN:sendOtp repository start email: {}", [request.email]);
    if (request.email.isEmpty) {
      throw BadRequestException("Invalid email");
    }
    final headers = {"Content-Type": "application/json"};
    final response = await HttpUtils.postRequest<SendOtpRequest>("/authenticate/send-otp", request, headers: headers);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw BadRequestException(response.body);
    }
    _log.debug("successful response: {}", [response.body]);
    _log.debug("END:sendOtp successful");
  }

  Future<JWTToken?> verifyOtp(VerifyOtpRequest request) async {
    _log.debug("BEGIN:verifyOtp repository start email: {}", [request.email]);
    if (request.email.isEmpty || request.otp.isEmpty) {
      throw BadRequestException("Invalid email or OTP");
    }

    if (request.otp.length != 6) {
      throw BadRequestException("Invalid OTP");
    }

    final headers = {"Content-Type": "application/json"};
    final response = await HttpUtils.postRequest<VerifyOtpRequest>("/authenticate/verify-otp", request, headers: headers);
    return JWTToken.fromJsonString(response.body);
  }
}

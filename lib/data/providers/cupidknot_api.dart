import 'package:cupid_test/data/models/user.dart';
import 'package:cupid_test/data/providers/shared_prefs.dart';
import 'package:dio/dio.dart';

class CupidKnotAPI extends BaseService {
  Future<Response?> signIn({String? email, String? password}) async {
    final response = await request(
      endpoint: 'login',
      data: FormData.fromMap(
        <String, Object?>{'email': email, 'password': password},
      ),
      requestType: RequestType.POST,
    ) as Response;

    return response;
  }

  Future<Response?> register(
      {String? name,
      String? password,
      String? email,
      String? confirmPassword,
      String? dob,
      String? gender,
      String? phoneNo}) async {
    final response = await request(
      endpoint: 'register',
      data: FormData.fromMap(<String, Object?>{
        'full_name': name,
        'email': email,
        'mobile_no': phoneNo,
        'password': password,
        'c_password': confirmPassword,
        'gender': gender,
        'dob': dob,
      }),
      requestType: RequestType.POST,
    ) as Response;

    return response;
  }

  Future<bool?> editProfile({required Profile profile}) async {
    final status = await edit(
      data: FormData.fromMap(<String, Object?>{
        'full_name': profile.fullName,
        'mobile_no': profile.mobileNo,
        'gender': profile.gender,
        'dob': profile.dob,
      }),
    );
    return status;
  }

  Future<bool?> edit({dynamic data}) async {
    final response = await request(
      endpoint: 'updateProfileDetails',
      data: data,
      requestType: RequestType.POST,
    ) as Response;
    print(response.data);
    final status = response.data['success'] as bool;
    return status;
  }
}

enum RequestType { GET, POST, PUT, DELETE }

class BaseService {
  final Dio _dio = Dio();

  Future<dynamic> request(
      {RequestType? requestType, dynamic data, String? endpoint}) async {
    _dio.interceptors.add(HeaderInterceptor());
    Response? _response;
    try {
      switch (requestType) {
        case RequestType.GET:
          _response = await _dio.get<void>(endpoint!);
          break;
        case RequestType.POST:
          _response = await _dio.post<void>(
            endpoint!,
            data: data,
          );
          break;
        case RequestType.PUT:
          _response = await _dio.put<void>(endpoint!, data: data);
          break;
        case RequestType.DELETE:
          _response = await _dio.delete<void>(endpoint!);
          break;
        default:
          break;
      }
    } on DioError catch (e) {
      print(e);
    }
    return _response;
  }
}

class HeaderInterceptor extends InterceptorsWrapper {
  HeaderInterceptor({SharedPrefsClient? sharedPrefsClient})
      : _sharedPrefsClient = sharedPrefsClient ?? SharedPrefsClient();
  final SharedPrefsClient _sharedPrefsClient;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.baseUrl = 'http://flutter-intern.cupidknot.com/api/';
    final token = await _sharedPrefsClient.getToken();
    if (token != null) {
      print('token <====================> $token');
      options.headers['authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

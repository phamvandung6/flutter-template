import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Generic API response wrapper for consistent response handling
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
    this.errorCode,
    this.errorDetails,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  /// Factory for successful response
  factory ApiResponse.success({
    required T data,
    String? message,
    int? statusCode,
    Map<String, dynamic>? meta,
  }) =>
      ApiResponse(
        success: true,
        data: data,
        message: message,
        statusCode: statusCode,
        meta: meta,
      );

  /// Factory for error response
  factory ApiResponse.error({
    required String message,
    String? errorCode,
    Map<String, dynamic>? errorDetails,
    int? statusCode,
    Map<String, dynamic>? meta,
  }) =>
      ApiResponse(
        success: false,
        message: message,
        errorCode: errorCode,
        errorDetails: errorDetails,
        statusCode: statusCode,
        meta: meta,
      );
  final bool success;
  final String? message;
  final T? data;

  @JsonKey(name: 'status_code')
  final int? statusCode;

  @JsonKey(name: 'error_code')
  final String? errorCode;

  @JsonKey(name: 'error_details')
  final Map<String, dynamic>? errorDetails;

  @JsonKey(name: 'meta')
  final Map<String, dynamic>? meta;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// Check if response has data
  bool get hasData => data != null;

  /// Check if response is error
  bool get isError => !success;

  /// Get data or throw if error
  T get dataOrThrow {
    if (isError) {
      throw Exception(message ?? 'API request failed');
    }
    return data!;
  }
}

/// Paginated response wrapper
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {

  const PaginatedResponse({
    required this.data,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);
  final List<T> data;
  final PaginationMeta meta;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);

  /// Check if has more pages
  bool get hasNextPage => meta.hasNextPage;

  /// Check if has previous pages
  bool get hasPreviousPage => meta.hasPreviousPage;

  /// Get total count
  int get totalCount => meta.totalCount;
}

/// Pagination metadata
@JsonSerializable()
class PaginationMeta {

  const PaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.totalPages,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'per_page')
  final int perPage;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  @JsonKey(name: 'total_count')
  final int totalCount;

  @JsonKey(name: 'has_next_page')
  final bool hasNextPage;

  @JsonKey(name: 'has_previous_page')
  final bool hasPreviousPage;

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}

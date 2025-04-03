import 'package:FlutChat/features/chat/repositories/chat_provider.dart';
import 'package:FlutChat/models/search_result_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = StreamProvider<List<SearchResultModel>>((ref) {
  final query = ref.watch(searchProvider);

  if (query.trim().isEmpty) return Stream.value([]);
  final chatRepository = ref.read(chatRepositoryProvider);
  return chatRepository.searchUsers(query);
});

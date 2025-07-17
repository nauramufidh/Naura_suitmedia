import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  List<dynamic> users = [];
  int page = 1;
  int totalPages = 2;
  bool isLoading = false;
  bool isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (isLoading) return;

    if (isRefresh) {
      page = 1;
      setState(() {
        isRefreshing = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }

    final url = 'https://reqres.in/api/users';
    print('Fetching: $url');

    final response = await http.get(Uri.parse(url));
    print('Response code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fetchedUsers = data['data'];
      print('Fetched users: $fetchedUsers');
      totalPages = data['total_pages'];

      setState(() {
        if (isRefresh) {
          users = fetchedUsers;
        } else {
          users.addAll(fetchedUsers);
        }
        page++;
      });
    } else {
      print('Failed to fetch users');
    }

    setState(() {
      isLoading = false;
      isRefreshing = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (page <= totalPages && !isLoading) {
        fetchUsers();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildUserItem(Map<String, dynamic> user) {
    final fullName = '${user['first_name']} ${user['last_name']}';
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, fullName);
      },
      child: Align(
        alignment: Alignment.center,

        child: Container(
          width: 400,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
            ),
          ),

          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(user['avatar']),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      user['email'],
                      style: const TextStyle(
                        fontSize: 14, color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Third Screen')),
      body: RefreshIndicator(
        onRefresh: () => fetchUsers(isRefresh: true),
        child: users.isEmpty && !isLoading
            ? const Center(child: Text('No users found.'))
            : ListView.builder(
          controller: _scrollController,
          itemCount: users.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < users.length) {
              return buildUserItem(users[index]);
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
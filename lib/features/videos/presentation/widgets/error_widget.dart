import 'package:flutter/material.dart';

class VideoErrorWidget extends StatelessWidget {
  final String? error;

  const VideoErrorWidget({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Xatolik yuz berdi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            error ?? 'Videolarni yuklashda muammo',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                ),
              );
            },
            child: Text('Qayta urinish'),
          ),
        ],
      ),
    );
  }
}

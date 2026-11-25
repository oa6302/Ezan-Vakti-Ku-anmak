import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/theme.dart';
import '../../app/shadows.dart';

class ReadingPlanPage extends StatefulWidget {
  const ReadingPlanPage({super.key});

  @override
  State<ReadingPlanPage> createState() => _ReadingPlanPageState();
}

class _Book {
  final String id;
  final String title;
  final String type;
  final int totalPages;
  int readPages;
  String notes;
  DateTime? lastReadDate;

  _Book({
    required this.id,
    required this.title,
    required this.type,
    required this.totalPages,
    this.readPages = 0,
    this.notes = '',
    this.lastReadDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'totalPages': totalPages,
        'readPages': readPages,
        'notes': notes,
        'lastReadDate': lastReadDate?.toIso8601String(),
      };

  factory _Book.fromJson(Map<String, dynamic> json) => _Book(
        id: json['id'],
        title: json['title'],
        type: json['type'] ?? 'Diğer',
        totalPages: json['totalPages'],
        readPages: json['readPages'] ?? 0,
        notes: json['notes'] ?? '',
        lastReadDate: json['lastReadDate'] != null
            ? DateTime.parse(json['lastReadDate'])
            : null,
      );
}

class _ReadingPlanPageState extends State<ReadingPlanPage> {
  List<_Book> _books = [];
  bool _isLoading = true;

  final List<String> _bookTypes = [
    'Kur\'an-ı Kerim',
    'Risale-i Nur',
    'Hadis Kitabı',
    'Genel Kitap'
  ];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStr = prefs.getString('reading_books');
    if (savedStr != null) {
      final List decoded = jsonDecode(savedStr);
      _books = decoded.map((e) => _Book.fromJson(e)).toList();
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(_books.map((e) => e.toJson()).toList());
    await prefs.setString('reading_books', str);
  }

  void _addBook() {
    final titleCtrl = TextEditingController();
    final pagesCtrl = TextEditingController();
    String selectedType = _bookTypes[3];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: kKartYuzeyi,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text('Yeni Okuma Planı Ekle',
                style: TextStyle(
                    color: kAnaLacivert, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Eser / Kitap Adı',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: pagesCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Toplam Sayfa Sayısı',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Kitap Türü',
                      style: TextStyle(fontSize: 14, color: kIkincilMetin)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _bookTypes.map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: selectedType == type,
                        onSelected: (val) =>
                            setDialogState(() => selectedType = type),
                        selectedColor: kZarifBordo.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: selectedType == type
                              ? kZarifBordo
                              : kIkincilMetin,
                          fontWeight: selectedType == type
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text('İptal', style: TextStyle(color: kIkincilMetin)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kZarifBordo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  if (titleCtrl.text.isNotEmpty && pagesCtrl.text.isNotEmpty) {
                    setState(() {
                      _books.add(_Book(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleCtrl.text,
                        type: selectedType,
                        totalPages: int.tryParse(pagesCtrl.text) ?? 100,
                      ));
                    });
                    _saveBooks();
                    Navigator.pop(context);
                  }
                },
                child:
                    const Text('Ekle', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateProgress(_Book book, int pagesToAdd) {
    setState(() {
      book.readPages += pagesToAdd;
      if (book.readPages > book.totalPages) {
        book.readPages = book.totalPages;
      }
      if (book.readPages < 0) {
        book.readPages = 0;
      }
      book.lastReadDate = DateTime.now();
    });
    _saveBooks();
  }

  void _editNotes(_Book book) {
    final notesCtrl = TextEditingController(text: book.notes);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kKartYuzeyi,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('${book.title} - Notlar',
            style: const TextStyle(color: kAnaLacivert, fontSize: 18)),
        content: TextField(
          controller: notesCtrl,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Kaldığın yer, önemli bir cümle veya çıkarım...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: kIkincilMetin)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kZarifBordo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              setState(() {
                book.notes = notesCtrl.text;
              });
              _saveBooks();
              Navigator.pop(context);
            },
            child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
          backgroundColor: kArkaPlan,
          body: Center(child: CircularProgressIndicator(color: kZarifBordo)));
    }

    return Scaffold(
      backgroundColor: kArkaPlan,
      appBar: AppBar(
        title: const Text('Okuma Planım',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kKartYuzeyi,
        foregroundColor: kAnaLacivert,
        elevation: 0,
      ),
      body: _books.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book_rounded,
                      size: 72, color: kKenarlik),
                  const SizedBox(height: 16),
                  const Text('Henüz bir okuma planın yok.',
                      style: TextStyle(
                          fontSize: 18,
                          color: kIkincilMetin,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Küçük adımlar, düzenli bir gelişim getirir.',
                      style: TextStyle(fontSize: 14, color: kYardimciMetin)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _addBook,
                    icon: const Icon(Icons.add),
                    label: const Text('İlk Kitabını Ekle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kZarifBordo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  )
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                double progress =
                    book.totalPages == 0 ? 0 : book.readPages / book.totalPages;
                bool isCompleted = progress >= 1.0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: kKartYuzeyi,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppShadows.medium(),
                    border: Border.all(
                        color: isCompleted
                            ? kBasariYesili.withValues(alpha: 0.5)
                            : kKenarlik,
                        width: isCompleted ? 1.5 : 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: kZarifBordo.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                book.type,
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: kZarifBordo),
                              ),
                            ),
                            Row(
                              children: [
                                if (isCompleted)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.check_circle_rounded,
                                        color: kBasariYesili, size: 20),
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: kYardimciMetin, size: 20),
                                  onPressed: () {
                                    setState(() => _books.removeAt(index));
                                    _saveBooks();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(book.title,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: kAnaMetin)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${book.readPages} / ${book.totalPages} Sayfa',
                                style: const TextStyle(
                                    color: kIkincilMetin,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                            Text('%${(progress * 100).round()}',
                                style: TextStyle(
                                    color: isCompleted
                                        ? kBasariYesili
                                        : kZarifBordo,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: kArkaPlan,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                isCompleted ? kBasariYesili : kZarifBordo),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (book.lastReadDate != null)
                              Text(
                                'Son okuma: ${book.lastReadDate!.day}.${book.lastReadDate!.month}.${book.lastReadDate!.year}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: kYardimciMetin,
                                    fontStyle: FontStyle.italic),
                              ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => _editNotes(book),
                              icon: const Icon(Icons.edit_note_rounded,
                                  size: 18, color: kAnaTurkuaz),
                              label: Text(
                                  book.notes.isEmpty
                                      ? 'Not Ekle'
                                      : 'Notları Gör',
                                  style: const TextStyle(
                                      fontSize: 12, color: kAnaTurkuaz)),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: kArkaPlan,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () => _updateProgress(book, -5),
                                icon: const Icon(Icons.remove, size: 20),
                                style: IconButton.styleFrom(
                                    backgroundColor: kKartYuzeyi, elevation: 1),
                              ),
                              const Text('-5 Sayfa',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: kIkincilMetin,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              const Text('+10 Sayfa',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: kZarifBordo,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: () => _updateProgress(book, 10),
                                icon: const Icon(Icons.add, size: 20),
                                style: IconButton.styleFrom(
                                    backgroundColor: kKartYuzeyi, elevation: 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _books.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _addBook,
              backgroundColor: kZarifBordo,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Yeni Kitap',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }
}

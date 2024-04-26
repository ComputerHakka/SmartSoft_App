import 'package:flutter/material.dart';
import 'package:smartsoft_application/models/user.dart';

class CompleteOrderPage extends StatelessWidget {
  final UserModel user;
  const CompleteOrderPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: user.id!.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.task_alt_rounded,
                        color: Colors.green,
                        size: 80,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Заказ успешно оформлен!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Информацию о заказе можно найти\nв профиле в разделе\n"Мои заказы"',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Отлично'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.archive,
                        color: Colors.blue,
                        size: 80,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Заказ передан в обработку',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'При успешной обработке на ваш\nEmail адрес поступит информация\nо заказе',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Отлично'),
                      ),
                    ],
                  ),
          )),
    );
  }
}

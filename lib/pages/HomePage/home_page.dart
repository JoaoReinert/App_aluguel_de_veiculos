import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CustomerRegistrationPage/customer_registration_page.dart';
import '../ManagersRegisterPage/managers_register_page.dart';
import '../RentsPage/rents_page.dart';
import '../VehicleRegistrationPage/vehicle_registration_page.dart';

///criacao do provider da home page para passar as funcoes de navegacao
class HomeState extends ChangeNotifier {
  ///variavel referente a pagina atual
  int currentPage = 0;

  ///controle para o slider
  late PageController pc;

  ///inicializando o controlador
  HomeState() {
    pc = PageController(initialPage: currentPage);
  }

  ///funcao para quando o usuario clicar no icon da pagina desejada
  ///o icon mudar de cor
  void setCurrentPage(int page) {
    currentPage = page;
    pc.jumpToPage(page);
    notifyListeners();
  }
}

///criacao da home page para ultilizar o bottom navigation bar
class HomePage extends StatelessWidget {
  ///instancia da classe
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print(
      'Theme.of(context).bottomNavigationBarTheme.backgroundColor: ${Theme.of(context).bottomNavigationBarTheme.backgroundColor}',
    );

    return ChangeNotifierProvider(
      create: (_) => HomeState(),
      child: Consumer<HomeState>(
        builder: (_, state, __) {
          return Scaffold(
            body: PageView(
              controller: state.pc,
              onPageChanged: (page) => state.setCurrentPage(page),
              children: const [
                CustomerRegistrationPage(),
                ManagersRegisterPage(),
                VehicleRegistrationPage(),
                RentsPage(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: state.currentPage,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Customers',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.work), label: 'Managers'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.directions_car), label: 'Vehicles'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contact_page), label: 'Rents'),
              ],
              onTap: (page) {
                state.setCurrentPage(page);
              },
            ),
          );
        },
      ),
    );
  }
}

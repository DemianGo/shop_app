import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
          
        ),

        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) =>  Products('','', []),
          // create: (ctx, auth, previousProducts) =>  updateProv(
          // auth.token,
          // auth.userId,
          // previousProducts == null ? [] : previousProducts.items,
          // ),
          update: (context, auth, previous) => previous..updateProv(auth.token, auth.userId),
        ),

        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Shop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnaphot) => authResultSnaphot
                                .connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen() // enquanto espera o waiting acima, mostra essa
                        : AuthScreen(), // depois da espera, mostra essa
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            }),
      ),
    );
  }
}

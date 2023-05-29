import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

const partnerScreenRoute = '/partner';

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Partner'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {},
          child: ResponsiveGridView.builder(
            gridDelegate: const ResponsiveGridDelegate(
                minCrossAxisExtent: 200,
                childAspectRatio: 1.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8),
            itemBuilder: ((context, index) {
              return Card(
                child: InkWell(
                  onTap: () {
                    GoRouter.of(
                      context,
                    ).push('/partner/$index');
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://picsum.photos/200/300?random=$index'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sevrent Oy - Kodin Remontti',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            itemCount: 3,
          ),
        ));
  }
}

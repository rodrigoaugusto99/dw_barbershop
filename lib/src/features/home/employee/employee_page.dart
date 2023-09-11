import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/home/employee/home_employee_provider.dart';
import 'package:dw_barbershop/src/features/home/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/constants.dart';
import '../../../core/ui/widgets/avatar_widget.dart';
import '../../../model/user_model.dart';

class EmployeePage extends ConsumerWidget {
  const EmployeePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);

    return Scaffold(
      body: userModelAsync.when(
        error: ((error, stackTrace) {
          return const Center(
            child: Text('Erro ao caregar pagina'),
          );
        }),
        loading: () => const BarbershopLoader(),
        data: (user) {
          final UserModel(:id, :name) = user;
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader(
                  hideFilter: true,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      AvatarWidget(
                        hideUploadButton: true,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        height: 108,
                        decoration: BoxDecoration(
                            border: Border.all(color: ColorsConstants.grey),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer(builder: (context, ref, child) {
                              final totalAsync =
                                  ref.watch(getTotalSchedulesTodayProvider(id));
                              return totalAsync.when(
                                error: ((error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                        'Erro ao caregar total de agendamentos'),
                                  );
                                }),
                                loading: () => const BarbershopLoader(),
                                skipLoadingOnRefresh: false,
                                data: (totalSchedule) {
                                  return const Text(
                                    '5',
                                    style: TextStyle(
                                      color: ColorsConstants.brown,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              );
                            }),
                            const Text(
                              'hoje',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () async {
                          await Navigator.of(context)
                              .pushNamed('/schedule', arguments: user);
                          ref.invalidate(getTotalSchedulesTodayProvider);
                        },
                        child: const Text('Agendar cliente'),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/employee/schedule', arguments: user);
                        },
                        child: const Text('Ver agenda'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/barbershop_icons.dart';
import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/home/adm/home_adm_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  final bool showFilter;
  const HomeHeader({super.key, this.showFilter = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barbershop = ref.watch(getMyBarbershopProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(30),
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        color: Colors.black,
        image: DecorationImage(
            image: AssetImage(ImageConstants.backgroundChair),
            fit: BoxFit.cover,
            opacity: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          barbershop.maybeWhen(
            data: (barbershopData) {
              return Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xffbdbdbd),
                    child: SizedBox.shrink(),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Text(
                      barbershopData.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Expanded(
                    child: Text(
                      'editar',
                      style: TextStyle(
                        color: ColorsConstants.brown,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(homeAdmVmProvider.notifier).logout();
                    },
                    icon: const Icon(
                      BarbershopIcons.exit,
                      color: ColorsConstants.brown,
                      size: 32,
                    ),
                  ),
                ],
              );
            },
            orElse: () {
              return const Center(
                child: BarbershopLoader(),
              );
            },
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Bem Vindo',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Agende um cliente',
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Offstage(
            offstage: !showFilter,
            child: const SizedBox(
              height: 24,
            ),
          ),
          Offstage(
            offstage: !showFilter,
            child: TextFormField(
              decoration: const InputDecoration(
                label: Text('Buscar colaborador'),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 24.0),
                  child: Icon(
                    BarbershopIcons.search,
                    color: ColorsConstants.brown,
                    size: 26,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

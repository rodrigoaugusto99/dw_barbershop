import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/barbershop_icons.dart';
import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/home/adm/home_adm_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*para usar acessar um provedor em um Stateless, tambem
precisará transformar em COnsumer, mas como nao tem estado,
nao tem onde disponibilizar o ref sem precisar alterar o build.
Mas aqui, precisaremos, entao colocaremos o WidgetRef no build*/
class HomeHeader extends ConsumerWidget {
  /*booleando hideFilter pra fazer a logica de esconder o 
  textfield usando offstage dependendo de onde ele é instanciado*/
  final bool hideFilter;
  const HomeHeader({super.key, this.hideFilter = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*Esse widget precisa das informacoes da barbearia, 
    entao trazer o provider que recuperar esses dados. */
    final barbershop = ref.watch(getMyBarbershopProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(30),
      //tamanho total da tela(atualiza quando alterar o tamanho da tela)
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
      //varios widgets dentro do header
      child: Column(
        /*Column é de cima pra baixo, entao a referencia
        é vertical, o main é vertical. Se queremos arrumar
        na horizontal, entao pegamos o cross, que é 
        o inverso do main */
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*maybeWhen - deixa opcional os atributos, 
          e deixar um orElse. ou seja, eu posso apenas
          implementar o data , e o loading e error fica
          lá no orElse
          -colocar o loader no orElse*/
          barbershop.maybeWhen(
            //data - recebe o valor barbershopData(cuidado p n ter o mesmo nome da instancia)
            data: (barbershopData) {
              return Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xffbdbdbd),
                    //só p ter algo dentro dele
                    child: SizedBox.shrink(),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  //flexivel, mas nao expandido
                  Flexible(
                    child: Text(
                      //tras as informacoes do estado
                      barbershopData.name,
                      //cortado
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
                  //aqui expandir, empurra o nome pra esquerda e o icone p direita
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
                      //chama a instancia do provider(notifier) e o metodo
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
            offstage: !hideFilter,
            child: const SizedBox(
              height: 24,
            ),
          ),
          Offstage(
            offstage: !hideFilter,
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

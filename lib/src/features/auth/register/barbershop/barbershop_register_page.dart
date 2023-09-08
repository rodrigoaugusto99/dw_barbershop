import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/widgets/weekdays_panel.dart';
import 'package:dw_barbershop/src/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/ui/helpers/messages.dart';
import '../../../../core/ui/widgets/hours_panel.dart';
import 'barbershop_register_vm.dart';

//4 - registrar na vm, buscando o repository

/*2 - pra tela acessar o container, os widgets do riverpod para
ter acesso à referencia do provier, precisamos usar COnsumer */
class BarbershopRegisterPage extends ConsumerStatefulWidget {
  const BarbershopRegisterPage({super.key});

  @override
  ConsumerState<BarbershopRegisterPage> createState() =>
      _BarbershopRegisterPageState();
}

class _BarbershopRegisterPageState
    extends ConsumerState<BarbershopRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //1 - pegando a instancia do vm. (sem notifier é instancia do estado)
    final barbershopRegisterVM =
        ref.watch(barbershopRegisterVmProvider.notifier);

//5 - escuta o vmProvvider(sem notifier, agora queremos o estado)
//(_, state) - importa só o estao atual, nao o anterior
//
    ref.listen(barbershopRegisterVmProvider, (_, state) {
      switch (state.status) {
        case BarbershopRegisterStateStatus.initial:
          break;
        case BarbershopRegisterStateStatus.error:
          Messages.showError(
              'Desculpe, ocorreu um erro ao registrar barbearia', context);
        case BarbershopRegisterStateStatus.success:
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/adm', (route) => false);
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Cadastrar estabelecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: nameEC,
                  validator: Validatorless.required('Nome obrigatorio'),
                  onTapOutside: (_) => unfocus(context),
                  decoration: const InputDecoration(
                    label: Text('Nome'),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Email obrigatorio'),
                    Validatorless.email('Email invalido'),
                  ]),
                  onTapOutside: (_) => unfocus(context),
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                /*Chama o Weekdays passando o onDayPressed que recebeu a variavel
                clicada (label) 
                - a partir dai, pode fazer o que quiser com essa variavel recebida.
                -depois eu me viro para adicionar OU NAO na minha lista*/
                WeekdaysPanel(
                  onDayPressed: (value) {
                    /*3 - adicionando ou removendo os valores que vieram do 
                    valueChanged(label)*/
                    barbershopRegisterVM.addOrRemoveOpenDay(value);
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                HoursPanel(
                  startTime: 6,
                  endTime: 23,
                  /*3 - ADICIONANDO E REMOVENDO DO ESTADO OS ELEMENTOS */
                  onHourPressed: (int value) {
                    barbershopRegisterVM.addOrRemoveOpenHour(value);
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                //agr pra mandar pro vm, precisa fazer a construçao
                //p receber os dados(controllers, formulario)
                ElevatedButton(
                  onPressed: () {
                    switch (formKey.currentState?.validate()) {
                      case false || null:
                        Messages.showError('Formulario invalido', context);
                      case true:
                        barbershopRegisterVM.register(
                            nameEC.text, emailEC.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56)),
                  child: const Text('cadastrar estabelecimento'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

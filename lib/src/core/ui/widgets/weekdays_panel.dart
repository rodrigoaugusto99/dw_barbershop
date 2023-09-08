// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dw_barbershop/src/core/ui/constants.dart';

class WeekdaysPanel extends StatelessWidget {
  final List<String>? enableDays;
  //2.1 - precisamos receber aqui pois é parametro do ButtonDay(que é chamado aqui)
  final ValueChanged<String> onDayPressed;

  const WeekdaysPanel({
    super.key,
    required this.onDayPressed,
    this.enableDays,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione os dias da semana',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 16,
          ),
          //rolagem caso dispositivo pequeno
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonDay(
                  label: 'Seg',
                  //2.1
                  onDayPressed: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Ter',
                  onDayPressed: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Qua',
                  onDayPressed: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Qui',
                  onDayPressed: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Sex',
                  onDayPressed: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Sab',
                  onDayPressed: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Dom',
                  onDayPressed: onDayPressed,
                  enableDays: enableDays,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//stateful pois teremos que atualizar o botao selecionado
//pois teremos que guardar estado dentro dele
class ButtonDay extends StatefulWidget {
  final List<String>? enableDays;
  final String label;
  //2 - método callback, vai ser chamado quando eu selecionar
  final ValueChanged<String> onDayPressed;

  const ButtonDay({
    super.key,
    required this.label,
    required this.onDayPressed,
    this.enableDays,
  });

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  //1 - variavel de estado
  var selected = false;
  @override
  Widget build(BuildContext context) {
    //1 - variaveis esteticas que mudam com o clique
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brown : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brown : ColorsConstants.grey;

    final ButtonDay(:enableDays, :label) = widget;

    final disableDay = enableDays != null && !enableDays.contains(label);

    if (disableDay) {
      buttonColor = Colors.grey[400]!;
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: disableDay
            ? null
            : () {
                //no onTap do botao que inverte o estado dele
                setState(() {
                  //2 - chamar a função callback quando clicar
                  //2- passando o label(widget.label)
                  widget.onDayPressed(label);
                  //1- toggle
                  selected = !selected;
                });
              },
        child: Container(
          width: 40,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            //1- variavel estetica
            color: buttonColor,
            //1 - variavel estetica
            border: Border.all(color: buttonBorderColor),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                //1- variavel estetica
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Tente Novamente`
  String get tryAgainButtonLabel {
    return Intl.message(
      'Tente Novamente',
      name: 'tryAgainButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Salvar`
  String get genericUpsertTaskButtonLabel {
    return Intl.message(
      'Salvar',
      name: 'genericUpsertTaskButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Lista vazia. Adicione novas tarefas`
  String get emptyListIndicatorMessage {
    return Intl.message(
      'Lista vazia. Adicione novas tarefas',
      name: 'emptyListIndicatorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Deu erro`
  String get errorIndicatorMessage {
    return Intl.message(
      'Deu erro',
      name: 'errorIndicatorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Adicionar tarefa`
  String get addTaskDialogTitle {
    return Intl.message(
      'Adicionar tarefa',
      name: 'addTaskDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Atualizar tarefa`
  String get updateTaskDialogTitle {
    return Intl.message(
      'Atualizar tarefa',
      name: 'updateTaskDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ação realizada com sucess`
  String get genericSuccessTaskSnackBarMessage {
    return Intl.message(
      'Ação realizada com sucess',
      name: 'genericSuccessTaskSnackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Tarefa adicionada com sucesso`
  String get addTaskSuccessSnackBarMessage {
    return Intl.message(
      'Tarefa adicionada com sucesso',
      name: 'addTaskSuccessSnackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Tarefa atualizada com sucesso`
  String get updateTaskSuccessSnackBarMessage {
    return Intl.message(
      'Tarefa atualizada com sucesso',
      name: 'updateTaskSuccessSnackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Tarefa removida com sucesso`
  String get removeTaskSuccessSnackBarMessage {
    return Intl.message(
      'Tarefa removida com sucesso',
      name: 'removeTaskSuccessSnackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Tarefas reordenadas com sucesso`
  String get reorderTasksSuccessSnackBarMessage {
    return Intl.message(
      'Tarefas reordenadas com sucesso',
      name: 'reorderTasksSuccessSnackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Alguma coisa deu errado`
  String get genericFailTaskSnackBarMessage {
    return Intl.message(
      'Alguma coisa deu errado',
      name: 'genericFailTaskSnackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Falha ao adicionar tarefa`
  String get addTaskFailSnackBarMessage {
    return Intl.message(
      'Falha ao adicionar tarefa',
      name: 'addTaskFailSnackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Falha ao atualizar tarefa`
  String get updateTaskFailSnackBarMessage {
    return Intl.message(
      'Falha ao atualizar tarefa',
      name: 'updateTaskFailSnackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Falha ao remover tarefa`
  String get removeTaskFailSnackBarMessage {
    return Intl.message(
      'Falha ao remover tarefa',
      name: 'removeTaskFailSnackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Falha ao reordenar tarefas`
  String get reorderTasksFailSnackBarMessage {
    return Intl.message(
      'Falha ao reordenar tarefas',
      name: 'reorderTasksFailSnackBarMessage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
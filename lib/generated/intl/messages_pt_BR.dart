// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_BR locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt_BR';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addTaskDialogTitle" : MessageLookupByLibrary.simpleMessage("Adicionar tarefa"),
    "addTaskSuccessSnackBarMessage" : MessageLookupByLibrary.simpleMessage("Tarefa adicionada com sucesso"),
    "emptyListIndicatorMessage" : MessageLookupByLibrary.simpleMessage("Lista vazia. Adicione novas tarefas"),
    "errorIndicatorMessage" : MessageLookupByLibrary.simpleMessage("Deu erro"),
    "genericFailTaskSnackBarMessage" : MessageLookupByLibrary.simpleMessage("Alguma coisa deu errado"),
    "genericUpsertTaskButtonLabel" : MessageLookupByLibrary.simpleMessage("Salvar"),
    "removeTaskFailSnackBarMessage" : MessageLookupByLibrary.simpleMessage("Falha ao remover tarefa"),
    "removeTaskSuccessSnackBarMessage" : MessageLookupByLibrary.simpleMessage("Tarefa removida com sucesso"),
    "tryAgainButtonLabel" : MessageLookupByLibrary.simpleMessage("Tente Novamente"),
    "updateTaskDialogTitle" : MessageLookupByLibrary.simpleMessage("Atualizar tarefa"),
    "updateTaskFailSnackBarMessage" : MessageLookupByLibrary.simpleMessage("Falha ao atualizar tarefa"),
    "updateTaskSuccessSnackBarMessage" : MessageLookupByLibrary.simpleMessage("Tarefa atualizada com sucesso")
  };
}

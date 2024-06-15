part of '../../flavio.dart';

class HtmlTableRenderer extends StatelessWidget {
  const HtmlTableRenderer({
    super.key,
    required this.table,
  });

  final HtmlTableElement table;

  @override
  Widget build(BuildContext context) {
    return Table(
      children: _rows(table).toList(growable: false),
    );
  }

  Iterable<TableRow> _rows(HtmlElement rowProvider) sync* {
    for (final node in rowProvider.children) {
      switch (node) {
        case final HtmlTrElement tr:
          yield _row(tr);
          break;
        case final HtmlTbodyElement tbody:
          yield* _body(tbody);
          break;
        case final HtmlTheadElement thead:
          yield* _head(thead);
          break;
        case final HtmlTfootElement tfoot:
          yield* _foot(tfoot);
          break;
        case final HtmlText textNode:
          if (textNode.text.trim().isEmpty) {
            continue;
          }

          throw UnimplementedError('Unexpected text node in table row: ${textNode.text}');
        default:
          throw UnimplementedError('Unsupported table row type: ${node.runtimeType}');
      }
    }
  }

  Iterable<TableRow> _body(HtmlTbodyElement tbody) sync* {
    yield* _rows(tbody);
  }

  Iterable<TableRow> _head(HtmlTheadElement thead) sync* {
    yield* _rows(thead);
  }

  Iterable<TableRow> _foot(HtmlTfootElement tfoot) sync* {
    yield* _rows(tfoot);
  }

  TableRow _row(HtmlTrElement tr) {
    return TableRow(
      children: _cells(tr).toList(growable: false),
    );
  }

  Iterable<TableCell> _cells(HtmlElement cellProvider) sync* {
    for (final node in cellProvider.children) {
      switch (node) {
        case final HtmlTdElement td:
          yield _cell(td);
          break;
        case final HtmlThElement th:
          yield _header(th);
          break;
        case final HtmlText textNode:
          if (textNode.text.trim().isEmpty) {
            continue;
          }

          throw UnimplementedError('Unexpected text node in table cell: ${textNode.text}');
        default:
          throw UnimplementedError('Unsupported table cell type: ${node.runtimeType}');
      }
    }
  }

  TableCell _cell(HtmlTdElement node) {
    return TableCell(
      child: HtmlNodesRenderer(nodes: node.children),
    );
  }

  TableCell _header(HtmlThElement node) {
    return TableCell(
      child: HtmlNodesRenderer(nodes: node.children),
    );
  }
}

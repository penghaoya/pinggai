import 'package:flutter/material.dart';

class FlexibleDataTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final List<ColumnConfig> columns;
  final double containerHeight;
  final double rowHeight;
  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color rowBackgroundColor;
  final Color borderColor;
  final double headerFontSize;

  const FlexibleDataTable({
    super.key,
    required this.data,
    required this.columns,
    this.containerHeight = 400,
    this.rowHeight = 40,
    this.headerBackgroundColor = Colors.grey,
    this.headerTextColor = Colors.white,
    this.rowBackgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.headerFontSize = 14,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FlexibleDataTableState createState() => _FlexibleDataTableState();
}

class _FlexibleDataTableState extends State<FlexibleDataTable> {
  final ScrollController _scrollController = ScrollController();
  int _previousDataLength = 0;

  @override
  void initState() {
    super.initState();
    _previousDataLength = widget.data.length;
  }

  @override
  void didUpdateWidget(FlexibleDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.length > _previousDataLength) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
    _previousDataLength = widget.data.length;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leftFixedColumns =
        widget.columns.where((col) => col.fixed == FixedPosition.left).toList();
    final rightFixedColumns = widget.columns
        .where((col) => col.fixed == FixedPosition.right)
        .toList();
    final scrollableColumns =
        widget.columns.where((col) => col.fixed == FixedPosition.none).toList();

    return SizedBox(
      height: widget.containerHeight,
      child: Column(
        children: [
          _buildHeader(leftFixedColumns, scrollableColumns, rightFixedColumns),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.data.length,
              itemBuilder: (context, index) => _buildRow(widget.data[index],
                  leftFixedColumns, scrollableColumns, rightFixedColumns),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<ColumnConfig> leftFixed,
      List<ColumnConfig> scrollable, List<ColumnConfig> rightFixed) {
    return Container(
      height: widget.rowHeight,
      decoration: BoxDecoration(
        color: widget.headerBackgroundColor,
        border: Border(bottom: BorderSide(color: widget.borderColor)),
      ),
      child: Row(
        children: [
          ...leftFixed.map(_buildHeaderCell),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: scrollable.map(_buildHeaderCell).toList()),
            ),
          ),
          ...rightFixed.map(_buildHeaderCell),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(ColumnConfig column) {
    return Container(
      width: column.width,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      alignment: Alignment.center,
      child: Text(
        column.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: widget.headerTextColor,
          fontSize: widget.headerFontSize,
        ),
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> rowData, List<ColumnConfig> leftFixed,
      List<ColumnConfig> scrollable, List<ColumnConfig> rightFixed) {
    return Container(
      height: widget.rowHeight,
      decoration: BoxDecoration(
        color: widget.rowBackgroundColor,
        border: Border(bottom: BorderSide(color: widget.borderColor)),
      ),
      child: Row(
        children: [
          ...leftFixed.map((col) => _buildCell(col, rowData)),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    scrollable.map((col) => _buildCell(col, rowData)).toList(),
              ),
            ),
          ),
          ...rightFixed.map((col) => _buildCell(col, rowData)),
        ],
      ),
    );
  }

  Widget _buildCell(ColumnConfig column, Map<String, dynamic> rowData) {
    return Container(
      width: column.width,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      child: column.customBuilder != null
          ? column.customBuilder!(rowData[column.field])
          : Text(
              _truncateText(rowData[column.field].toString(), column.maxLength),
              style: TextStyle(color: column.textColor),
              overflow: TextOverflow.ellipsis,
            ),
    );
  }

  String _truncateText(String text, int? maxLength) {
    if (maxLength == null || text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}

enum FixedPosition { none, left, right }

class ColumnConfig {
  final String field;
  final String title;
  final double width;
  final int? maxLength;
  final Color? textColor;
  final Widget Function(dynamic)? customBuilder;
  final FixedPosition fixed;
  ColumnConfig({
    required this.field,
    required this.title,
    required this.width,
    this.maxLength,
    this.textColor,
    this.customBuilder,
    this.fixed = FixedPosition.none,
  });
}

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:step/core/utils/datetime_util.dart';
import 'package:step/extensions/app_localization_string_builder.dart';
import 'package:step/features/home/domain/usecases/validator/validate_todo.dart';
import 'package:step/features/home/presentation/widgets/calendar_widget.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/todo.dart';
import '../widgets/label_button.dart';

class AddTodoPanel extends StatefulWidget {
  const AddTodoPanel({
    super.key,
    required this.onCreateTodo,
  });

  final Function(Todo) onCreateTodo;

  @override
  State<AddTodoPanel> createState() => _AddTodoPanelState();
}

class _AddTodoPanelState extends State<AddTodoPanel> {
  late TextEditingController _taskNameController;
  late TextEditingController _descriptionController;
  Todo? _todo;
  final _formKey = GlobalKey<FormState>();
  final ValidateTodo _todoValidator = ValidateTodo();
  DateTime _dueDate = DateTime.now();
  DateTime _previousSelectedDate = DateTime.now();
  TimeOfDay? _deadline;

  @override
  void initState() {
    super.initState();
    _todo = Todo(title: '');
    _taskNameController = TextEditingController();
    _descriptionController = TextEditingController();

    _taskNameController.addListener(_onTaskControllerChanged);
    _descriptionController.addListener(_onDescriptionControllerChanged);
  }

  @override
  void dispose() {
    _taskNameController.removeListener(_onTaskControllerChanged);
    _descriptionController.removeListener(_onDescriptionControllerChanged);
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: IntrinsicHeight(
          child: Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                    right: 10,
                  ),
                  child: _buildTaskNameField(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 20),
                  child: _buildDescriptionField(context),
                ),
                Row(
                  children: [
                    LabelButton(
                      color: Colors.green,
                      onTap: () {
                        _previousSelectedDate = _dueDate;
                        _buildCalendarSelector(context);
                      },
                      icon: Icons.calendar_today,
                      label: _displayDateLabel(context),
                    ),
                    LabelButton(
                      color: Colors.redAccent,
                      onTap: () async {
                        var time = DateTime.now().add(const Duration(minutes: 1));
                        TimeOfDay? selectedTime = await showTimePicker(
                          initialTime: TimeOfDay(hour: time.hour, minute: time.minute),
                          context: context,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                timePickerTheme: TimePickerThemeData(
                                  hourMinuteTextColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                  backgroundColor: Colors.white,
                                  hourMinuteTextStyle: GoogleFonts.varelaRound(color: Colors.white, fontSize: 20),
                                  hourMinuteColor: Colors.redAccent,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                    textStyle: GoogleFonts.varelaRound(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (selectedTime == null) {
                          setState(() {
                            _deadline = null;
                          });
                          return;
                        }

                        DateTime selectedDateTime = DateTime(
                          _dueDate.year,
                          _dueDate.month,
                          _dueDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );

                        if (!_isDateTimeInFuture(selectedDateTime)) {
                          _showCustomSnackBar(text: context.getLocaleString(value: 'invalid_time'));
                          return;
                        }

                        setState(() {
                          _deadline = selectedTime;
                          _todo?.deadline = selectedDateTime;
                        });
                      },
                      icon: Icons.alarm,
                      label: _displayReminderLabel(context),
                    ),
                  ],
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (state) {
                            return Colors.redAccent;
                          },
                        ),
                      ),
                      onPressed: () {
                        if (_todo!.deadline != null && !_isDateTimeInFuture(_todo!.deadline!)) {
                          _showCustomSnackBar(text: context.getLocaleString(value: 'invalid_time'));
                        }
                        if (_formKey.currentState!.validate()) {
                          widget.onCreateTodo(_todo!);
                          Navigator.pop(context);
                          _showCustomSnackBar(text: context.getLocaleString(value: 'added'));
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _buildCalendarSelector(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    8,
                  ),
                  topRight: Radius.circular(
                    8,
                  ),
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _dueDate = _previousSelectedDate;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _todo?.dueDay = _dueDate;
                          _todo?.deadline = null;
                          setState(() {
                            _deadline = null;
                          });
                        },
                        child: Text(
                          "Confirm",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                        )),
                  ],
                ),
                CustomCalendarPicker(onDateSelected: (date) {
                  _dueDate = date;
                  if (_dueDate.isBefore(DateTime.now()) &&
                      !DateTimeUtil.isSameDay(_dueDate, DateTime.now())) {
                    _dueDate = DateTime.now();
                  }

                  setState(() {
                    _dueDate;
                  });
                }),
              ],
            ),
          );
        },
        backgroundColor: Colors.white);
  }

  TextFormField _buildTaskNameField(BuildContext context) {
    return TextFormField(
      validator: (title) => _todoValidator.call(title) == null
          ? null
          : context.getLocaleString(value: _todoValidator.call(title)!),
      controller: _taskNameController,
      style: GoogleFonts.aBeeZee(
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      maxLines: 3,
      minLines: 1,
      cursorColor: Colors.redAccent,
      decoration: InputDecoration(
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
        hintText: context.getLocaleString(value: 'todoPlaceholder'),
        hintStyle: GoogleFonts.aBeeZee(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  TextField _buildDescriptionField(BuildContext context) {
    return TextField(
      controller: _descriptionController,
      style: GoogleFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.w500),
      maxLines: 3,
      minLines: 1,
      cursorColor: Colors.redAccent,
      decoration: InputDecoration(
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
        hintText: context.getLocaleString(value: 'descriptionPlaceholder'),
        hintStyle:
            GoogleFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _displayDateLabel(BuildContext context) =>
      DateTimeUtil.isSameDay(DateTime.now(), _dueDate)
          ? context.getLocaleString(value: 'today')
          : DateFormat('MMM, dd', context.getLocaleString(value: 'locale'))
              .format(_dueDate);

  String _displayReminderLabel(BuildContext context) =>
      _deadline == null ? context.getLocaleString(value: 'reminder') : _formatTimeOfDay(_deadline!, is24HourFormat: true);

  void _onTaskControllerChanged() {
    _todo!.title = _taskNameController.text;
  }

  void _onDescriptionControllerChanged() {
    _todo!.description = _descriptionController.text;
  }

  void _showCustomSnackBar({
    required String text,
  }) {
    final overlay = Overlay.of(context);
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: Navigator.of(context),
    );

    final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Create an OverlayEntry with fade-in and fade-out animations
    final overlayEntry = OverlayEntry(
      builder: (context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: opacityAnimation,
              child: Card(
                color: Colors.redAccent,
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    text,
                    style: GoogleFonts.varelaRound(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay and start the fade-in animation
    overlay.insert(overlayEntry);
    animationController.forward();

    // Remove the overlay after a delay, with fade-out animation
    Future.delayed(const Duration(seconds: 1), () async {
      await animationController.reverse();
      overlayEntry.remove();
      animationController.dispose();
    });
  }

  String _formatTimeOfDay(TimeOfDay time, {bool is24HourFormat = false}) {
    // Convert TimeOfDay to a DateTime
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    // Choose format based on 24-hour or 12-hour preference
    final format = is24HourFormat ? DateFormat.Hm() : DateFormat.jm();
    return format.format(dateTime);
  }

  bool _isTimeOfDayBefore(TimeOfDay selectedTime, TimeOfDay currentTime) {
    if (selectedTime.hour < currentTime.hour) {
      return true;
    } else if (selectedTime.hour == currentTime.hour && selectedTime.minute <= currentTime.minute) {
      return true;
    }
    return false;
  }

  bool _isDateTimeInFuture(DateTime selectedDateTime) {
    DateTime now = DateTime.now();

    return selectedDateTime.isAfter(now) &&
        (selectedDateTime.isAfter(_dueDate) || DateTimeUtil.isSameDay(selectedDateTime, _dueDate));
  }
}

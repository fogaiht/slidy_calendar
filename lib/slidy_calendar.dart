library slidy_calendar;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'classes/event.dart';
import 'classes/event_list.dart';
import 'src/calendar_header.dart';
import 'src/default_styles.dart';
import 'src/weekday_row.dart';

export 'classes/event_list.dart';

typedef MarkedDateIconBuilder<T> = Widget Function(T event);
typedef OnDayLongPressed = void Function(DateTime day);

/// This builder is called for every day in the calendar.
/// If you want to build only few custom day containers, return null for the days you want to leave with default looks
/// All characteristics like circle border are also applied to the custom day container [DayBuilder] provides.
/// (if supplied function returns null, Calendar's function will be called for [day]).
/// [isSelectable] - is between [SlidyCalendar.minSelectedDate] and [SlidyCalendar.maxSelectedDate]
/// [index] - DOES NOT equal day number! Index of the day built in current visible field
/// [isSelectedDay] - if the day is selected
/// [isToday] - if the day is similar to [DateTime.now()]
/// [isPrevMonthDay] - if the day is from previous month
/// [textStyle] - text style that would have been applied by the calendar if it was to build the day.
/// Example: if the user provided [SlidyCalendar.todayTextStyle] and [isToday] is true,
///   [SlidyCalendar.todayTextStyle] would be sent into [DayBuilder]'s [textStyle]. If user didn't
///   provide it, default [SlidyCalendar]'s textStyle would be sent. Same applies to all text styles like
///   [SlidyCalendar.prevDaysTextStyle], [SlidyCalendar.daysTextStyle] etc.
/// [isNextMonthDay] - if the day is from next month
/// [isThisMonthDay] - if the day is from next month
/// [day] - day being built.
typedef DayBuilder = Widget Function(bool isSelectable, int index, bool isSelectedDay, bool isToday,
    bool isPrevMonthDay, TextStyle textStyle, bool isNextMonthDay, bool isThisMonthDay, DateTime day);

/// This builder is called for every weekday container (7 times, from Mon to Sun).
/// [weekday] - weekday built, from 0 to 6.
/// [weekdayName] - string representation of the weekday (Mon, Tue, Wed, etc).
typedef WeekdayBuilder = Widget Function(int weekday, String weekdayName);

class SlidyCalendar<T extends EventInterface> extends StatefulWidget {
  final double viewportFraction;
  final TextStyle prevDaysTextStyle;
  final TextStyle daysTextStyle;
  final TextStyle nextDaysTextStyle;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final double height;
  final double width;
  final TextStyle todayTextStyle;
  final Color dayButtonColor;
  final Color todayBorderColor;
  final Color todayButtonColor;
  final DateTime selectedDateTime;
  final DateTime targetDateTime;
  final TextStyle selectedDayTextStyle;
  final Color selectedDayButtonColor;
  final Color selectedDayBorderColor;
  final bool daysHaveCircularBorder;
  final bool daysHaveBorder;
  final Function(DateTime, List<T>) onDayPressed;
  final TextStyle weekdayTextStyle;
  final bool weekDayUpperCase;
  final bool weekDayFirstLetterUpperCase;
  final Color iconColor;
  final TextStyle headerTextStyle;
  final Color headerBackgroundColor;
  final String headerText;
  final TextStyle weekendTextStyle;
  final EventList<T> markedDatesMap;

  /// Change `markedDateWidget` when `markedDateShowIcon` is set to false.
  final Widget markedDateWidget;

  final BoxDecoration markedDateDecoration;
  final bool markedDateShowDots;

  /// Change `ShapeBorder` when `markedDateShowIcon` is set to false.
  final ShapeBorder markedDateCustomShapeBorder;

  /// Change `TextStyle` when `markedDateShowIcon` is set to false.
  final TextStyle markedDateCustomTextStyle;

  /// Icon will overlap the [Day] widget when `markedDateShowIcon` is set to true.
  /// This will also make below parameters work.
  final bool markedDateShowIcon;
  final Color markedDateIconBorderColor;
  final int markedDateIconMaxShown;
  final double markedDateIconMargin;
  final double markedDateIconOffset;
  final MarkedDateIconBuilder<T> markedDateIconBuilder;

  /// null - no indicator, true - show the total events, false - show the total of hidden events
  final bool markedDateMoreShowTotal;
  final Decoration markedDateMoreCustomDecoration;
  final TextStyle markedDateMoreCustomTextStyle;
  final EdgeInsets headerMargin;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;
  final EdgeInsets weekDayPadding;
  final WeekdayBuilder customWeekDayBuilder;
  final DayBuilder customDayBuilder;
  final Color weekDayBackgroundColor;
  final Color backgroundColor;
  final bool weekFormat;
  final bool showWeekDays;
  final bool showHeader;
  final bool showHeaderButton;
  final Widget leftButtonIcon;
  final Widget rightButtonIcon;
  final ScrollPhysics customGridViewPhysics;
  final Function(DateTime) onCalendarChanged;
  final String locale;
  final int firstDayOfWeek;
  final DateTime minSelectedDate;
  final DateTime maxSelectedDate;
  final TextStyle inactiveDaysTextStyle;
  final TextStyle inactiveWeekendTextStyle;
  final bool headerTitleTouchable;
  final Function onHeaderTitlePressed;
  final Function onLeftArrowPressed;
  final Function onRightArrowPressed;
  final WeekdayFormat weekDayFormat;
  final bool staticSixWeekFormat;
  final bool isScrollable;
  final Axis scrollDirection;
  final bool showOnlyCurrentMonthDate;
  final bool pageSnapping;
  final OnDayLongPressed onDayLongPressed;
  final CrossAxisAlignment dayCrossAxisAlignment;
  final MainAxisAlignment dayMainAxisAlignment;
  final bool showIconBehindDayText;
  final ScrollPhysics pageScrollPhysics;
  final bool shouldShowTransform;

  SlidyCalendar({
    Key key,
    this.viewportFraction = 1.0,
    this.prevDaysTextStyle,
    this.daysTextStyle,
    this.nextDaysTextStyle,
    this.prevMonthDayBorderColor = Colors.transparent,
    this.thisMonthDayBorderColor = Colors.transparent,
    this.nextMonthDayBorderColor = Colors.transparent,
    this.dayPadding = 2.0,
    this.height = double.infinity,
    this.width = double.infinity,
    this.todayTextStyle,
    this.dayButtonColor = Colors.transparent,
    this.todayBorderColor = Colors.red,
    this.todayButtonColor = Colors.red,
    this.selectedDateTime,
    this.targetDateTime,
    this.selectedDayTextStyle,
    this.selectedDayButtonColor = Colors.green,
    this.selectedDayBorderColor = Colors.green,
    this.daysHaveCircularBorder,
    this.daysHaveBorder,
    this.onDayPressed,
    this.weekdayTextStyle,
    this.weekDayUpperCase = false,
    this.weekDayFirstLetterUpperCase = false,
    this.iconColor = Colors.blueAccent,
    this.headerTextStyle,
    this.headerBackgroundColor,
    this.headerText,
    this.weekendTextStyle,
    this.markedDatesMap,
    this.markedDateWidget,
    this.markedDateDecoration,
    this.markedDateShowDots = true,
    this.markedDateCustomShapeBorder,
    this.markedDateCustomTextStyle,
    this.markedDateShowIcon = false,
    this.markedDateIconBorderColor,
    this.markedDateIconMaxShown = 2,
    this.markedDateIconMargin = 5.0,
    this.markedDateIconOffset = 5.0,
    this.markedDateIconBuilder,
    this.markedDateMoreShowTotal,
    this.markedDateMoreCustomDecoration,
    this.markedDateMoreCustomTextStyle,
    this.headerMargin = const EdgeInsets.symmetric(vertical: 16.0),
    this.childAspectRatio = 1.0,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4.0),
    this.weekDayPadding = const EdgeInsets.all(0.0),
    this.customWeekDayBuilder,
    this.customDayBuilder,
    this.weekDayBackgroundColor = Colors.transparent,
    this.backgroundColor,
    this.weekFormat = false,
    this.showWeekDays = true,
    this.showHeader = true,
    this.showHeaderButton = true,
    this.leftButtonIcon,
    this.rightButtonIcon,
    this.customGridViewPhysics,
    this.onCalendarChanged,
    this.locale = "en",
    this.firstDayOfWeek,
    this.minSelectedDate,
    this.maxSelectedDate,
    this.inactiveDaysTextStyle,
    this.inactiveWeekendTextStyle,
    this.headerTitleTouchable = false,
    this.onHeaderTitlePressed,
    this.onLeftArrowPressed,
    this.onRightArrowPressed,
    this.weekDayFormat = WeekdayFormat.short,
    this.staticSixWeekFormat = false,
    this.isScrollable = true,
    this.scrollDirection = Axis.horizontal,
    this.showOnlyCurrentMonthDate = false,
    this.pageSnapping = false,
    this.onDayLongPressed,
    this.dayCrossAxisAlignment = CrossAxisAlignment.center,
    this.dayMainAxisAlignment = MainAxisAlignment.center,
    this.showIconBehindDayText = false,
    this.pageScrollPhysics = const ScrollPhysics(),
    this.shouldShowTransform = true,
  }) : super(key: key);

  @override
  _CalendarState<T> createState() => _CalendarState<T>();
}

enum WeekdayFormat {
  weekdays,
  standalone,
  short,
  standaloneShort,
  narrow,
  standaloneNarrow,
}

class _CalendarState<T extends EventInterface> extends State<SlidyCalendar<T>> {
  PageController _controller;
  List<DateTime> _dates;
  List<List<DateTime>> _weeks;
  DateTime _selectedDate = DateTime.now();
  DateTime _targetDate;
  int _startWeekday = 0;
  int _endWeekday = 0;
  DateFormat _localeDate;
  int _pageNum = 0;
  DateTime minDate;
  DateTime maxDate;

  /// When FIRSTDAYOFWEEK is 0 in dart-intl, it represents Monday. However it is the second day in the arrays of Weekdays.
  /// Therefore we need to add 1 modulo 7 to pick the right weekday from intl. (cf. [GlobalMaterialLocalizations])
  int firstDayOfWeek;

  /// If the setState called from this class, don't reload the selectedDate, but it should reload selected date if called from external class

  @override
  initState() {
    super.initState();
    initializeDateFormatting();

    minDate = widget.minSelectedDate ?? DateTime(2018);
    maxDate = widget.maxSelectedDate ?? DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);

    if (widget.selectedDateTime != null) _selectedDate = widget.selectedDateTime;

    _init();

    /// setup pageController
    _controller = PageController(
      initialPage: _pageNum,
      keepPage: true,
      viewportFraction: widget.viewportFraction,

      /// width percentage
    );

    _localeDate = widget.locale == 'pt_Br' ? DateFormat("MMMM yyyy", 'pt_Br') : DateFormat.yMMM(widget.locale);

    if (widget.firstDayOfWeek == null) {
      firstDayOfWeek = (_localeDate.dateSymbols.FIRSTDAYOFWEEK + 1) % 7;
    } else {
      firstDayOfWeek = widget.firstDayOfWeek;
    }

    _setDate();
  }

  @override
  void didUpdateWidget(SlidyCalendar<T> oldWidget) {
    if (widget.targetDateTime != null && widget.targetDateTime != _targetDate) {
      _init();
      _setDate(_pageNum);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Column(
        children: <Widget>[
          CalendarHeader(
            headerBackgroundColor: widget.headerBackgroundColor,
            showHeader: widget.showHeader,
            headerMargin: widget.headerMargin,
            headerTitle: widget.headerText != null
                ? widget.headerText
                : widget.weekFormat
                    ? '${_localeDate.format(_weeks[_pageNum].first)}'
                    : '${_localeDate.format(_dates[_pageNum])[0].toUpperCase()}${_localeDate.format(_dates[_pageNum]).substring(1)}',
            headerTextStyle: widget.headerTextStyle,
            showHeaderButtons: widget.showHeaderButton,
            headerIconColor: widget.iconColor,
            leftButtonIcon: widget.leftButtonIcon,
            rightButtonIcon: widget.rightButtonIcon,
            onLeftButtonPressed: () {
              if (widget.onLeftArrowPressed != null) {
                widget.onLeftArrowPressed();
              }

              _pageNum > 0 ? _setDate(_pageNum - 1) : null;
            },
            onRightButtonPressed: () {
              if (widget.onRightArrowPressed != null) {
                widget.onRightArrowPressed();
              }

              if (widget.weekFormat) {
                _weeks.length - 1 > _pageNum ? _setDate(_pageNum + 1) : null;
              } else {
                _dates.length - 1 > _pageNum ? _setDate(_pageNum + 1) : null;
              }
            },
            isTitleTouchable: widget.headerTitleTouchable,
            onHeaderTitlePressed:
                widget.onHeaderTitlePressed != null ? widget.onHeaderTitlePressed : () => _selectDateFromPicker(),
          ),
          WeekdayRow(
            firstDayOfWeek,
            widget.customWeekDayBuilder,
            showWeekdays: widget.showWeekDays,
            weekdayFormat: widget.weekDayFormat,
            weekdayMargin: widget.weekDayMargin,
            weekdayPadding: widget.weekDayPadding,
            weekdayBackgroundColor: widget.weekDayBackgroundColor,
            weekdayTextStyle: widget.weekdayTextStyle,
            weekDayUpperCase: widget.weekDayUpperCase,
            weekDayFirstLetterUpperCase: widget.weekDayFirstLetterUpperCase,
            localeDate: _localeDate,
          ),
          Expanded(
              child: PageView.builder(
            itemCount: widget.weekFormat ? _weeks.length : _dates.length,
            physics: widget.isScrollable ? widget.pageScrollPhysics : NeverScrollableScrollPhysics(),
            scrollDirection: widget.scrollDirection,
            onPageChanged: (index) {
              _setDate(index);
            },
            controller: _controller,
            itemBuilder: (context, index) {
              return widget.weekFormat ? weekBuilder(index) : builder(index);
            },
            pageSnapping: widget.pageSnapping,
          )),
        ],
      ),
    );
  }

  Widget getDefaultDayContainer(
    bool isSelectable,
    int index,
    bool isSelectedDay,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle textStyle,
    TextStyle defaultTextStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
    DateTime now,
  ) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        crossAxisAlignment: widget.dayCrossAxisAlignment,
        mainAxisAlignment: widget.dayMainAxisAlignment,
        children: <Widget>[
          DefaultTextStyle(
            style: getDefaultDayStyle(isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, textStyle,
                defaultTextStyle, isNextMonthDay, isThisMonthDay),
            child: Text(
              '${now.day}',
              semanticsLabel: now.day.toString(),
              style: getDayStyle(isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, textStyle,
                  defaultTextStyle, isNextMonthDay, isThisMonthDay),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderDay(
    bool isSelectable,
    int index,
    bool isSelectedDay,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle textStyle,
    TextStyle defaultTextStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
    DateTime now,
  ) {
    return Container(
      decoration: (isNextMonthDay || isPrevMonthDay)
          ? null
          : widget.markedDatesMap != null && widget.markedDatesMap.getEvents(now).isNotEmpty
              ? widget.markedDateDecoration != null
                  ? widget.markedDateDecoration
                  : null
              : null,
      margin: EdgeInsets.all(widget.dayPadding),
      child: GestureDetector(
        onLongPress: (isNextMonthDay || isPrevMonthDay) ? null : () => _onDayLongPressed(now),
        child: FlatButton(
          color: isSelectedDay && widget.selectedDayButtonColor != null
              ? widget.selectedDayButtonColor
              : isToday && widget.todayButtonColor != null
                  ? widget.todayButtonColor
                  : widget.dayButtonColor,
          onPressed: (isNextMonthDay || isPrevMonthDay) ? null : () => _onDayPressed(now),
          padding: EdgeInsets.all(widget.dayPadding),
          shape: widget.markedDateCustomShapeBorder != null &&
                  widget.markedDatesMap != null &&
                  widget.markedDatesMap.getEvents(now).isNotEmpty
              ? widget.markedDateCustomShapeBorder
              : (widget.daysHaveBorder == null || widget.daysHaveBorder == false)
                  ? null
                  : widget.daysHaveCircularBorder ?? false
                      ? CircleBorder(
                          side: BorderSide(
                            color: isSelectedDay
                                ? widget.selectedDayBorderColor
                                : isToday && widget.todayBorderColor != null
                                    ? widget.todayBorderColor
                                    : isPrevMonthDay
                                        ? widget.prevMonthDayBorderColor
                                        : isNextMonthDay
                                            ? widget.nextMonthDayBorderColor
                                            : widget.thisMonthDayBorderColor,
                          ),
                        )
                      : RoundedRectangleBorder(
                          side: BorderSide(
                            color: isSelectedDay
                                ? widget.selectedDayBorderColor
                                : isToday && widget.todayBorderColor != null
                                    ? widget.todayBorderColor
                                    : isPrevMonthDay
                                        ? widget.prevMonthDayBorderColor
                                        : isNextMonthDay
                                            ? widget.nextMonthDayBorderColor
                                            : widget.thisMonthDayBorderColor,
                          ),
                        ),
          child: Stack(
            children: widget.showIconBehindDayText
                ? <Widget>[
                    widget.markedDatesMap != null ? _renderMarkedMapContainer(now) : SizedBox(),
                    getDayContainer(isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, textStyle,
                        defaultTextStyle, isNextMonthDay, isThisMonthDay, now),
                  ]
                : <Widget>[
                    getDayContainer(isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, textStyle,
                        defaultTextStyle, isNextMonthDay, isThisMonthDay, now),
                    widget.markedDatesMap != null ? _renderMarkedMapContainer(now) : SizedBox(),
                  ],
          ),
        ),
      ),
    );
  }

  AnimatedBuilder builder(int slideIndex) {
    _startWeekday = _dates[slideIndex].weekday - firstDayOfWeek;
    if (_startWeekday == 7) {
      _startWeekday = 0;
    }
    _endWeekday = DateTime(_dates[slideIndex].year, _dates[slideIndex].month + 1, 1).weekday - firstDayOfWeek;
    double screenWidth = MediaQuery.of(context).size.width;
    int totalItemCount = widget.staticSixWeekFormat
        ? 42
        : DateTime(
              _dates[slideIndex].year,
              _dates[slideIndex].month + 1,
              0,
            ).day +
            _startWeekday +
            (7 - _endWeekday);
    int year = _dates[slideIndex].year;
    int month = _dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!widget.shouldShowTransform) {
          return child;
        }
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,
            child: child,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              width: double.infinity,
              color: widget.backgroundColor,
              child: GridView.count(
                physics: widget.customGridViewPhysics,
                crossAxisCount: 7,
                childAspectRatio: widget.childAspectRatio,
                padding: EdgeInsets.zero,
                children: List.generate(
                  totalItemCount,

                  /// last day of month + weekday
                  (index) {
                    bool isToday = DateTime.now().day == index + 1 - _startWeekday &&
                        DateTime.now().month == month &&
                        DateTime.now().year == year;
                    bool isSelectedDay = widget.selectedDateTime != null &&
                        widget.selectedDateTime.year == year &&
                        widget.selectedDateTime.month == month &&
                        widget.selectedDateTime.day == index + 1 - _startWeekday;
                    bool isPrevMonthDay = index < _startWeekday;
                    bool isNextMonthDay = index >= (DateTime(year, month + 1, 0).day) + _startWeekday;
                    bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                    DateTime now = DateTime(year, month, 1);
                    TextStyle textStyle;
                    TextStyle defaultTextStyle;
                    if (isPrevMonthDay && !widget.showOnlyCurrentMonthDate) {
                      now = now.subtract(Duration(days: _startWeekday - index));
                      textStyle = widget.prevDaysTextStyle;
                      defaultTextStyle = defaultPrevDaysTextStyle;
                    } else if (isThisMonthDay) {
                      now = DateTime(year, month, index + 1 - _startWeekday);
                      textStyle = isSelectedDay
                          ? widget.selectedDayTextStyle
                          : isToday
                              ? widget.todayTextStyle
                              : widget.daysTextStyle;
                      defaultTextStyle = isSelectedDay
                          ? defaultSelectedDayTextStyle
                          : isToday
                              ? defaultTodayTextStyle
                              : defaultDaysTextStyle;
                    } else if (!widget.showOnlyCurrentMonthDate) {
                      now = DateTime(year, month, index + 1 - _startWeekday);
                      textStyle = widget.nextDaysTextStyle;
                      defaultTextStyle = defaultNextDaysTextStyle;
                    } else {
                      return SizedBox();
                    }
                    if (widget.markedDateCustomTextStyle != null &&
                        widget.markedDatesMap != null &&
                        widget.markedDatesMap.getEvents(now).isNotEmpty) {
                      textStyle = widget.markedDateCustomTextStyle;
                    }
                    bool isSelectable = true;
                    if (minDate != null && now.millisecondsSinceEpoch < minDate.millisecondsSinceEpoch) {
                      isSelectable = false;
                    } else if (maxDate != null && now.millisecondsSinceEpoch > maxDate.millisecondsSinceEpoch) {
                      isSelectable = false;
                    }
                    return renderDay(isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, textStyle,
                        defaultTextStyle, isNextMonthDay, isThisMonthDay, now);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedBuilder weekBuilder(int slideIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<DateTime> weekDays = _weeks[slideIndex];

    weekDays = weekDays.map((weekDay) => weekDay.add(Duration(days: firstDayOfWeek))).toList();

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double value = 1.0;
          if (_controller.position.haveDimensions) {
            value = _controller.page - slideIndex;
            value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
          }

          return Center(
            child: SizedBox(
              height: Curves.easeOut.transform(value) * widget.height,
              width: Curves.easeOut.transform(value) * screenWidth,
              child: child,
            ),
          );
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: GridView.count(
                  physics: widget.customGridViewPhysics,
                  crossAxisCount: 7,
                  childAspectRatio: widget.childAspectRatio,
                  padding: EdgeInsets.zero,
                  children: List.generate(weekDays.length, (index) {
                    /// last day of month + weekday
                    bool isToday = weekDays[index].day == DateTime.now().day &&
                        weekDays[index].month == DateTime.now().month &&
                        weekDays[index].year == DateTime.now().year;
                    bool isSelectedDay = _selectedDate != null &&
                        _selectedDate.year == weekDays[index].year &&
                        _selectedDate.month == weekDays[index].month &&
                        _selectedDate.day == weekDays[index].day;
                    bool isPrevMonthDay = weekDays[index].month < _targetDate.month;
                    bool isNextMonthDay = weekDays[index].month > _targetDate.month;
                    bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                    DateTime now = DateTime(weekDays[index].year, weekDays[index].month, weekDays[index].day);
                    TextStyle textStyle;
                    TextStyle defaultTextStyle;
                    if (isPrevMonthDay && !widget.showOnlyCurrentMonthDate) {
                      textStyle = widget.prevDaysTextStyle;
                      defaultTextStyle = defaultPrevDaysTextStyle;
                    } else if (isThisMonthDay) {
                      textStyle = isSelectedDay
                          ? widget.selectedDayTextStyle
                          : isToday
                              ? widget.todayTextStyle
                              : widget.daysTextStyle;
                      defaultTextStyle = isSelectedDay
                          ? defaultSelectedDayTextStyle
                          : isToday
                              ? defaultTodayTextStyle
                              : defaultDaysTextStyle;
                    } else if (!widget.showOnlyCurrentMonthDate) {
                      textStyle = widget.nextDaysTextStyle;
                      defaultTextStyle = defaultNextDaysTextStyle;
                    } else {
                      return SizedBox();
                    }
                    bool isSelectable = true;
                    if (minDate != null && now.millisecondsSinceEpoch < minDate.millisecondsSinceEpoch) {
                      isSelectable = false;
                    } else if (maxDate != null && now.millisecondsSinceEpoch > maxDate.millisecondsSinceEpoch) {
                      isSelectable = false;
                    }
                    return renderDay(isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, textStyle,
                        defaultTextStyle, isNextMonthDay, isThisMonthDay, now);
                  }),
                ),
              ),
            ),
          ],
        ));
  }

  _init() {
    if (widget.targetDateTime != null) {
      if (widget.targetDateTime.difference(minDate).inDays < 0) {
        _targetDate = minDate;
      } else if (widget.targetDateTime.difference(maxDate).inDays > 0) {
        _targetDate = maxDate;
      } else {
        _targetDate = widget.targetDateTime;
      }
    } else {
      _targetDate = _selectedDate;
    }
    if (widget.weekFormat) {
      _pageNum = _targetDate.difference(_firstDayOfWeek(minDate)).inDays ~/ 7;
    } else {
      _pageNum = (_targetDate.year - minDate.year) * 12 + _targetDate.month - minDate.month;
    }
  }

  List<DateTime> _getDaysInWeek([DateTime selectedDate]) {
    if (selectedDate == null) selectedDate = DateTime.now();

    var firstDayOfCurrentWeek = _firstDayOfWeek(selectedDate);
    var lastDayOfCurrentWeek = _lastDayOfWeek(selectedDate);

    return _daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
  }

  DateTime _firstDayOfWeek(DateTime date) {
    var day = _createUTCMiddayDateTime(date);
    return day.subtract(Duration(days: date.weekday % 7));
  }

  DateTime _lastDayOfWeek(DateTime date) {
    var day = _createUTCMiddayDateTime(date);
    return day.add(Duration(days: 7 - day.weekday % 7));
  }

  DateTime _createUTCMiddayDateTime(DateTime date) {
    // Magic const: 12 is to maintain compatibility with date_utils
    return DateTime.utc(date.year, date.month, date.day, 12, 0, 0);
  }

  Iterable<DateTime> _daysInRange(DateTime start, DateTime end) {
    var offset = start.timeZoneOffset;

    return List<int>.generate(end.difference(start).inDays, (i) => i + 1).map((i) {
      var d = start.add(Duration(days: i - 1));

      var timeZoneDiff = d.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = d.timeZoneOffset;
        d = d.subtract(Duration(seconds: timeZoneDiff.inSeconds));
      }
      return d;
    });
  }

  void _onDayLongPressed(DateTime picked) {
    if (widget.onDayLongPressed == null) return;
    widget.onDayLongPressed(picked);
  }

  void _onDayPressed(DateTime picked) {
    if (picked == null) return;
    if (minDate != null && picked.millisecondsSinceEpoch < minDate.millisecondsSinceEpoch) return;
    if (maxDate != null && picked.millisecondsSinceEpoch > maxDate.millisecondsSinceEpoch) return;

    setState(() {
      _selectedDate = picked;
    });
    if (widget.onDayPressed != null) {
      widget.onDayPressed(picked, widget.markedDatesMap != null ? widget.markedDatesMap.getEvents(picked) : []);
    }
  }

  Future<Null> _selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: minDate,
      lastDate: maxDate,
    );

    if (selected != null) {
      // updating selected date range based on selected week
      setState(() {
        _selectedDate = selected;
      });
      if (widget.onDayPressed != null) {
        widget.onDayPressed(selected, widget.markedDatesMap != null ? widget.markedDatesMap.getEvents(selected) : []);
      }
    }
  }

  void _setDatesAndWeeks() {
    /// Setup default calendar format
    List<DateTime> date = [];
    int currentDateIndex = 0;
    for (int _cnt = 0;
        0 >= DateTime(minDate.year, minDate.month + _cnt).difference(DateTime(maxDate.year, maxDate.month)).inDays;
        _cnt++) {
      date.add(DateTime(minDate.year, minDate.month + _cnt, 1));
      if (0 == date.last.difference(DateTime(_targetDate.year, _targetDate.month)).inDays) {
        currentDateIndex = _cnt;
      }
    }

    /// Setup week-only format
    List<List<DateTime>> week = [];
    for (int _cnt = 0;
        0 >= minDate.add(Duration(days: 7 * _cnt)).difference(maxDate.add(Duration(days: 7))).inDays;
        _cnt++) {
      week.add(_getDaysInWeek(minDate.add(Duration(days: 7 * _cnt))));
    }

    _startWeekday = date[currentDateIndex].weekday - firstDayOfWeek;
    /*if (widget.showOnlyCurrentMonthDate) {
      _startWeekday--;
    }*/
    if (/*widget.showOnlyCurrentMonthDate && */ _startWeekday == 7) {
      _startWeekday = 0;
    }
    _endWeekday = DateTime(date[currentDateIndex].year, date[currentDateIndex].month + 1, 1).weekday - firstDayOfWeek;
    _dates = date;
    _weeks = week;
//        this._selectedDate = widget.selectedDateTime != null
//            ? widget.selectedDateTime
//            : DateTime.now();
  }

  void _setDate([int page = -1]) {
    if (page == -1) {
      setState(() {
        _setDatesAndWeeks();
      });
    } else {
      if (widget.weekFormat) {
        setState(() {
          _pageNum = page;
          _targetDate = _weeks[page].first;
        });

        _controller.animateToPage(page, duration: Duration(milliseconds: 1), curve: Threshold(0.0));
      } else {
        setState(() {
          _pageNum = page;
          _targetDate = _dates[page];
          _startWeekday = _dates[page].weekday - firstDayOfWeek;
          _endWeekday = _lastDayOfWeek(_dates[page]).weekday - firstDayOfWeek;
        });
        _controller.animateToPage(page, duration: Duration(milliseconds: 1), curve: Threshold(0.0));
      }

      //call callback
      if (widget.onCalendarChanged != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onCalendarChanged(!widget.weekFormat ? _dates[page] : _weeks[page][firstDayOfWeek]);
        });
      }
    }
  }

  Widget _renderMarkedMapContainer(DateTime now) {
    if (widget.markedDateShowDots) {
      if (widget.markedDateShowIcon) {
        return Stack(
          children: _renderMarkedMap(now),
        );
      } else {
        return Container(
          height: double.infinity,
          padding: EdgeInsets.only(bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _renderMarkedMap(now),
          ),
        );
      }
    } else {
      return SizedBox();
    }
  }

  List<Widget> _renderMarkedMap(DateTime now) {
    if (widget.markedDatesMap != null && widget.markedDatesMap.getEvents(now).isNotEmpty) {
      List<Widget> tmp = [];
      int count = 0;
      int eventIndex = 0;
      double offset = 0.0;
      double padding = widget.markedDateIconMargin;
      widget.markedDatesMap.getEvents(now).forEach((event) {
        if (widget.markedDateShowIcon) {
          if (tmp.isNotEmpty && tmp.length < widget.markedDateIconMaxShown) {
            offset += widget.markedDateIconOffset;
          }
          if (tmp.length < widget.markedDateIconMaxShown && widget.markedDateIconBuilder != null) {
            tmp.add(Center(
                child: Container(
              padding: EdgeInsets.only(
                top: padding + offset,
                left: padding + offset,
                right: padding - offset,
                bottom: padding - offset,
              ),
              width: double.infinity,
              height: double.infinity,
              child: widget.markedDateIconBuilder(event),
            )));
          } else {
            count++;
          }
          if (count > 0 && widget.markedDateMoreShowTotal != null) {
            tmp.add(
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  width: widget.markedDateMoreShowTotal ? 18 : null,
                  height: widget.markedDateMoreShowTotal ? 18 : null,
                  decoration: widget.markedDateMoreCustomDecoration == null
                      ? BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(1000.0)),
                        )
                      : widget.markedDateMoreCustomDecoration,
                  child: Center(
                    child: Text(
                      widget.markedDateMoreShowTotal ? (count + widget.markedDateIconMaxShown).toString() : ('$count+'),
                      semanticsLabel: widget.markedDateMoreShowTotal
                          ? (count + widget.markedDateIconMaxShown).toString()
                          : ('$count+'),
                      style: widget.markedDateMoreCustomTextStyle == null
                          ? TextStyle(fontSize: 9.0, color: Colors.white, fontWeight: FontWeight.normal)
                          : widget.markedDateMoreCustomTextStyle,
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          //max 5 dots
          if (eventIndex < 5) {
            if (widget.markedDateIconBuilder != null) {
              tmp.add(widget.markedDateIconBuilder(event));
            } else {
              if (event.getDot() != null) {
                tmp.add(Container(child: event.getDot()));
              } else if (widget.markedDateWidget != null) {
                tmp.add(widget.markedDateWidget);
              } else {
                tmp.add(defaultMarkedDateWidget);
              }
            }
          }
        }

        eventIndex++;
      });
      return tmp;
    }
    return [];
  }

  TextStyle getDefaultDayStyle(
    bool isSelectable,
    int index,
    bool isSelectedDay,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle textStyle,
    TextStyle defaultTextStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
  ) {
    return !isSelectable
        ? defaultInactiveDaysTextStyle
        : (_localeDate.dateSymbols.WEEKENDRANGE.contains((index - 1 + firstDayOfWeek) % 7)) &&
                !isSelectedDay &&
                !isToday
            ? (isPrevMonthDay
                ? defaultPrevDaysTextStyle
                : isNextMonthDay
                    ? defaultNextDaysTextStyle
                    : isSelectable
                        ? defaultWeekendTextStyle
                        : defaultInactiveWeekendTextStyle)
            : isToday
                ? defaultTodayTextStyle
                : isSelectable && textStyle != null
                    ? textStyle
                    : defaultTextStyle;
  }

  TextStyle getDayStyle(
    bool isSelectable,
    int index,
    bool isSelectedDay,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle textStyle,
    TextStyle defaultTextStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
  ) {
    return isSelectedDay && widget.selectedDayTextStyle != null
        ? widget.selectedDayTextStyle
        : (_localeDate.dateSymbols.WEEKENDRANGE.contains((index - 1 + firstDayOfWeek) % 7)) &&
                !isSelectedDay &&
                isThisMonthDay &&
                !isToday
            ? (isSelectable ? widget.weekendTextStyle : widget.inactiveWeekendTextStyle)
            : !isSelectable
                ? widget.inactiveDaysTextStyle
                : isPrevMonthDay
                    ? widget.prevDaysTextStyle
                    : isNextMonthDay
                        ? widget.nextDaysTextStyle
                        : isToday
                            ? widget.todayTextStyle
                            : widget.daysTextStyle;
  }

  Widget getDayContainer(bool isSelectable, int index, bool isSelectedDay, bool isToday, bool isPrevMonthDay,
      TextStyle textStyle, TextStyle defaultTextStyle, bool isNextMonthDay, bool isThisMonthDay, DateTime now) {
    if (widget.customDayBuilder != null) {
      final TextStyle appTextStyle = DefaultTextStyle.of(context).style;
      TextStyle styleForBuilder = appTextStyle.merge(getDayStyle(isSelectable, index, isSelectedDay, isToday,
          isPrevMonthDay, textStyle, defaultTextStyle, isNextMonthDay, isThisMonthDay));

      return widget.customDayBuilder(isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, styleForBuilder,
              isNextMonthDay, isThisMonthDay, now) ??
          getDefaultDayContainer(isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, textStyle,
              defaultTextStyle, isNextMonthDay, isThisMonthDay, now);
    } else {
      return getDefaultDayContainer(isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, textStyle,
          defaultTextStyle, isNextMonthDay, isThisMonthDay, now);
    }
  }
}

# calendar_timeline

Flutter widget form select a date in horizontal timeline with customizable styles.

## Getting Started

You can use this package when you need to add a date selector to your application.

## Properties

| Property                 | Type                   | Description |
|:-------------------------|:-----------------------|:------------|
| initialDate              | DateTime               |             |
| firstDate                | DateTime               |             |
| lastDate                 | DateTime               |             |
| selectableDayPredicate   | SelectableDayPredicate |             |
| onDateSelected           | OnDateSelected         |             |
| leftMargin               | double                 |             |
| monthColor               | Color                  |             |
| dayColor                 | Color                  |             |
| activeDayColor           | Color                  |             |
| activeBackgroundDayColor | Color                  |             |


## Use example

You can review the example folder for a complete example of using the widget.

```
CalendarTimeline(
          initialDate: DateTime(2020, 4, 20),
          firstDate: DateTime(2019, 1, 15),
          lastDate: DateTime(2020, 11, 20),
          onDateSelected: (date) => print(date),
          leftMargin: 20,
          monthColor: Colors.blueGrey,
          dayColor: Colors.teal[200],
          activeDayColor: Colors.white,
          activeBackgroundDayColor: Colors.redAccent[100],
          selectableDayPredicate: (date) => date.day != 23,
        )
```
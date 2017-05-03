using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as Act;
using Toybox.Application as App;

class TallRightView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	var colors = App.getApp().colorValues;

		// get, format and show date
    	var dateInfo = Calendar.info( Time.now(), Calendar.FORMAT_LONG );
		var dateDayString = Lang.format("$1$", [ dateInfo.day_of_week ]);
		var dateMonthString = Lang.format("$1$. $2$", [ dateInfo.day, dateInfo.month ]);

		modifyLabel("DateDayLabel", colors.date, dateDayString);
		modifyLabel("DateMonthLabel", colors.date, dateMonthString);

		// get, format and show time
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        var mins = clockTime.min;
        var zeroPadHours = App.getApp().getProperty("PadHoursWithLeadingZeroes");
        var zeroPadMinutes = App.getApp().getProperty("PadMinutesWithLeadingZeroes");
        var ampm = "";
        if (!Sys.getDeviceSettings().is24Hour) {
	        ampm = hours >= 12 ? "PM" : "AM";
            if (hours > 12) {
                hours = hours - 12;
            }
        }
        modifyLabel("AMPMLabel", colors.ampm, ampm);
        if (zeroPadHours) {
            hours = hours.format("%02d");
        } else {
            hours = hours.format("%d");
        }
        if (zeroPadMinutes) {
            mins = mins.format("%02d");
        } else {
            mins = mins.format("%d");
        }

        modifyLabel("TimeHoursLabel", colors.hours, hours);
        modifyLabel("TimeMinsLabel", colors.minutes, mins);

        var systemStats = Sys.getSystemStats();

		modifyLabel("BattPercentLabel", colors.battery, systemStats.battery.format("%d") + "%");

		var settings = Sys.getDeviceSettings();

		modifyLabel("BluetoothIconLabel", colors.bluetooth, settings.phoneConnected ? "B" : "");
		modifyLabel("DNDIconLabel", colors.dnd, settings.doNotDisturb ? "D" : "");

		var alarmCount = settings.alarmCount;
		modifyLabel("AlarmsIconLabel", colors.alarms, alarmCount > 0 ? "A" : "");
		modifyLabel("AlarmsCountLabel", colors.alarms, alarmCount > 0 ? alarmCount.format("%d") : "");

		var notificationCount = settings.notificationCount;
		modifyLabel("NotificationsIconLabel", colors.notifications, notificationCount > 0 ? "C" : "");
		modifyLabel("NotificationsCountLabel", colors.notifications, notificationCount > 0 ? notificationCount.format("%d") : "");

		var activityInfo = Act.getInfo();
		var hrSample = Act.getHeartRateHistory(1, true).next();

		modifyActivityProgress("StepsProgress", "StepsIconLabel", "E", "StepsCountLabel", activityInfo.stepGoal, activityInfo.steps);
		modifyLabel("CaloriesIconLabel", colors.calories, "F");
		modifyLabel("CaloriesCountLabel", colors.calories, activityInfo.calories.toString());
		modifyLabel("HeartrateIconLabel", colors.heartrate, "G");
		modifyLabel("HeartrateCountLabel", colors.heartrate, hrSample == null ? "n/a" : hrSample.heartRate.toString());

		// transform move bar level to progress and draw move bar
		var moveBarProgress = 1.0 * (activityInfo.moveBarLevel - Act.MOVE_BAR_LEVEL_MIN) / (Act.MOVE_BAR_LEVEL_MAX - Act.MOVE_BAR_LEVEL_MIN);
		if (moveBarProgress > 0) {
			// minimum move bar size is 40%; add the rest to that minimum size
			moveBarProgress = 0.4 + (0.6 * moveBarProgress);
		}
		if (!App.getApp().getProperty("EnableMoveBar")) {
			moveBarProgress = 0;
		}
		var moveBarDrawable = View.findDrawableById("MoveBar");
		moveBarDrawable.goal = 1.0;
		moveBarDrawable.current = moveBarProgress;
		moveBarDrawable.outlineColor = colors.dataBackground;
		moveBarDrawable.progressColor = getProgressColor(1, 1);
		moveBarDrawable.reachedColor = getProgressColor(1, 0);
		var moveLabel = View.findDrawableById("MoveLabel");
		moveLabel.setColor(colors.dataBackground);
		moveLabel.setText(moveBarProgress < 0.8 ? "Move!" : "M o v e !");

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function modifyLabel(drawableId, color, labelText) {
		var view = View.findDrawableById(drawableId);
		if (color != null) {
        	view.setColor(color);
        }
		view.setText(labelText);
    }

    function modifyActivityProgress(progressDrawableId, iconDrawableId, iconChar, countDrawableId, goal, current) {
		var progressDrawable = View.findDrawableById(progressDrawableId);
		progressDrawable.goal = goal;
		progressDrawable.current = current;
		progressDrawable.outlineColor = App.getApp().colorValues.stepsProgressOutline;
		progressDrawable.progressColor = getProgressColor(1, 0);
		progressDrawable.reachedColor = getProgressColor(1, 1);
		var progressLabelColor = getProgressColor(goal, current);
		modifyLabel(iconDrawableId, progressLabelColor, iconChar);
		modifyLabel(countDrawableId, progressLabelColor, current.toString());
    }

    function getProgressColor(goal, current) {
      	var colors = App.getApp().colorValues;
    	return current >= goal ? colors.stepsGoalReached : colors.stepsProgress;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
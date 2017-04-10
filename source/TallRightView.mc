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

		// get, format and show date
    	var dateInfo = Calendar.info( Time.now(), Calendar.FORMAT_LONG );
		var dateDayString = Lang.format("$1$", [ dateInfo.day_of_week ]);
		var dateMonthString = Lang.format("$1$. $2$", [ dateInfo.day, dateInfo.month ]);

		modifyLabel("DateDayLabel", "DateColor", dateDayString);
		modifyLabel("DateMonthLabel", "DateColor", dateMonthString);

		// get, format and show time
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        var mins = clockTime.min;
        var zeroPad = App.getApp().getProperty("PadWithLeadingZeroes");
        if (Sys.getDeviceSettings().is24Hour) {
        	modifyLabel("AMPMLabel1", "HoursColor", "");
        	modifyLabel("AMPMLabel2", "HoursColor", "");
        } else {
	        var ampm = hours >= 12 ? "PM" : "AM";
            if (hours > 12) {
                hours = hours - 12;
            }
            if (hours >= 10 || zeroPad) {
	        	modifyLabel("AMPMLabel1", "HoursColor", ampm);
    	    	modifyLabel("AMPMLabel2", "HoursColor", "");
            } else {
        		modifyLabel("AMPMLabel1", "HoursColor", "");
        		modifyLabel("AMPMLabel2", "HoursColor", ampm);
            }
        }
        if (zeroPad) {
            hours = hours.format("%02d");
            mins = mins.format("%02d");
        } else {
            hours = hours.format("%d");
            mins = mins.format("%d");
        }

        modifyLabel("TimeHoursLabel", "HoursColor", hours);
        modifyLabel("TimeMinsLabel", "MinutesColor", mins);

        var systemStats = Sys.getSystemStats();

		modifyLabel("BattPercentLabel", "BatteryColor", systemStats.battery.format("%d") + "%");

		var settings = Sys.getDeviceSettings();

		modifyLabel("BluetoothIconLabel", "BluetoothColor", settings.phoneConnected ? "B" : "");
		modifyLabel("DNDIconLabel", "DNDColor", settings.doNotDisturb ? "D" : "");

		var alarmCount = settings.alarmCount;
		modifyLabel("AlarmsIconLabel", "AlarmsColor", alarmCount > 0 ? "A" : "");
		modifyLabel("AlarmsCountLabel", "AlarmsColor", alarmCount > 0 ? alarmCount.format("%d") : "");

		var notificationCount = settings.notificationCount;
		modifyLabel("NotificationsIconLabel", "NotificationsColor", notificationCount > 0 ? "C" : "");
		modifyLabel("NotificationsCountLabel", "NotificationsColor", notificationCount > 0 ? notificationCount.format("%d") : "");

		var activityInfo = Act.getInfo();
		var hrSample = Act.getHeartRateHistory(1, true).next();

		modifyActivityProgress("StepsProgress", "StepsIconLabel", "E", "StepsCountLabel", activityInfo.stepGoal, activityInfo.steps);
		modifyLabel("CaloriesIconLabel", "CaloriesColor", "F");
		modifyLabel("CaloriesCountLabel", "CaloriesColor", activityInfo.calories.toString());
		modifyLabel("HeartrateIconLabel", "HeartrateColor", "G");
		modifyLabel("HeartrateCountLabel", "HeartrateColor", hrSample == null ? "n/a" : hrSample.heartRate.toString());

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
		moveBarDrawable.outlineColor = getColor("BackgroundColor");
		moveBarDrawable.progressColor = getColor(getProgressColorProperty(1, 1));
		moveBarDrawable.reachedColor = getColor(getProgressColorProperty(1, 0));
		var moveLabel = View.findDrawableById("MoveLabel");
		moveLabel.setColor(getColor("BackgroundColor"));
		moveLabel.setText(moveBarProgress < 0.8 ? "Move!" : "M O V E !");

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function modifyLabel(drawableId, colorPropertyName, labelText) {
		var view = View.findDrawableById(drawableId);
		if (colorPropertyName != null) {
        	view.setColor(getColor(colorPropertyName));
        }
		view.setText(labelText);
    }

    function modifyActivityProgress(progressDrawableId, iconDrawableId, iconChar, countDrawableId, goal, current) {
		var progressDrawable = View.findDrawableById(progressDrawableId);
		progressDrawable.goal = goal;
		progressDrawable.current = current;
		progressDrawable.outlineColor = getColor("StepsProgressOutlineColor");
		progressDrawable.progressColor = getColor(getProgressColorProperty(1, 0));
		progressDrawable.reachedColor = getColor(getProgressColorProperty(1, 1));
		var progressLabelColor = getProgressColorProperty(goal, current);
		modifyLabel(iconDrawableId, progressLabelColor, iconChar);
		modifyLabel(countDrawableId, progressLabelColor, current.toString());
    }

    function getProgressColorProperty(goal, current) {
		return current >= goal ? "StepsGoalReachedColor" : "StepsProgressColor";
    }

    function getColor(colorPropertyName) {
    	var color = App.getApp().getProperty(colorPropertyName);
    	if (color == null) {
    		color = 0xFFFFFF;
    	}
    	return color;
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
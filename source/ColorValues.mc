using Toybox.Application as App;

class ColorValues {
	hidden var black = 0x000000;
	hidden var white = 0xFFFFFF;
	
	var background,
		hours, minutes, date, 
		battery, bluetooth, dnd, alarms, notifications,
		stepsProgress, stepsProgressOutline, stepsGoalReached, 
		calories, heartrate;
		
	function refresh() {
		background = parseColor("BackgroundColor");
		hours = parseColor("HoursColor");
		minutes = parseColor("MinutesColor");
		date = parseColor("DateColor");
		battery = parseColor("BatteryColor");
		bluetooth = parseColor("BluetoothColor");
		dnd = parseColor("DNDColor");
		alarms = parseColor("AlarmsColor");
		notifications = parseColor("NotificationsColor");
		stepsProgress = parseColor("StepsProgressColor");
		stepsProgressOutline = parseColor("StepsProgressOutlineColor");
		stepsGoalReached = parseColor("StepsGoalReachedColor");
		calories = parseColor("CaloriesColor");
		heartrate = parseColor("HeartrateColor");
	}
	
	function parseColor(colorSettingsProperty) {
		var colorSpec = App.getApp().getProperty(colorSettingsProperty);
		if (colorSpec == null) {
    		return black;
    	}
    	if (!(colorSpec instanceof Toybox.Lang.String)) {
    		return black;
    	}
    	if (colorSpec.length() != 8) {
    		return black;
    	}
    	var red = calculateColorComponent(colorSpec, 0, 2);
    	var green = calculateColorComponent(colorSpec, 3, 5);
    	var blue = calculateColorComponent(colorSpec, 6, 8);
    	if (red == null || green == null || blue == null) {
    		return black;
    	}
    	return red * 256 * 256 + green * 256 + blue;
	}
	
	function calculateColorComponent(colorSpec, start, end) {
		var value = colorSpec.substring(start, end).toNumberWithBase(10);
		return value == null ? null : value * 256 / 100;
	}
}

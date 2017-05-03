class ColorValues {
	hidden var black = 0x000000;
	hidden var white = 0xFFFFFF;
	
	var dataBackground, timeBackground, statusBackground,
		ampm, hours, minutes, date, 
		battery, bluetooth, dnd, alarms, notifications,
		stepsProgress, stepsProgressOutline, stepsGoalReached, 
		calories, heartrate;
		
	function refresh(propertyProvider) {
		statusBackground = parseColor(propertyProvider, "StatusBackgroundColor", black);
		dataBackground = parseColor(propertyProvider, "DataBackgroundColor", black);
		timeBackground = parseColor(propertyProvider, "TimeBackgroundColor", black);
		ampm = parseColor(propertyProvider, "AMPMColor", white);
		hours = parseColor(propertyProvider, "HoursColor", white);
		minutes = parseColor(propertyProvider, "MinutesColor", white);
		date = parseColor(propertyProvider, "DateColor", white);
		battery = parseColor(propertyProvider, "BatteryColor", white);
		bluetooth = parseColor(propertyProvider, "BluetoothColor", white);
		dnd = parseColor(propertyProvider, "DNDColor", white);
		alarms = parseColor(propertyProvider, "AlarmsColor", white);
		notifications = parseColor(propertyProvider, "NotificationsColor", white);
		stepsProgress = parseColor(propertyProvider, "StepsProgressColor", white);
		stepsProgressOutline = parseColor(propertyProvider, "StepsProgressOutlineColor", black);
		stepsGoalReached = parseColor(propertyProvider, "StepsGoalReachedColor", white);
		calories = parseColor(propertyProvider, "CaloriesColor", white);
		heartrate = parseColor(propertyProvider, "HeartrateColor", white);
	}
	
	function parseColor(propertyProvider, colorSettingsProperty, defaultColor) {
		var colorSpec = propertyProvider.getProperty(colorSettingsProperty);
		if (colorSpec == null) {
    		return defaultColor;
    	}
    	if (!(colorSpec instanceof Toybox.Lang.String)) {
    		return defaultColor;
    	}
    	if (colorSpec.length() != 8) {
    		return defaultColor;
    	}
    	var red = calculateColorComponent(colorSpec, 0, 2);
    	var green = calculateColorComponent(colorSpec, 3, 5);
    	var blue = calculateColorComponent(colorSpec, 6, 8);
    	if (red == null || green == null || blue == null) {
    		return defaultColor;
    	}
    	return red * 256 * 256 + green * 256 + blue;
	}
	
	function calculateColorComponent(colorSpec, start, end) {
		var value = colorSpec.substring(start, end).toNumberWithBase(10);
		return value == null ? null : value * 256 / 100;
	}
}

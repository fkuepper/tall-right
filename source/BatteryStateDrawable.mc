using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class BatteryStateDrawable extends Ui.Drawable {

	hidden var x, y, w, h;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
        w = params.get(:w);
        h = params.get(:h);
    }

    function draw(dc) {
    	var colors = App.getApp().colorValues;
    	
		// Battery percentage and icon
		dc.setColor(colors.battery, colors.statusBackground);

		dc.drawRectangle(x, y, w-2, h);
		dc.fillRectangle(x+w-2, y+4, 2, h-8); //draws the + connection point above a battery

		//Fills up battery icon by % of power.
		//The battery will drain from the top of the battery (right) downwards (left)
		//Again 3 is horizontal position, 193 vertical position, 18*battery/100 is the decreasing white filling,
		//10 is the width of the battery, but in our coding, it's the vertical size.
		//To fill up the battery icon by % of battery, I use 18 (which is the horizontal white filling) X  BATT % / 100%
		var battery = Sys.getSystemStats().battery;
		dc.fillRectangle(x+2, y+2, (w-6)*battery/100, 10);
    }
}
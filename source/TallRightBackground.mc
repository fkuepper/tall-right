using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class Background extends Ui.Drawable {
	
    function initialize(params) {
        Drawable.initialize(params);
    }

    function draw(dc) {
        dc.setColor(getColor(), Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(locX, locY, width, height);
    }

	function getColor() {
		return App.getApp().colorValues.background;
	}
}

class TimeBackground extends Background {
	
    function initialize(params) {
        Background.initialize(params);
    }
    
	function getColor() {
		return App.getApp().colorValues.timeBackground;
	}
}

class DataBackground extends Background {
	
    function initialize(params) {
        Background.initialize(params);
    }

	function getColor() {
		return App.getApp().colorValues.dataBackground;
	}
}

class StatusBackground extends Background {
	
    function initialize(params) {
        Background.initialize(params);
    }

	function getColor() {
		return App.getApp().colorValues.statusBackground;
	}
}

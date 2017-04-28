using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;

class ProgressDrawable extends Ui.Drawable {

	var x, y, w, h, goal, current, outlineColor, progressColor, reachedColor;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
        w = params.get(:w);
        h = params.get(:h);
    }

    function draw(dc) {
    	var appBgColor = App.getApp().colorValues.background;

    	// draw shape outline
		dc.setColor(outlineColor == null ? appBgColor : outlineColor, appBgColor);
		dc.fillRectangle(x, y, w, h);

		// calculate progress
		var progress = 1.0 * current / goal;

		if (progress < 1) {
			// in progress ==> simply draw current progress bar
			dc.setColor(progressColor, appBgColor);
			dc.fillRectangle(x, y, w * progress, h);
		} else {
			// goal reached or overdone ==> fill complete and draw goal marker
			dc.setColor(reachedColor == null ? progressColor : reachedColor, appBgColor);
			dc.fillRectangle(x, y, w, h);

			var goalMark = w / progress;
			if (goalMark < w - 5) {
				dc.setColor(outlineColor == null ? appBgColor : outlineColor, appBgColor);
				dc.fillRectangle(x + goalMark - 1, y, 3, h);
			}
		}
    }
}
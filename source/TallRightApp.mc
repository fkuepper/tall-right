using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class TallRightApp extends App.AppBase {

	var colorValues = new ColorValues();

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	colorValues.refresh(self);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new TallRightView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
    	colorValues.refresh(self);
        Ui.requestUpdate();
    }

}
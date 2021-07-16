import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Position;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Weather;

class GC_watchfaceView extends WatchUi.WatchFace {

    var bg;

    var powerIcon;
    var chargingIcon;
    var connectedIcon;
    var disconnectedIcon;
    var heartrateIcon;
    var pressureIcon;
    var heightIcon;
    var stepIcon;
    var floorIcon;
    var alarmIcon;
    var notificationIcon;
    var gpsIcon;
    var nogpsIcon;
    
    var power_x;
    var power_y;
    var connected_x;
    var connected_y;
    var step_x;
    var step_y;
    var floor_x;
    var floor_y;
    var alarm_x;
    var alarm_y;
    var notification_x;
    var notification_y;
    var height_x;
    var height_y;
    var pressure_x;
    var pressure_y;
    var heartrate_x;
    var heartrate_y;
    var time_x;
    var time_y;
    var date_x;
    var date_y;
    var gps_x;
    var gps_y;

    function initialize() {
        WatchFace.initialize();
        
        bg = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.background
        });
        
        power_x = 95;
        power_y = 0;
        gps_x = 70;
        gps_y = 25;
        connected_x = 95;
        connected_y = 25;
        notification_x = 121;
        notification_y = 25;
        alarm_x = 145;
        alarm_y = 25;
        step_x = 95;
        step_y = 50;
        floor_x = 95;
        floor_y = 75;
        pressure_x = 95;
        pressure_y = 165;
        height_x = 95;
        height_y = 190;
        heartrate_x = 95;
        heartrate_y = 216;
//        heartrate_x = 0;
//        heartrate_y = 108;
        
        time_x = 119;
        time_y = 120;
        date_x = 121;
        date_y = 140;
        
        
        powerIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.PowerIcon,
            :locX=>power_x,
            :locY=>power_y
        });
        chargingIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.ChargingIcon,
            :locX=>power_x,
            :locY=>power_y
        });

        connectedIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.ConnectedIcon,
            :locX=>connected_x,
            :locY=>connected_y
        });
        disconnectedIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.DisconnectedIcon,
            :locX=>connected_x,
            :locY=>connected_y
        });

        stepIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.StepIcon,
            :locX=>step_x,
            :locY=>step_y
        });
        floorIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.FloorIcon,
            :locX=>floor_x,
            :locY=>floor_y
        });

        alarmIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.AlarmIcon,
            :locX=>alarm_x,
            :locY=>alarm_y
        });
        notificationIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.NotificationIcon,
            :locX=>notification_x,
            :locY=>notification_y
        });

        gpsIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.GpsIcon,
            :locX=>gps_x,
            :locY=>gps_y
        });
        nogpsIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.NogpsIcon,
            :locX=>gps_x,
            :locY=>gps_y
        });

        heartrateIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.HeartrateIcon,
            :locX=>heartrate_x,
            :locY=>heartrate_y
        });
        pressureIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.PressureIcon,
            :locX=>pressure_x,
            :locY=>pressure_y
        });
        heightIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.HeightIcon,
            :locX=>height_x,
            :locY=>height_y
        });
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.GCWatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        bg.draw(dc);
        setSystemDisp(dc);
        setDeviceDisp(dc);
        setDatetimeDisp(dc);
        setStepFloorDisp(dc);
        setActivityDisp(dc);
        setGpsDisp(dc);
        
        // Call the parent onUpdate function to redraw the layout
//        View.onUpdate(dc);
    }
    
    function setGpsDisp(dc){
        var posInfo = Position.getInfo();
        var altString = "--";
        if (Position.QUALITY_POOR < posInfo.accuracy)
        {
            gpsIcon.draw(dc);
            if (posInfo has :altitude && posInfo.altitude != null)
            {
                altString = posInfo.altitude.format("%02d");
            }
        }
        else
        {
            nogpsIcon.draw(dc);
        }
        heightIcon.draw(dc);
        dc.drawText(height_x + 25, height_y, Graphics.FONT_XTINY, altString, Graphics.TEXT_JUSTIFY_LEFT);
    }


    function setSystemDisp(dc){
        // Get and show the battery

        var stats = System.getSystemStats();
        var powerString = Lang.format("$1$", [stats.battery.format("%02d")]);
        dc.drawText(power_x + 25, power_y, Graphics.FONT_XTINY, powerString, Graphics.TEXT_JUSTIFY_LEFT);
//        var powerView = View.findDrawableById("PowerLabel") as Text;
//        powerView.setText(powerString);
        if (stats.charging)
        {
            chargingIcon.draw(dc);
        }
        else
        {
            powerIcon.draw(dc);
        }
    }
    
    function setDeviceDisp(dc){
        var devSettings = System.getDeviceSettings();

        if (devSettings.phoneConnected)
        {
            connectedIcon.draw(dc);
        }
        else
        {
            disconnectedIcon.draw(dc);
        }
        var deviceView = View.findDrawableById("DeviceLabel") as Text;
//        deviceView.setText(deviceString);
        
        var alarmView = View.findDrawableById("AlarmLabel") as Text;
        var alarms = devSettings.alarmCount;
        if (0 < alarms)
        {
            alarmIcon.draw(dc);
        }
        
        var notifications = devSettings.notificationCount;
        if (0 < notifications)
        {
            notificationIcon.draw(dc);
        }
    }
    
    function setDatetimeDisp(dc){
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$:$2$", [now.hour, now.min.format("%02d")]);
        dc.drawText(time_x, time_y, Graphics.FONT_NUMBER_MEDIUM, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$/$2$/$3$ $4$", [today.year, now.month, today.day, today.day_of_week]);
        dc.drawText(date_x, date_y, Graphics.FONT_XTINY, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function setStepFloorDisp(dc){
        var info = ActivityMonitor.getInfo();
        var stepString = Lang.format("$1$/$2$", [info.steps, info.stepGoal]);
        var FloorString = Lang.format("$1$/$2$", [info.floorsClimbed, info.floorsClimbedGoal]);

        stepIcon.draw(dc);
        dc.drawText(step_x + 25, step_y, Graphics.FONT_XTINY, stepString, Graphics.TEXT_JUSTIFY_LEFT);
        floorIcon.draw(dc);
        dc.drawText(floor_x + 25, floor_y, Graphics.FONT_XTINY, FloorString, Graphics.TEXT_JUSTIFY_LEFT);
    }
    
    function setActivityDisp(dc){
        // Get and show info
        var info = Activity.getActivityInfo();
        var healthyString = "--";
        var hr = info.currentHeartRate;
        if (null != hr)
        {
            healthyString = Lang.format("$1$", [hr]);
        }
        
        heartrateIcon.draw(dc);
        dc.drawText(heartrate_x + 25, heartrate_y, Graphics.FONT_XTINY, healthyString, Graphics.TEXT_JUSTIFY_LEFT);

        var pressureString = "--";
        var pressure = info.ambientPressure;
        if (null != pressure)
        {
            pressureString = pressure.format("%02d");
        }
        pressureIcon.draw(dc);
        dc.drawText(pressure_x + 25, pressure_y, Graphics.FONT_XTINY, pressureString, Graphics.TEXT_JUSTIFY_LEFT);
    }


    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}

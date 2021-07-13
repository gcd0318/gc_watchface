import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class GC_watchfaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
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
        setSystemDisp();
        setDeviceDisp();
        setDatetimeDisp();
        setStepFloorDisp();
        setActivityDisp();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }


    function setSystemDisp(){
        // Get and show the battery
        var stats = System.getSystemStats();
        var powerString = Lang.format("$1$%", [stats.battery.format("%02d")]);
        if (stats.charging)
        {
            powerString = "充电：" + powerString;
        }
        else
        {
            powerString = "电量：" + powerString;
        }
        var powerView = View.findDrawableById("PowerLabel") as Text;
        powerView.setText(powerString);
    }
    
    function setDeviceDisp(){
        var devSettings = System.getDeviceSettings();

        var deviceString = "未连接";
        var conn = devSettings.phoneConnected;
        if (conn)
        {
            deviceString = "已连接";
        }
        var deviceView = View.findDrawableById("DeviceLabel") as Text;
        deviceView.setText(deviceString);
        
        var alarms = devSettings.alarmCount;
        if (9 < alarms)
        {
            alarms = "9+";
        }
        var alarmString = "提醒：" + alarms;
        var alarmView = View.findDrawableById("AlarmLabel") as Text;
        alarmView.setText(alarmString);
        
        var notifications = devSettings.notificationCount;
        if (9 < notifications)
        {
            notifications = "9+";
        }
        var NotificationString = "消息：" + notifications;
        var NotificationView = View.findDrawableById("NotificationLabel") as Text;
        NotificationView.setText(NotificationString);
    }
    
    function setDatetimeDisp(){
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$:$2$", [now.hour, now.min.format("%02d")]);
        var timeView = View.findDrawableById("TimeLabel") as Text;
        timeView.setText(timeString);

        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$/$2$/$3$ $4$", [today.year, now.month, today.day, today.day_of_week]);
        var dateView = View.findDrawableById("DateLabel") as Text;
        dateView.setText(dateString);
    }
    
    function setStepFloorDisp(){
        var info = ActivityMonitor.getInfo();
        var stepString = Lang.format("步数：$1$/$2$", [info.steps, info.stepGoal]);
        var stepView = View.findDrawableById("StepLabel") as Text;
        stepView.setText(stepString);
        var FloorString = Lang.format("楼层：$1$/$2$", [info.floorsClimbed, info.floorsClimbedGoal]);
        var FloorView = View.findDrawableById("FloorLabel") as Text;
        FloorView.setText(FloorString);
    }
    
    function setActivityDisp(){
        // Get and show info
        var info = Activity.getActivityInfo();
        var hr = info.currentHeartRate;
        if (null == hr)
        {
            hr = "--";
        }
        var healthyString = Lang.format("心率：$1$", [hr]);
        var healthyView = View.findDrawableById("HealthyLabel") as Text;
        healthyView.setText(healthyString);

        var altString = "高度：";
        var altitude = info.altitude;
        if (null != altitude)
        {
            altString = altString + altitude.format("%02d");
        }
        var altView = View.findDrawableById("AltLabel") as Text;
        altView.setText(altString);

        var pressureString = "气压：";
        var pressure = info.ambientPressure;
        if (null != pressure)
        {
            pressureString = pressureString + pressure.format("%02d");
        }
        var pressureView = View.findDrawableById("PressureLabel") as Text;
        pressureView.setText(pressureString);
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

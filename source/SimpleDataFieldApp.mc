//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class SimpleDataField extends App.AppBase {

    var poiview; 

    function initialize() {
        AppBase.initialize();
        poiview = new POIView();
        handleSettingUpdate();
    }

    function onStart(state) {
        return false;
    }

    function getInitialView() {
        return [poiview]; //, new RaceCheatSheetDelegate()];
    }

    function onStop(state) {
        return false;
    }
    
    function onSettingsChanged() {
       handleSettingUpdate();
    	   Ui.requestUpdate();
    }
	 
	 /*function minuteToSec(min_string) {
	     var loc = min_string.find(":");
	     if (loc == null) {
	        return min_string.toNumber();
	     }
	     return min_string.substring(0, loc).toNumber() * 60 + min_string.substring(loc + 1, min_string.length()).toNumber();
	 }*/
        
     function handleSettingUpdate() {
        try {             
            poiview.updateSettings();
            
            
          
            //System.println("setting update");
	        /*var app = App.getApp();
		    var race_type = app.getProperty("PROP_DIST");
		    var dist = 42.195;
		    switch (race_type) {
		    case 1: dist = dist/2; break;
		    case 2: dist = 10; break;
		    case 3: dist = 50; break;
		    }
		    if (app.getProperty("PROP_UNIT")==0) {
		        dist = dist * 0.621371;
		    }
		    app.setProperty("p_dist", dist);
		    
		    var nmile = dist.toLong();
		    
		    var a_goal_arr = stringToArray(app.getProperty("PROP_A_GOAL"), ",", nmile, 0);
		    var b_goal_arr = stringToArray(app.getProperty("PROP_B_GOAL"), ",", nmile, 0);
		    var ws_arr = stringToArray(app.getProperty("PROP_WS"), ",", nmile, 1);  
		    var turns_arr = stringToArray(app.getProperty("PROP_TURNS"), ",", nmile, 1);  
            	        
	        app.setProperty("p_a_goal", a_goal_arr);
	        app.setProperty("p_b_goal", b_goal_arr);
	        app.setProperty("p_ws", ws_arr);
	        app.setProperty("p_turns", turns_arr);
	                
            var show_diff_opt = app.getProperty("PROP_SHOW_DIFF");
            var show_et = app.getProperty("PROP_SHOW_ET");
            var show_time = app.getProperty("PROP_SHOW_TIME");        
            
            var disp_time = new [SCREEN_MAX];
            
            var cnt = 0;

            if (a_goal_arr.size()>0) {
               disp_time[cnt] = SCREEN_PACE;
               cnt++;
                if (show_diff_opt) {
                   disp_time[cnt] = SCREEN_DIFF;
                   cnt++;
                }
            }
            
            if (ws_arr.size()>0) {
                disp_time[cnt] = SCREEN_WS;
                cnt++;
            }
            if (show_et) {
                disp_time[cnt] = SCREEN_ET;
                cnt++;
            }
            
            if (show_time) {
                disp_time[cnt] = SCREEN_TIME;
                cnt++;
            }
            
            var slides = new [cnt];
            for (var i=0; i<cnt; i++) {
                slides[i] = disp_time[i];
            }
            
            app.setProperty("p_slides", slides);     
            */     
            
        } catch (e instanceof Lang.Exception) {
            System.println(e.getErrorMessage);
        }
    }

}

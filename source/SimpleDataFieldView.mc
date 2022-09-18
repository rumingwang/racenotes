//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

//var fonts = [Gfx.FONT_XTINY,Gfx.FONT_TINY,Gfx.FONT_SMALL,Gfx.FONT_MEDIUM,Gfx.FONT_LARGE,
//             Gfx.FONT_NUMBER_MILD,Gfx.FONT_NUMBER_MEDIUM,Gfx.FONT_NUMBER_HOT,Gfx.FONT_NUMBER_THAI_HOT];
             
var colors = [ Gfx.COLOR_WHITE, Gfx.COLOR_BLACK,
               Gfx.COLOR_WHITE, Gfx.COLOR_DK_RED, 
               Gfx.COLOR_WHITE, Gfx.COLOR_DK_BLUE,
               Gfx.COLOR_DK_GREEN, Gfx.COLOR_WHITE, 
               Gfx.COLOR_ORANGE, Gfx.COLOR_WHITE];

var smallfont = Gfx.FONT_TINY;                
var bigfont = Gfx.FONT_NUMBER_MEDIUM;    

 const METERS_TO_MILES = 0.000621371;
 const METERS_TO_KMS = 0.001;                     

class POI {
    var mile;
    var label;
    var bgcolor;
    var fgcolor;
    
    function initialize(m, l, bg, fg) {
        mile = m;
        label = l;
        bgcolor = bg;
        fgcolor = fg;
    }
}

class POIView extends Ui.DataField {
    
    const MAX_POI = 50;
    
    // Layouts
    hidden var tot_wid;
    hidden var tot_height;
    
    //big font
    /*hidden var big_l_wid;
    hidden var big_cell_wid;
    hidden var big_l_font;
    hidden var big_r_font;
    hidden var big_r_t_hei;
    hidden var big_label_font;
    */
    
    hidden var g_elapse_distance;
    hidden var g_use_km;

    hidden var g_started;
    
    hidden var poi_arr;
    hidden var turns_arr;
    
    hidden var v_margin;
    hidden var v_start;
    
    function resetValues() {
        g_elapse_distance = 0;
        g_started = false;
    }

    // Constructor
    function initialize() {
        DataField.initialize();
        resetValues();
    }
    
   /* function selectFont(dc, width, height, testString) {
        var fontIdx;
        var dimensions;

        //Search through fonts from biggest to smallest
        for (fontIdx = (fonts.size() - 1); fontIdx > 0; fontIdx--) {
            dimensions = dc.getTextDimensions(testString, fonts[fontIdx]);
            if ((dimensions[0] <= width) && (dimensions[1] <= height)) {
                //If this font fits, it is the biggest one that does
                break;
            }
        }
        return fonts[fontIdx];
    }*/
    
    function onLayout(dc) {
         var dimensions = dc.getTextDimensions("26.2", smallfont);
         //v_margin = 3;
         //h_margin = 10;
         tot_wid = dc.getWidth();
         tot_height = dc.getHeight(); 
         v_margin = 2;
         v_start = dimensions[1] + v_margin + 2;
         /*  
         l_wid = tot_wid/3;
         r_wid = tot_wid - l_wid;
         v_sep_pos = l_wid + h_margin;
         l_top_height = tot_height/2;
         l_bot_height = tot_height - l_top_height;
         lh_sep_pos = l_top_height + v_margin;
         r_top_height = tot_height/2;
         r_bot_height = tot_height - l_top_height;
         rh_sep_pos = tot_height - r_top_height;
         r_cell_wid = r_wid/3;
         r1_sep_pos = v_sep_pos + r_cell_wid;      
         r2_sep_pos = r1_sep_pos + r_cell_wid;
    
         lu_font_size = selectFont(dc, l_wid, l_top_height, "26.22");
         ll_font_size = selectFont(dc, l_wid, l_bot_height, "3:25:30");
         r_font_size = selectFont(dc, r_cell_wid, r_top_height, "13.1");
         */
         
         //Big Font
         //big_l_wid = tot_wid/5;
         //big_cell_wid = tot_wid*2/5;
         //big_r_t_hei = tot_height/4;
         //big_l_font = selectFont(dc, big_l_wid, tot_height, "11.1");
         //big_r_font = selectFont(dc, big_cell_wid, tot_height, "26.2");  
         //big_label_font = selectFont(dc, tot_wid - big_l_wid, big_r_t_hei, "Est Finish Time");   
        
    }
  

    // Handle the update event
    function compute(info) {   
               
        try {
	        if (info has :elapsedDistance && info.elapsedDistance!=null) {
	            if (g_use_km==0) {
	                g_elapse_distance = info.elapsedDistance * METERS_TO_MILES;
	            }
	            else {
	                g_elapse_distance = info.elapsedDistance * METERS_TO_KMS;
	            }
	        }
	        else {
	            g_elapse_distance = 0;
	        }
	        
	    } catch (e instanceof Lang.Exception) {
            System.println(e.getErrorMessage);
        }
    }
    

    
    function drawTurns(dc) {
         var barwidth = 15;
         for (var i=0; i<turns_arr.size(); i++) {
              var val = turns_arr[i];
              var pval = val;
              if (val<0) {
                  pval = val*(-1);
              }
              if (pval>g_elapse_distance) {
              	  dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
                  if (val<0) {
                       dc.fillRectangle(0, 0, barwidth, tot_height);                
                  }
                  else {
                       dc.fillRectangle(tot_wid-barwidth, 0, barwidth, tot_height); 
                  }
              	 break;
              }
         }
    }
	 
	function drawWaterStation(dc, n_cell, x_start, cell_wid) {
	          // Water stations         
         var counter = 0;
        
         for (var i=0; i<poi_arr.size(); i++) {
             var poi = poi_arr[i];
             var pval = poi.mile;
 
             if (pval>g_elapse_distance) {  
                 if (counter==0) {
                     dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);  
                     var togo = pval - g_elapse_distance;
                 	 dc.drawText(tot_wid/5, v_start , Gfx.FONT_NUMBER_MEDIUM, togo.format("%.1f"), Gfx.TEXT_JUSTIFY_CENTER); 
                 } 
                 dc.setColor(poi.fgcolor, poi.bgcolor);    
                 var x =  x_start + counter * cell_wid + cell_wid/2;  
                 dc.drawText(x, v_start , Gfx.FONT_NUMBER_MEDIUM, pval.format("%.1f"), Gfx.TEXT_JUSTIFY_CENTER); 
                 if (poi.label!="") {
                     dc.drawText(x, v_margin, Gfx.FONT_TINY, poi.label, Gfx.TEXT_JUSTIFY_CENTER);
                 }     
                // dc.drawText(v_sep_pos + counter * r_cell_wid + r_cell_wid/2, rh_sep_pos, r_font_size, pval.format("%.1f"), Gfx.TEXT_JUSTIFY_CENTER);
                 if (counter>n_cell-2) {
                     break;
                 }
                 counter++;
             }
         }
     }
     
     //function drawBigRightLabel(dc, lab) {
       //   dc.drawText(big_l_wid+ big_cell_wid, v_margin, big_label_font, lab, Gfx.TEXT_JUSTIFY_CENTER);	
     //}
     
     /*function drawTime(dc, bot_y, n_seconds) {
        dc.drawText(h_margin + big_l_wid, bot_y, big_l_font, secondsToString(n_seconds), Gfx.TEXT_JUSTIFY_LEFT);
        
        if (g_delta>0) {
           dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        }
        else {
           dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        }
        dc.drawText(h_margin + tot_wid, bot_y+5, Gfx.FONT_LARGE, g_delta_str, Gfx.TEXT_JUSTIFY_RIGHT);
    }*/
    
    function onUpdate(dc) {	
         
        try {  
            	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	        dc.clear();               	         
	            
	        //var line_color = Gfx.COLOR_BLUE;
	       /* if (g_use_km!=0) {
	             line_color = Gfx.COLOR_LT_GRAY;       
	        }*/
	        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);      
	        dc.drawLine(tot_wid/3, 0, tot_wid/3, tot_height);
	        
	        /*if (g_use_km!=0) {
	            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_LT_GRAY);
	            dc.drawText(h_margin + big_l_wid - 3, v_margin, Gfx.FONT_XTINY, "k", Gfx.TEXT_JUSTIFY_CENTER); 
	        }*/
	        
	       // dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
	        //dc.drawText(h_margin + big_l_wid/2, v_margin , big_l_font, int_distance, Gfx.TEXT_JUSTIFY_CENTER);    
	        //dc.drawText(h_margin + big_l_wid/2, v_margin + big_r_t_hei*3 - 5 , big_label_font, frac_dist, Gfx.TEXT_JUSTIFY_CENTER);
	        //if  ( g_elapse_distance != int_distance ) {
	        //    dc.drawText(h_margin + big_l_wid/2, v_margin + big_r_t_hei*3 - 10, Gfx.FONT_LARGE, frac_dist, Gfx.TEXT_JUSTIFY_CENTER);
	        //}
		    			  
	        
	        /*if(!g_started) {
	            	if (g_use_km) {
	            	    drawBigRightLabel(dc, "Distance (km)");
	     	    }
	            else {
	                drawBigRightLabel(dc, "Distance (mile)");
	            }
	            
//	            var mile_str = s_tot_miles.format("%.1f");        
//	            dc.drawText(h_margin + big_l_wid + 5, bot_y, big_l_font, mile_str, Gfx.TEXT_JUSTIFY_LEFT);
//	            dc.drawText(tot_wid, bot_y+5, Gfx.FONT_LARGE, secondsToPace(g_average_pace), Gfx.TEXT_JUSTIFY_RIGHT);
	        }  
	        else {
	            //drawBigRightLabel(dc, "Water Stations");
	            drawWaterStation(dc, int_distance, 2, h_margin + big_l_wid, bot_y, big_cell_wid, big_r_font);
	        } */  
	        drawTurns(dc);
	        drawWaterStation(dc, 2, tot_wid/3, tot_wid/3);    
        } catch (e instanceof Lang.Exception) {
            System.println(e.getErrorMessage);
        }
    }

    function onTimerStart() {
         resetValues();
         g_started = true;
    }
    
    function onTimerStop() {
         g_started = false;
    }
    
    function onTimerLap(){
        
    }
    
    function addPOI(arr, idx, data, theme) {
        var mile = data;
        var label = "";
        var loc = data.find(":");
        if (loc !=null) {
            mile = data.substring(0,loc);
            label = data.substring(loc+1, data.length());
            //System.println(label);
        }
            
        var poi = new POI(mile.toFloat(), label, colors[2*theme], colors[2*theme+1]);
	    arr[idx] = poi;
    }
    
    	function stringToArray(string, splitter, arr, first, max, theme) {
	    if (string.length()<1){
	         return 0;
	    }

	    var index = 0;
	    var location;
	    do
	    {
	        location = string.find(splitter);
	        if (location != null) {
	            addPOI(arr, first + index, string.substring(0, location), theme);
	            string = string.substring(location + 1, string.length());
	            index++;
	        }
	    }
	    while (location != null && (first+index)<max);
	    
	    if ((first+index)<max && string!=null) {
	        addPOI(arr, first + index, string, theme);
	        index++;
	    }
	
	    return index;  
	 }
	 
	function stringToTurnsArray(string, splitter, max_size) {
	    if (string.length()<1){
	         return [];
	    }
	    var array = new [max_size];
	    var index = 0;
	    var location;
	    do
	    {
	        location = string.find(splitter);
	        if (location != null) {
	            array[index] = string.substring(0, location).toFloat();
	            string = string.substring(location + 1, string.length());
	            index++;
	        }
	    }
	    while (location != null && index<max_size);
	    
	    if (index<max_size && string!=null) {
	        array[index] = string.toFloat();
	        index++;
	    }
	    return array.slice(0,index);
	 }
	 
	 function sort(arr) {
	     var i = 1;
	     while (i < arr.size()) {
	         var j = i;
	         while (j>0 && arr[j-1].mile> arr[j].mile) {
	              var tmp = arr[j-1];
	              arr[j-1] = arr[j];
	              arr[j] = tmp;
	              j = j-1;
	         }
	         i = i + 1;
	     }
	 }
    
    function updateSettings() {
    
        g_use_km = App.getApp().getProperty("PROP_UNIT");
        
        var arr = new[MAX_POI];
        
        var first = 0;
        var count = 0;
        var i;
        for (i=1; i<=5; i++) {
            var miles = App.getApp().getProperty("PROP_DIST" + i);
            if (miles==null) {
                continue;
            }
            count = stringToArray(miles, ",", arr, first, MAX_POI, i);
            first = first + count;
        }
        //count = stringToArray("2.3,1.3,2.4,3.5,0.7", ",", poi_arr, first, MAX_POI);
        poi_arr = arr.slice(0, first);
        
        sort(poi_arr);
        
        turns_arr = stringToTurnsArray(App.getApp().getProperty("PROP_TURNS"), ",",100); 
        
        //var arr = new [2];
        //arr[0] = new POI(1.5, "l", "R");
        //arr[1] = new POI(2.5, "yes", "R");
        //for (i=0; i<first; i++) {
        //    System.println(poi_arr[i].mile + " " + poi_arr[i].label + " " + poi_arr[i].bgcolor + " " + poi_arr[i].fgcolor);
        //}
    }
}

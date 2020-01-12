/*
	GranTech
	Copyright 2019 Gran Tech. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

 package ir.grantech.canvas.controls;

 import openfl.display.BitmapData;
import feathers.core.IUIControl;

/**
   A user interface control that displays bitmap data.
 
   @since 1.0.0
 **/
 interface IIconControl extends IUIControl {
   /**
     The bitmap data to display.
 
     @since 1.0.0
   **/
   public var icon(get, set):BitmapData;
 }
 
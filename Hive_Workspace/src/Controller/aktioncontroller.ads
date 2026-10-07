-- Glib Packages
with Glib;                     use Glib;
with Glib.Error;               use Glib.Error;
with Glib.Object;					use Glib.Object;

--- GTK Packages
with Gtk.Status_Bar;				use Gtk.Status_Bar;

with Gtkada.Style;             use Gtkada.Style;
with Gtkada.Canvas_View;       use Gtkada.Canvas_View;
with Gtkada.Canvas_View.Views; use Gtkada.Canvas_View.Views;

with Gdk.Pixbuf;               use Gdk.Pixbuf;

-- Eigene Packages 
with Grundtypen;					use Grundtypen;
with Anzeigeelemente;
with Spielzuege;
with Spieler;

-- Ada Packages
with Ada.Text_IO;					use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions;
with Ada.Tags;					use Ada.Tags;

package AktionController is
   
   Wahl_Image : Image_Item;
   
   function On_Vorrat_Event (View  : not null access GObject_Record'Class; Event : Event_Details_Access) return Boolean;
   
   function On_Spielfeld_Event (View  : not null access GObject_Record'Class; Event : Event_Details_Access) return Boolean;

end AktionController;

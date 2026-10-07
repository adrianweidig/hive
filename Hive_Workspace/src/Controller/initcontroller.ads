-- Glib Packages
with Glib;                     use Glib;
with Glib.Error;               use Glib.Error;
with Glib.Object;					use Glib.Object;

--- GTK Packages
with Gtkada.Style;             use Gtkada.Style;
with Gtkada.Canvas_View;       use Gtkada.Canvas_View;
with Gtkada.Canvas_View.Views; use Gtkada.Canvas_View.Views;

with Gdk.Pixbuf;               use Gdk.Pixbuf;

-- Eigene Packages 
with Grundtypen;					use Grundtypen;
with Anzeigeelemente;
with AktionController;

-- Ada Packages
with Ada.Text_IO;					use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions;
with Ada.Tags;					use Ada.Tags;

package InitController is
   
   
   
   
   
   procedure Init_Spielbrett (Brett : in out Grundtypen.Spielbrett);
   
      
   procedure Init_Vorraete;
end InitController;

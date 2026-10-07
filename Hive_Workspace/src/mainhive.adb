with Ada.Exceptions;

--- GTK Packages
with Gtk;          use Gtk;
with Gtk.Main;     use Gtk.Main;
with Gtk.Window;   use Gtk.Window;

-- Glib Packages
with Glib;         use Glib;
with Glib.Error;   use Glib.Error;

-- Gtkada Packages
with Gtkada.Builder;     use Gtkada.Builder;

-- Ada Packages
with Ada.Text_IO;        use Ada.Text_IO;

-- Eigene Packages
with MainController;
with Grundtypen;
with Anzeigeelemente;

with Gtk.Widget; use Gtk.Widget;
with Glib.Object; use Glib.Object;
with Gdk.Window; use Gdk.Window;
procedure MainHive is

   
   Builder      : Gtkada_Builder;
   Error        : aliased Glib.Error.GError;
   Return_Code  : Guint;
   
   
 
begin

   -- Initialisieren der Glade Elemente
   Gtk.Main.Init;
   Gtk_New (Builder);
   
   Return_Code := Add_From_File (Builder  => Builder,
                                 Filename => "src\View\Hive.glade",
                                 Error    => Error'Access);
   if Error /= null then
      Ada.Text_IO.Put_Line ("Error : " & Get_Message (Error));
      Error_Free (Error);
      return;
   end if;
   
   ---- HIER MUSS DIE MAINCONTROLLER.START O.Ä. AUFGERUFEN WERDEN
   
   MainController.Start(Der_Builder => Builder,Das_Brett => Grundtypen.Brett);
   
   Anzeigeelemente.Fenster.Maximize;
   Anzeigeelemente.Fenster.Fullscreen;
   
   -- Anzeige aller Elemente ueber z.B.
   Anzeigeelemente.Fenster.Show_All;
   Anzeigeelemente.Fenster.Present;
   
   Gtk.Main.Main;

   Unref (Builder);
exception
   when E:others =>
      Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(E) & " " & Ada.Exceptions.Exception_Message(E));

end MainHive;

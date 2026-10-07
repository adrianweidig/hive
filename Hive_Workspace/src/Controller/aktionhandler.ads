-- Allg Packages
with Interfaces.C;
with Ada.Text_IO;

-- Gtk Packages
with Gtk.Menu_Item;  use Gtk.Menu_Item;
with Gtk.Main;
with Gtkada.Canvas_View;
with Gtk.Status_Bar; use Gtk.Status_Bar;

-- Eigene Packages
with InitController;
with Grundtypen;			use Grundtypen;
with Anzeigeelemente;
with Spieler;

package AktionHandler is

   --Fuer das Starten dern Anleitung
   package C renames Interfaces.C;
   use type C.int;

   function system (command : C.char_array) return C.int
     with Import, Convention => C;

   -- Pfad der Anleitung
   Batch_Befehl : aliased constant C.char_array :=
     C.To_C ("start ..\Dokumente\Hive_Brettspiel_Anleitung.pdf");

   Ergebnis_Anleitung_Start : C.int;

   Gestartet : Boolean := False;

   procedure Neues_Spiel_Starten (this : access Gtk_Menu_Item_Record'Class);

   procedure Spiel_Beenden (this : access Gtk_Menu_Item_Record'Class);

   procedure Anleitung_Starten (this : access Gtk_Menu_Item_Record'Class);

end AktionHandler;

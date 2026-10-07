-- Gtk Packages
with Gtk.Window;    			use Gtk.Window;
with Gtk.Box;       			use Gtk.Box;
with Gtk.Menu;      			use Gtk.Menu;
with Gtk.Menu_Bar;  			use Gtk.Menu_Bar;
with Gtk.Menu_Item; 			use Gtk.Menu_Item;
with Gtk.Button;    			use Gtk.Button;
with Gtk.Frame;     			use Gtk.Frame;
with Gtk.Label;     			use Gtk.Label;
with Gtk.Status_Bar; 		use Gtk.Status_Bar;
with Gtkada.Builder;			use Gtkada.Builder;
with Gtk.Separator; 			use Gtk.Separator;
with Gtk.Scrolled_Window;	use Gtk.Scrolled_Window;

-- Eigene Packages
with InitController;
with AktionHandler;			use AktionHandler;
with Anzeigeelemente;		use Anzeigeelemente;
with Grundtypen;				use Grundtypen;


package MainController is

   -- Initialisieren der widgets
   -- zuweisen der handler zu den widgets
   procedure Start(Der_Builder : Gtkada_Builder; Das_Brett : in out Grundtypen.Spielbrett);


   procedure Spielzug ( Brett : in out Grundtypen.Spielbrett);

   -- beendet das Spiel, sorgt für das Aufraeumen der Daten und triggert die
   -- Gewinn oder Unentschieden Nachricht.
   procedure Ende;

end MainController;

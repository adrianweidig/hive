

package body AktionHandler is

   -----------------
   -- Neues_Spiel --
   -----------------
   procedure Neues_Spiel_Starten (this : access Gtk_Menu_Item_Record'Class) is
      pragma Unreferenced(this);

      Status           : Context_Id := 0;
      Status_Nachricht : Message_Id;

      procedure StarteRunde is
      begin
         Spieler.Aktueller_Spieler := Weiss;
         Anzahl_Zuege := 0;

         Gestartet := True;
         Grundtypen.Brett := new Grundtypen.SPIELBRETT_TR;
         -- Initialisieren des Bretts als Canvas View
         Gtkada.Canvas_View.Initialize(Grundtypen.Brett);
         InitController.Init_Spielbrett(Grundtypen.Brett);
         InitController.Init_Vorraete;
         Anzeigeelemente.Scrolled_Brett.Add(Grundtypen.Brett);
         Anzeigeelemente.Fenster.Show_all;

         Status_Nachricht := Gtk.Status_Bar.Push(Statusbar => Anzeigeelemente.Status_Spieler,
                                                 Context   => Status,
                                                 Text      => "Aktueller Spieler: " & FARBEN_T'Image(Spieler.Aktueller_Spieler));

         Status_Nachricht := Gtk.Status_Bar.Push(Statusbar => Anzeigeelemente.Status_Zug,
                                                 Context   => Status,
                                                 Text      => "Anzahl Zuege:" & Integer'Image(Grundtypen.Anzahl_Zuege));
      end StarteRunde;

      procedure BeendeRunde is
      begin
         Anzeigeelemente.Scrolled_Brett.Remove(Grundtypen.Brett);
         Anzeigeelemente.Frame_Schwarzer_Schwarm.Remove(Vorrat1);
         Anzeigeelemente.Frame_Weisser_Schwarm.Remove(Vorrat2);
         Gestartet := False;
      end BeendeRunde;

   begin

      If not Gestartet then

         StarteRunde;

      else

         BeendeRunde;
         StarteRunde;

      end if;


   end Neues_Spiel_Starten;

   -----------------------------
   -- Beenden ueber das Menue --
   -----------------------------

   procedure Spiel_Beenden (this : access Gtk_Menu_Item_Record'Class)is
      pragma Unreferenced(this);
   begin
      -- das Spiel wird beendet
      Gtk.Main.Main_Quit;
   end Spiel_Beenden;

   -------------------------------
   -- Anleitung ueber das Menue --
   -------------------------------

   procedure Anleitung_Starten (this : access Gtk_Menu_Item_Record'Class)is
      pragma Unreferenced(this);
   begin
      Ergebnis_Anleitung_Start := system (Batch_Befehl);
      if Ergebnis_Anleitung_Start /= 0 then
         Ada.Text_IO.Put_Line ("Fehler beim laden der Anleitung");
         Ada.Text_IO.Put_Line ("Eventuell ist die Datei nicht vorhanden!");
      end if;
   end Anleitung_Starten;

end AktionHandler;

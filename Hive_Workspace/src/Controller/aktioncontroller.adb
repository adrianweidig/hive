package body AktionController is
   
   -- Vorrats-Events   

   procedure Vorrat_Highlight is
      Image_Buffer	: Gdk_Pixbuf;
      Ein_Error		: aliased Glib.Error.GError;
   begin
      if Ausgewaehlter_Stein /= null then

         Gdk_New_From_File(Pixbuf		=> Image_Buffer,
                           Filename		=> "resource\HIGHLIGHT.png",
                           Error			=> Ein_Error);
         
         Image_Buffer:= Gdk.Pixbuf.Scale_Simple(Src         => Image_Buffer,
                                                Dest_Width  => Gint(Ada.Numerics.Elementary_Functions.Sqrt(X => 3.0) * Grundtypen.Kantenlaenge),
                                                Dest_Height => Gint(2.0 * Grundtypen.Kantenlaenge));
         
         Wahl_Image := new Image_Item_Record;

         Wahl_Image.Set_Position(Pos => (Ausgewaehlter_Stein.Position.X, Ausgewaehlter_Stein.Position.Y));
      
         Wahl_Image.Initialize_Image(Style => Gtk_New (Stroke => (0.0, 0.0, 0.0, 0.0)), -- Maximal Transparent
                                     Image => Image_Buffer);
         
         
      
         case Spieler.Aktueller_Spieler is
         when Grundtypen.Schwarz => 
            Vorrat1.Model.Raise_Item(Ausgewaehlter_Stein);
            Vorrat1_Model_List.Add(Wahl_Image);
            Vorrat1.Model.Refresh_Layout;
         when Grundtypen.Weiss => 
            Vorrat2.Model.Raise_Item(Ausgewaehlter_Stein);
            Vorrat2_Model_List.Add(Wahl_Image);
            Vorrat2.Model.Refresh_Layout;
         end case;
         
         
      else 
         if Wahl_Image /= null then
            case Spieler.Aktueller_Spieler is
            when Grundtypen.Schwarz => 
               Vorrat1_Model_List.Remove(Wahl_Image);
            when Grundtypen.Weiss => 
               Vorrat2_Model_List.Remove(Wahl_Image);
            end case;
  
            Wahl_Image := null;
         end if;
      end if;
         
   end Vorrat_Highlight;
   
   procedure Vorrat_Press(Koord_Liste : in out Grundtypen.KOORDINATEN_LIST_PTR; Der_Stein : Spielstein) is

      Array_X, Array_Y : Integer;
      X, Y				: Gdouble;
      Tmp_Image		: Image_Item;
      Image_Buffer	: Gdk_Pixbuf;
      Ein_Error		: aliased Glib.Error.GError;
      
      
   begin

      if Ausgewaehlter_Stein = null then
         
         
         Ausgewaehlter_Stein := Der_Stein;
         
         Vorrat_Highlight;

         loop
            
            Gdk_New_From_File(Pixbuf		=> Image_Buffer,
                              Filename		=> "resource\HIGHLIGHT.png",
                              Error			=> Ein_Error);
         
            Image_Buffer:= Gdk.Pixbuf.Scale_Simple(Src         => Image_Buffer,
                                                   Dest_Width  => Gint(Ada.Numerics.Elementary_Functions.Sqrt(X => 3.0) * Grundtypen.Kantenlaenge),
                                                   Dest_Height => Gint(2.0 * Grundtypen.Kantenlaenge));
            
            
            Array_X := Koord_Liste.Koordinaten.Z;
            Array_Y := Koord_Liste.Koordinaten.S;
            X			:= Grundtypen.Brett.Felder(Array_X, Array_Y).Position.X;
            Y			:= Grundtypen.Brett.Felder(Array_X, Array_Y).Position.Y;
            
           

            Tmp_Image := new Image_Item_Record;

            Tmp_Image.Set_Position(Pos => (X, Y));
      
            Tmp_Image.Initialize_Image(Style => Gtk_New (Stroke => (0.0, 0.0, 0.0, 0.0)), -- Maximal Transparent
                                       Image => Image_Buffer);
         
            Grundtypen.Canvas_Model_List.Add(Tmp_Image);
         
            Grundtypen.Brett.Felder(Array_X, Array_Y).Highlight := Tmp_Image;
            
            Grundtypen.Brett.Model.Refresh_Layout;
                  
            Koord_Liste := Koord_Liste.Next_Ptr;
            exit when Koord_Liste = null;
         end loop;
      
         
        
         -- Else tritt auch ein, wenn ein anderer Stein angeklickt wird
      else
         Ausgewaehlter_Stein := null;

         for Zeile in Brett.Felder'Range(1) loop
            for Spalte in Brett.Felder'Range(2) loop
               if Brett.Felder(Zeile, Spalte) /= null and then Brett.Felder(Zeile, Spalte).Highlight /= null then
                  Grundtypen.Canvas_Model_List.Remove(Brett.Felder(Zeile, Spalte).Highlight);
                  Brett.Felder(Zeile, Spalte).Highlight := null;
               end if;
            end loop;
         end loop;

         Vorrat_Highlight;

         Vorrat_Press(Koord_Liste, Der_Stein);
      end if;
         
      Grundtypen.Brett.Model.Refresh_Layout;
      

   end Vorrat_Press;
   
   function On_Vorrat_Event (View  : not null access GObject_Record'Class; Event : Event_Details_Access) return Boolean is
     
      Koordinaten_Liste : Grundtypen.KOORDINATEN_LIST_PTR := null;
      
   begin
      -- TODO: Spielerfarbe global zugreifbar machen um entsprechend nur diese Steine auswaehlbar zu machen   
      if Event.Toplevel_Item /= null and not Grundtypen.SpielBeendet then

         if External_Tag (Event.Toplevel_Item'Tag) = "GRUNDTYPEN.SPIELSTEIN_C" and then Spielstein(Event.Toplevel_Item).Farbe = Spieler.Aktueller_Spieler then
            case Event.Event_Type is

            when Button_Press 
               => Koordinaten_Liste := Spielzuege.Spielstein_Setzen_Moeglichkeiten(Brett   => Grundtypen.Brett,
                                                                                   Spieler => Spieler.Aktueller_Spieler);

               Vorrat_Press(Koordinaten_Liste, Spielstein(Event.Toplevel_Item));

            when others => null;

            end case;

         end if;

      end if;
      
      return True;

   end On_Vorrat_Event;
   
   function Get_Feld(X : Gdouble; Y : Gdouble) return Spielfeld is
      Return_Feld : Spielfeld;
      Tmp_Feld    : Spielfeld;
   begin
      
      for Zeile in Brett.Felder'Range(1) loop
         for Spalte in Brett.Felder'Range(2) loop
            Tmp_Feld := Brett.Felder(Zeile, Spalte);

            if Tmp_Feld.Position.X = X and Tmp_Feld.Position.Y = Y then 
               Return_Feld := Tmp_Feld;
            end if;
            
         end loop;
      end loop;

      return Return_Feld;
   end Get_Feld;
   
   -- Spielbrett-Events
   function On_Spielfeld_Event (View  : not null access GObject_Record'Class; Event : Event_Details_Access) return Boolean is
      Highlight_Image : Image_Item;
      Feld : Spielfeld;
      
      ErgebnisMeldung : String(1..15);
      
      SuperCount : Integer := 0;
      
      Status           : Context_Id := 0;
      Status_Nachricht : Message_Id;
      
      Schwarz_Steht : Boolean	:= False;
      Weiss_Steht : Boolean		:= False;
      
      Koordinaten_Liste : Grundtypen.KOORDINATEN_LIST_PTR := null;
      
      
      Array_X, Array_Y : Integer;
      X, Y				: Gdouble;
      Tmp_Image		: Image_Item;
      Image_Buffer	: Gdk_Pixbuf;
      Ein_Error		: aliased Glib.Error.GError;
   begin

      if Event.Toplevel_Item /= null and not Grundtypen.SpielBeendet then
         
         -- True = Highlight Image
         if External_Tag (Event.Toplevel_Item'Tag) = "GTKADA.CANVAS_VIEW.IMAGE_ITEM_RECORD" then
            
            Highlight_Image := Image_Item(Event.Toplevel_Item);
            case Event.Event_Type is
            when Button_Press
               => Feld := Get_Feld(Highlight_Image.Position.X, Highlight_Image.Position.Y);     
               
               case Spieler.Aktueller_Spieler is
               when Grundtypen.Schwarz =>
                  Vorrat1_Model_List.Remove(Wahl_Image);
                  if Ausgewaehlter_Stein.Art = Bienenkoenigin then 
                     Spieler.Biene_Schwarz := True; 
                  end if;
                  Vorrat1.Model.Refresh_Layout;
                  when Grundtypen.Weiss =>
                     Vorrat2_Model_List.Remove(Wahl_Image);
                     if Ausgewaehlter_Stein.Art = Bienenkoenigin then 
                        Spieler.Biene_Weiss := True; 
                     end if;
                     Vorrat2.Model.Refresh_Layout;
               end case;

               Ausgewaehlter_Stein.Set_Position(Pos => (Highlight_Image.Position.X, Highlight_Image.Position.Y));
               
               Grundtypen.Canvas_Model_List.Add(Ausgewaehlter_Stein);
               
               Feld.Figur := Ausgewaehlter_Stein;
               Feld.Figur.Akt_Pos := new KOORDINATEN_TR'(Z => Feld.Koordinaten.Z,
                                                         S => Feld.Koordinaten.S);

               for Zeile in Brett.Felder'Range(1) loop
                  for Spalte in Brett.Felder'Range(2) loop
                     if Brett.Felder(Zeile, Spalte).Figur /= Null then
                        SuperCount := SuperCount + 1;
                     end if;
                     
                     if Brett.Felder(Zeile, Spalte).Highlight /= null then
                        Grundtypen.Canvas_Model_List.Remove(Brett.Felder(Zeile, Spalte).Highlight);
                        Brett.Felder(Zeile, Spalte).Highlight := null;
                     end if;
                  end loop;
               end loop;
               -- Aktualisiert die Anzeige
               
               Brett.SteineGespielt := SuperCount;
               Put_Line(integer'Image(Brett.SteineGespielt) & "Steine gespielt ");
               Wahl_Image := null;
               Ausgewaehlter_Stein := null;
               

                
               
               Grundtypen.Brett.Model.Refresh_Layout;

               when others => null;
            end case;
            
            
            

            -- Spielerwechsel
            case Spieler.Aktueller_Spieler is
               when Grundtypen.Schwarz =>
                  Put_Line("Spielerwechsel Weiss");
                  Spieler.Aktueller_Spieler := Weiss;
               when Grundtypen.Weiss =>
                  Put_Line("Spielerwechsel Schwarz");
                  Spieler.Aktueller_Spieler := Schwarz;

            end case;
            Grundtypen.SpielBeendet := Grundtypen.Spielende(Brett => Grundtypen.Brett,
                                                            Farbe => Spieler.Aktueller_Spieler);

            if Grundtypen.SpielBeendet then
               ErgebnisMeldung := Spielergebnis(Brett => Grundtypen.Brett);
            end if;
            
            if SpielBeendet then
               Status_Nachricht := Gtk.Status_Bar.Push(Statusbar => Anzeigeelemente.Status_Spieler,
                                                       Context   => Status,
                                                       Text      => ErgebnisMeldung);
               if Grundtypen.Hat_Gewonnen = Grundtypen.Weiss then
                  Gdk_New_From_File(Pixbuf		=> Image_Buffer,
                                    Filename		=> "resource\ADA_WEISS.png",
                                    Error			=> Ein_Error);
               elsif Grundtypen.Hat_Gewonnen = Grundtypen.Schwarz then
                  Gdk_New_From_File(Pixbuf		=> Image_Buffer,
                                    Filename		=> "resource\ADA_SCHWARZ.png",
                                    Error			=> Ein_Error);
               end if;
               
               for Zeile in Grundtypen.Brett.Felder'Range(1) loop
                  for Spalte in Grundtypen.Brett.Felder'Range(2) loop
                     if Brett.Felder(Zeile, Spalte).Figur = Null then
                        Image_Buffer:= Gdk.Pixbuf.Scale_Simple(Src         => Image_Buffer,
                                                               Dest_Width  => Gint(Ada.Numerics.Elementary_Functions.Sqrt(X => 3.0) * Grundtypen.Kantenlaenge),
                                                               Dest_Height => Gint(2.0 * Grundtypen.Kantenlaenge));
            
            
                        Array_X := Zeile;
                        Array_Y := Spalte;
                        X			:= Grundtypen.Brett.Felder(Array_X, Array_Y).Position.X;
                        Y			:= Grundtypen.Brett.Felder(Array_X, Array_Y).Position.Y;
            
           

                        Tmp_Image := new Image_Item_Record;

                        Tmp_Image.Set_Position(Pos => (X, Y));
      
                        Tmp_Image.Initialize_Image(Style => Gtk_New (Stroke => (0.0, 0.0, 0.0, 0.0)), -- Maximal Transparent
                                                   Image => Image_Buffer);
         
                        Grundtypen.Canvas_Model_List.Add(Tmp_Image);
         
                        Grundtypen.Brett.Felder(Array_X, Array_Y).Highlight := Tmp_Image;
                     end if;
                  end loop;
               end loop;
               
            
               Grundtypen.Brett.Model.Refresh_Layout;
               
            else
               
               Status_Nachricht := Gtk.Status_Bar.Push(Statusbar => Anzeigeelemente.Status_Spieler,
                                                       Context   => Status,
                                                       Text      => "Aktueller Spieler: " & FARBEN_T'Image(Spieler.Aktueller_Spieler));
            end if;
          
            Grundtypen.Anzahl_Zuege := Grundtypen.Anzahl_Zuege + 1;
            
            Status_Nachricht := Gtk.Status_Bar.Push(Statusbar => Anzeigeelemente.Status_Zug,
                                                    Context   => Status,
                                                    Text      => "Anzahl Zuege:" & Integer'Image(Grundtypen.Anzahl_Zuege));
            
         

         end if;
         
         -- True = Spielfeld
         if External_Tag (Event.Toplevel_Item'Tag) = "GRUNDTYPEN.SPIELFELD_TR" then
            case Event.Event_Type is
               when Button_Press
                  =>  Feld := Spielfeld(Event.Toplevel_Item);
            
                  -- Gibt Position des angeklickten Feldes aus
                  Put_Line(Integer'Image(Feld.Koordinaten.Z) & " | " & Integer'Image(Feld.Koordinaten.S));
            
                  -- Gibt Position des angeklickten Feldes aus
                  Put_Line(Gdouble'Image(Feld.Position.X) & " | " & Gdouble'Image(Feld.Position.Y));

               when others => null;
            end case;
         end if;
         
         

         if External_Tag (Event.Toplevel_Item'Tag) = "GRUNDTYPEN.SPIELSTEIN_C" 
           and then Spielstein(Event.Toplevel_Item).Farbe = Spieler.Aktueller_Spieler then
            

          

            Schwarz_Steht := (if Spielstein(Event.Toplevel_Item).Farbe = Schwarz and Spieler.Biene_Schwarz then True else False);
            Weiss_Steht := (if Spielstein(Event.Toplevel_Item).Farbe = Weiss and Spieler.Biene_Weiss then True else False);            

            if Schwarz_Steht or Weiss_Steht then
               
               
               case Event.Event_Type is
                  when Button_Press 
                     => 
                     Koordinaten_Liste := Grundtypen.MglSpz(Stein => Spielstein(Event.Toplevel_Item),
                                                            Brett => Grundtypen.Brett);
                     
                     Put_Line(Boolean'Image(Koordinaten_Liste = null) & "<----------------------------" );
                     Vorrat_Press(Koordinaten_Liste, Spielstein(Event.Toplevel_Item));
                     
                     Feld := Get_Feld(Spielstein(Event.Toplevel_Item).Position.X, Spielstein(Event.Toplevel_Item).Position.Y); 
                     
                     Feld.Figur := null;

                  when others => null;

               end case;

            end if;
         end if;
      end if;
    
      return True;
   end On_Spielfeld_Event;
end AktionController;

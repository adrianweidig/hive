package body InitController is
  
   procedure InitFelderPositionen (Brett : in out Grundtypen.Spielbrett) is
      X_Koordinate : Gdouble := 0.0;
      Y_Koordinate : Gdouble := 0.0;
      --TO DO Kantenlaenge 
      X_Versatz : Gdouble := Gdouble(Ada.Numerics.Elementary_Functions.Sqrt(X => 3.0) * Grundtypen.Kantenlaenge);
      Y_Versatz : Gdouble := Gdouble(1.5 * Grundtypen.Kantenlaenge);
   begin
      for Zeile in Brett.Felder'Range(1) loop
         
         -- Platziert die Sechsecke in Zwei Reihen
      
         if Zeile mod 2 = 1 then
            X_Koordinate := X_Versatz / 2.0;
         elsif Zeile mod 2 = 0 then
            X_Koordinate := 0.0;
         end if;
         
         for Spalte in Brett.Felder'Range(2) loop
            Brett.Felder(Zeile, Spalte) := new Grundtypen.SPIELFELD_TR;
            Brett.Felder(Zeile, Spalte).Set_Position(Pos => (X_Koordinate, Y_Koordinate));
            X_Koordinate := X_Koordinate + X_Versatz;
            
            Brett.Felder(Zeile,Spalte).Set_Size(Width  => (Unit_Pixels, X_Versatz),
                                                Height => (Unit_Pixels, Gdouble(2.0 * Grundtypen.Kantenlaenge)));
            
           
            
         end loop;
         
         -- Sobald die Zeile beendet ist faengt es wieder komplett links an und 
         -- Pruefung ob gerade oder ungerade je nachdem wird x start versetzt
         Y_Koordinate := Y_Koordinate + Y_Versatz;
         
        
         
      end loop;
   end InitFelderPositionen;
   
   procedure InitLeerBild (Feld : Grundtypen.Spielfeld) is
       
      Image_Buffer     : Gdk_Pixbuf;
      Ein_Error        : aliased Glib.Error.GError;
      
   begin
      Gdk_New_From_File(Pixbuf   => Image_Buffer,
                        Filename => "resource/Leeres_Hexagon.png", 
                        Error    => Ein_Error);
      
      Image_Buffer:= Gdk.Pixbuf.Scale_Simple(Src         => Image_Buffer,
                                             Dest_Width  => Gint(Ada.Numerics.Elementary_Functions.Sqrt(X => 3.0) * Grundtypen.Kantenlaenge),
                                             Dest_Height => Gint(2.0 * Grundtypen.Kantenlaenge));
      
      if Ein_Error /= null then
         Ada.Text_IO.Put_Line ("Error : " & Get_Message (Ein_Error));
         Error_Free (Ein_Error);
         return;
      end if;
      
      Feld.Initialize_Image(Style         => Gtk_New (Stroke => (0.0, 0.0, 0.0, 0.0)), -- Maximal Transparent
                            Image         => Image_Buffer);
      
   end InitLeerBild;
   
   procedure Init_Spielbrett (Brett : in out Grundtypen.Spielbrett) is 
      
      
   begin
      Gtkada.Canvas_View.Initialize(Brett);
      
      -- Initialisierung unseres Model-Trees
      Gtk_New(Grundtypen.Canvas_Model_List);
      
      -- Zuweisen des Model-Trees zum Canvas (Brett)
      Brett.Set_Model(Grundtypen.Canvas_Model_List);
      -- Brett.Initialize(Grundtypen.Canvas_Model_List);
         
      InitFelderPositionen(Brett => Brett);
      
      for Zeile in  Brett.Felder'Range(1) loop
         for Spalte in  Brett.Felder'Range(2) loop
 
            InitLeerBild(Feld => Brett.Felder(Zeile,Spalte));
            Grundtypen.Canvas_Model_List.Add(Brett.Felder(Zeile,Spalte));
            Brett.Felder(Zeile,Spalte).Koordinaten := new KOORDINATEN_TR'(S => Spalte,
                                                                          Z => Zeile);
         end loop;
      end loop;
      
      Brett.Center_On(Center_On => (Brett.Felder(Mittelpunkt.Z - 6,Mittelpunkt.S - 9).Position.X, Brett.Felder(Mittelpunkt.Z - 6,Mittelpunkt.S - 9).Position.Y));
      
      Brett.Model.Refresh_Layout;
      
      Brett.On_Item_Event(AktionController.On_Spielfeld_Event'Access);

   end Init_Spielbrett;
   
   -----------------------------------------------
   -- Initialisierungsprozesse fuer Spielsteine --
   -----------------------------------------------
   
   function Init_Stein_Pos(Buffer : in out Gdk_Pixbuf; Art : Grundtypen.INSEKTEN_T; Anzahl : Natural) return Gtkada.Style.Point is 

      Bildhoehe	: Float;

      Art_Pos		: Float := Float(Grundtypen.INSEKTEN_T'Pos(Art));

   begin

      Bildhoehe := Float(Gdk.Pixbuf.Get_Height(Pixbuf => Buffer));
      return  (15.0 + 10.0 * Gdouble(Anzahl), Gdouble((Bildhoehe * Art_Pos + Art_Pos * 30.0) + Float(Anzahl) * 10.0) + 15.0);
   end Init_Stein_Pos;
   
   -- Aufgrund der Klassenhierarchie werden hier auch die Positionen gesetzt
   procedure Init_Stein_Bilder(Stein : Spielstein; AnzahlSteine : Natural) is
      -- Bildkomponenten
      Image_Buffer : Gdk_Pixbuf;
      Ein_Error : aliased Glib.Error.GError;
      
      
   begin


      Gdk_New_From_File(Pixbuf => Image_Buffer,
                        Filename => "resource\" & Grundtypen.INSEKTEN_T'Image(Stein.Art) & "_" & Grundtypen.FARBEN_T'Image(Stein.Farbe) & ".png",
                        Error => Ein_Error);

      

      Image_Buffer:= Gdk.Pixbuf.Scale_Simple(Src         => Image_Buffer,
                                             Dest_Width  => Gint(Ada.Numerics.Elementary_Functions.Sqrt(X => 3.0) * Grundtypen.Kantenlaenge),
                                             Dest_Height => Gint(2.0 * Grundtypen.Kantenlaenge));

      Stein.Set_Position( Init_Stein_Pos(Buffer	=> Image_Buffer,
                                         Art		=> Stein.Art,
                                         Anzahl => AnzahlSteine));
      
      
      Stein.Initialize_Image(Style => Gtk_New (Stroke => (0.0, 0.0, 0.0, 0.0)), -- Maximal Transparent
                             Image => Image_Buffer);

      case Stein.Farbe is
      when Grundtypen.Schwarz => Vorrat1_Model_List.Add(Stein);
      when Grundtypen.Weiss => Vorrat2_Model_List.Add(Stein);
      end case;

   end Init_Stein_Bilder;

   -- Initialisiert die Steine als Objekte und deren Inhalte abhaengig von der Farbe
   -- und fuegt sie dem entsprechenden Vorrat hinzu
   procedure Init_Steine(Farbe : Grundtypen.FARBEN_T) is
      
      type Vorrat_Array is array (Positive range 1 .. 11) of Grundtypen.INSEKTEN_T;
      type Vorrat_Anzahl is array (Grundtypen.INSEKTEN_T) of Natural;
   
      Vorrat : Vorrat_Array := (1 			=> Bienenkoenigin,
                                2..4 		=> Grashuepfer,
                                5..7 		=> Ameise,
                                8..9 		=> Spinne,
                                10..11	=> Kaefer);
      
      Anzahl : Vorrat_Anzahl := (others => 0);      

   begin
      
     
      for I in Vorrat'Range loop 
         
         Anzahl(Vorrat(I)) := Anzahl(Vorrat(I)) + 1; 
         
         Init_Stein_Bilder(Stein => new SPIELSTEIN_C'
                             (Image_Item_Record with
                              Art     => Vorrat(I),
                              Farbe   => Farbe,
                              Akt_Pos => null),
                           AnzahlSteine => Anzahl(Vorrat(I)));
         
      end loop;
      
      
      
   end Init_Steine;

   procedure Init_Vorraete is 

   begin
      
      Vorrat1 := new Canvas_View_Record;
      Vorrat2 := new Canvas_View_Record;
      
      -- Initialisierungsprozesse
      Gtkada.Canvas_View.Initialize(Vorrat1);
      Gtkada.Canvas_View.Initialize(Vorrat2);
      
      Gtk_New(Vorrat1_Model_List);
      Gtk_New(Vorrat2_Model_List);
  
      Vorrat1.Set_Model(Vorrat1_Model_List);
      Vorrat2.Set_Model(Vorrat2_Model_List);

      Init_Steine(Farbe => Grundtypen.Schwarz);
      Init_Steine(Farbe => Grundtypen.Weiss);

      Anzeigeelemente.Frame_Schwarzer_Schwarm.Add(Widget => Vorrat1);
      Anzeigeelemente.Frame_Weisser_Schwarm.Add(Widget => Vorrat2);

      Vorrat1.Model.Refresh_Layout;
      Vorrat2.Model.Refresh_Layout;
      
      Vorrat1.On_Item_Event(AktionController.On_Vorrat_Event'Access);
      Vorrat2.On_Item_Event(AktionController.On_Vorrat_Event'Access);

   end Init_Vorraete;


end InitController;

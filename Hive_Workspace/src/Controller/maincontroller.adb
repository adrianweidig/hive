package body MainController is
   
   
   procedure Initiere_Widget_Handlers is
   begin
      Neues_Spiel.On_Activate(Neues_Spiel_Starten'Access);
      Beenden.On_Activate(Spiel_Beenden'Access);
      PDF.On_Activate(Anleitung_Starten'Access);
   end Initiere_Widget_Handlers;
   

   -----------
   -- Start --
   -----------
   
   procedure Start (Der_Builder : Gtkada_Builder; Das_Brett : in out Grundtypen.Spielbrett)is
      
      
      
   begin

      Fenster := Gtk_Window(Get_Object(Builder => Der_Builder,
                                       Name => "Fenster"));

      Neues_Spiel := Gtk_Menu_Item(Get_Object(Builder => Der_Builder,
                                              Name => "Neues_Spiel"));
      Beenden := Gtk_Menu_Item(Get_Object(Builder => Der_Builder,
                                          Name => "Beenden"));
      
      PDF := Gtk_Menu_Item(Get_Object(Builder => Der_Builder,
                                            Name => "PDF"));
      
      Frame_Weisser_Schwarm := Gtk_Frame(Get_Object(Builder => Der_Builder,
                                                    Name => "Frame_Weisser_Schwarm"));

      Frame_Schwarzer_Schwarm := Gtk_Frame(Get_Object(Builder => Der_Builder,
                                                      Name => "Frame_Schwarzer_Schwarm"));
      Box_Spielbrett := Gtk_Vbox(Get_Object(Builder => Der_Builder,
                                            Name => "Box_Spielbrett"));
      
      Scrolled_Brett := Gtk_Scrolled_Window (Get_Object(Builder => Der_Builder,
                                                        Name    => "Scrolled_Brett"));

      Status_Spieler := Gtk_Status_Bar(Get_Object(Builder => Der_Builder,
                                                  Name => "Status_Spieler"));

      Status_Zug := Gtk_Status_Bar(Get_Object(Builder => Der_Builder,
                                              Name => "Status_Zug")); 

      Lbl_Weisser_Schwarm := Gtk_Label(Get_Object(Builder => Der_Builder,
                                                  Name => "Lbl_Weisser_Schwarm"));

      Lbl_Schwarzer_Schwarm := Gtk_Label(Get_Object(Builder => Der_Builder,
                                                    Name => "Lbl_Schwarzer_Schwarm"));

      Lbl_Hive := Gtk_Label(Get_Object(Builder => Der_Builder,
                                       Name => "Lbl_Hive"));

      Initiere_Widget_Handlers;
       
   end Start;
   
   
   --------------
   -- Spielzug --
   --------------
   procedure Spielzug ( Brett : in out Grundtypen.Spielbrett) is 
   begin
      null;
   end Spielzug;
   
   

   ----------
   -- Ende --
   ----------
   
   procedure Ende is
   begin
      -- Gewinnnachricht oder so
      null;
   end Ende;

end MainController;

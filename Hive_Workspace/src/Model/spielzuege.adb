with Grundtypen; use Grundtypen;
with Ada.Text_IO; use Ada.Text_IO;

package body Spielzuege is

   --------------------------------------
   -- Spielstein_Setzen_Moeglichkeiten --
   --------------------------------------

   function Spielstein_Setzen_Moeglichkeiten (Brett : in out Grundtypen.Spielbrett ; Spieler : in Grundtypen.FARBEN_T) return Grundtypen.KOORDINATEN_LIST_PTR is

      Positionierungs_Liste 		: 	Grundtypen.KOORDINATEN_LIST_PTR;
      Eigene_Spielsteine_Liste 	: 	Grundtypen.KOORDINATEN_LIST_PTR;


      HilfsPtr 						: 	Grundtypen.KOORDINATEN_LIST_PTR;


      MoeglichePositionen 			: 	Grundtypen.NACHBARN_TA;
      Nachbarn_Pruefung 			: 	Grundtypen.NACHBARN_TA;

      FalscherNachbar				: Boolean := False;
      SchonVorhanden					: Boolean := False;


   begin


      for Zeile in Brett.Felder'Range(1) loop

         for Spalte in Brett.Felder'Range(2) loop

            if Brett.Felder(Zeile, Spalte) /= null and then Brett.Felder(Zeile, Spalte).Figur /= null then
               if Brett.Felder(Zeile, Spalte).Figur.Farbe = Spieler then

                  if Eigene_Spielsteine_Liste = Null then
                     Eigene_Spielsteine_Liste := new Grundtypen.KOORDINATEN_LIST_TR'(Koordinaten => Grundtypen.KOORDINATEN_TR'(S => Spalte,
                                                                                                                               Z => Zeile),
                                                                                     Next_Ptr    => Null);

                  else

                     Eigene_Spielsteine_Liste := new Grundtypen.KOORDINATEN_LIST_TR'(Koordinaten => Grundtypen.KOORDINATEN_TR'(S => Spalte,
                                                                                                                               Z => Zeile),
                                                                                     Next_Ptr    => Eigene_Spielsteine_Liste);
                  end if;

               end if;

            end if;

         end loop;

      end loop;








      if Eigene_Spielsteine_Liste = Null and Brett.Felder(Mittelpunkt.Z, Mittelpunkt.S).Figur = Null then
         Positionierungs_Liste := new Grundtypen.KOORDINATEN_LIST_TR'(Koordinaten => Mittelpunkt.all,
                                                                      Next_Ptr    => Null);


      elsif Eigene_Spielsteine_Liste = Null and Brett.Felder(Mittelpunkt.Z, Mittelpunkt.S).Figur /= Null then
         MoeglichePositionen := Grundtypen.Gebe_Nachbarn(Feldpointer => Brett.Felder(Mittelpunkt.Z, Mittelpunkt.S));



         for Moeglichkeiten in MoeglichePositionen'Range loop

            if Positionierungs_Liste = Null then
               Positionierungs_Liste := new Grundtypen.KOORDINATEN_LIST_TR'(Koordinaten => Grundtypen.KOORDINATEN_TR'(MoeglichePositionen(Moeglichkeiten).Z,MoeglichePositionen(Moeglichkeiten).S),
                                                                            Next_Ptr    => Null);




            else

               Positionierungs_Liste := new Grundtypen.KOORDINATEN_LIST_TR'(Koordinaten => Grundtypen.KOORDINATEN_TR'(MoeglichePositionen(Moeglichkeiten).Z,MoeglichePositionen(Moeglichkeiten).S),
                                                                            Next_Ptr    => Positionierungs_Liste);


            end if;

         end loop;




      else

         while Eigene_Spielsteine_Liste /= Null loop
            MoeglichePositionen := Gebe_Nachbarn(Feldpointer => Brett.Felder(Eigene_Spielsteine_Liste.Koordinaten.Z, Eigene_Spielsteine_Liste.Koordinaten.S));



            for i in MoeglichePositionen'Range loop

               FalscherNachbar := False;
               if Brett.Felder(MoeglichePositionen(i).Z, MoeglichePositionen(i).S).Figur = Null then

                  Nachbarn_Pruefung := Gebe_Nachbarn(Feldpointer => Brett.Felder(MoeglichePositionen(i).Z, MoeglichePositionen(i).S));




                  for Felder in Nachbarn_Pruefung'Range loop

                     if Brett.Felder(Nachbarn_Pruefung(Felder).Z, Nachbarn_Pruefung(Felder).S).Figur /= Null then
                        if Brett.Felder(Nachbarn_Pruefung(Felder).Z, Nachbarn_Pruefung(Felder).S).Figur.Farbe /= Spieler then
                           FalscherNachbar := True;
                        end if;

                     end if;

                  end loop;

                  if not FalscherNachbar then
                     if Positionierungs_Liste = Null then
                        Positionierungs_Liste := new Grundtypen.KOORDINATEN_LIST_TR'(Koordinaten => Grundtypen.KOORDINATEN_TR'(S => MoeglichePositionen(i).S,
                                                                                                                               Z => MoeglichePositionen(i).Z),
                                                                                     Next_Ptr    => null);
                     else

                        HilfsPtr := Positionierungs_Liste;

                        while HilfsPtr /= Null loop

                           if HilfsPtr.Koordinaten.Z = MoeglichePositionen(i).Z and HilfsPtr.Koordinaten.S = MoeglichePositionen(i).S then
                              SchonVorhanden := True;
                           end if;


                           HilfsPtr := HilfsPtr.Next_Ptr;
                        end loop;
                        if not SchonVorhanden then
                           Positionierungs_Liste := new Grundtypen.KOORDINATEN_LIST_TR'(Koordinaten => Grundtypen.KOORDINATEN_TR'(S => MoeglichePositionen(i).S,
                                                                                                                                  Z => MoeglichePositionen(i).Z),
                                                                                        Next_Ptr    => Positionierungs_Liste);
                        end if;
                        SchonVorhanden := False;
                     end if;


                  end if;



               end if;

            end loop;


            Eigene_Spielsteine_Liste := Eigene_Spielsteine_Liste.Next_Ptr;
         end loop;



      end if;


      return Positionierungs_Liste;

   end Spielstein_Setzen_Moeglichkeiten;

end Spielzuege;

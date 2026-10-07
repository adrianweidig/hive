with Grundtypen; use Grundtypen;
with Ada.Text_IO; use Ada.Text_IO;
package body Grundtypen is


   function Gebe_Nachbarn (Feldpointer : in Spielfeld) return NACHBARN_TA is

      Zeile : SPIELFELD_INDEX_T := Feldpointer.Koordinaten.Z;
      Spalte : SPIELFELD_INDEX_T := Feldpointer.Koordinaten.S;
      Nachbarn : NACHBARN_TA;
   begin

      if Zeile mod 2 = 0 then
         Nachbarn(1) := (Zeile, Spalte + 1);
         Nachbarn(2) := (Zeile + 1, Spalte);
         Nachbarn(3) := (Zeile + 1, Spalte - 1);
         Nachbarn(4) := (Zeile, Spalte - 1);
         Nachbarn(5) := (Zeile - 1, Spalte - 1);
         Nachbarn(6) := (Zeile - 1, Spalte);


      else
         Nachbarn(1) := (Zeile, Spalte + 1);
         Nachbarn(2) := (Zeile + 1, Spalte + 1 );
         Nachbarn(3) := (Zeile + 1, Spalte);
         Nachbarn(4) := (Zeile, Spalte - 1);
         Nachbarn(5) := (Zeile - 1, Spalte);
         Nachbarn(6) := (Zeile - 1, Spalte + 1);



      end if;
      return Nachbarn;
   end Gebe_Nachbarn;


   procedure KoordListeErweitern (Liste : in out KOORDINATEN_LIST_PTR; Koordinaten : KOORDINATEN_TR) is

   begin
      if Liste = null then

         Liste := new KOORDINATEN_LIST_TR'(Koordinaten => Koordinaten,
                                           Next_Ptr    => null);
      else
         Liste := new KOORDINATEN_LIST_TR'(Koordinaten => Koordinaten,
                                           Next_Ptr    => Liste);
      end if;
   end KoordListeErweitern;



   ------------
   -- MglSpz --
   ------------
   --
   function MglSpz (Stein : in Spielstein; Brett : in out Spielbrett) return KOORDINATEN_LIST_PTR is
   begin
      if HIVEunterbrochen(Stein => Stein, Brett => Brett) then
         case Stein.Art is
         when Bienenkoenigin =>
            return MglSpzBienenkoenigin(Stein, Brett);
         when Kaefer =>
            return MglSpzKaefer(Stein, Brett);
         when Grashuepfer =>
            return MglSpzGrashuepfer(Stein, Brett);
            when Spinne =>
               return MglSpzSpinne(Stein, Brett);
            when Ameise =>
               return MglSpzAmeise(Stein, Brett);
            when others =>
               return null;
         end case;
      else
         Put_Line("null");
         return NULL;
      end if;
   end MglSpz;

   -------------------------------
   -- Spielzuege Bienenkoenigin --
   -------------------------------

   function MglSpzBienenkoenigin ( Stein : in Spielstein; Brett : in Spielbrett ) return KOORDINATEN_LIST_PTR is
      Koord_Liste : KOORDINATEN_LIST_PTR;
      NachbarnStart : NACHBARN_TA := Gebe_Nachbarn(Feldpointer => Brett.Felder(Stein.Akt_Pos.Z,Stein.Akt_Pos.S));
      Nachbarn_Ziel : NACHBARN_TA;
   begin
      Brett.Felder(Stein.Akt_Pos.Z,Stein.Akt_Pos.S).Figur := null;

      for i in NachbarnStart'Range loop
         if Brett.Felder(NachbarnStart(i).Z, NachbarnStart(i).S).Figur = Null then
            Nachbarn_Ziel := Gebe_Nachbarn(Feldpointer => Brett.Felder(NachbarnStart(i).Z,NachbarnStart(i).S));
            for y in Nachbarn_Ziel'Range loop
               if Brett.Felder(Nachbarn_Ziel(y).Z, Nachbarn_Ziel(y).S).Figur /= null then

                  KoordListeErweitern(Liste       => Koord_Liste,
                                      Koordinaten => (NachbarnStart(i)));
                  exit;
               end if;
            end loop;
         end if;
      end loop;
      Brett.Felder(Stein.Akt_Pos.Z,Stein.Akt_Pos.S).Figur := Stein;
      return Koord_Liste;
   end MglSpzBienenkoenigin;


   -----------------------
   -- Spielzuege Kaefer --
   -----------------------

   function MglSpzKaefer ( Stein : in Spielstein; Brett : in Spielbrett ) return KOORDINATEN_LIST_PTR is
      Koord_Liste : KOORDINATEN_LIST_PTR;
      NachbarnStart : NACHBARN_TA := Gebe_Nachbarn(Feldpointer => Brett.Felder(Stein.Akt_Pos.Z,Stein.Akt_Pos.S));
      Nachbarn_Ziel : NACHBARN_TA;
   begin
      Brett.Felder(Stein.Akt_Pos.Z,Stein.Akt_Pos.S).Figur := null;

      for i in NachbarnStart'Range loop
         if Brett.Felder(NachbarnStart(i).Z, NachbarnStart(i).S).Figur = Null then
            Nachbarn_Ziel := Gebe_Nachbarn(Feldpointer => Brett.Felder(NachbarnStart(i).Z,NachbarnStart(i).S));
            for y in Nachbarn_Ziel'Range loop
               if Brett.Felder(Nachbarn_Ziel(y).Z, Nachbarn_Ziel(y).S).Figur /= null then

                  KoordListeErweitern(Liste       => Koord_Liste,
                                      Koordinaten => (NachbarnStart(i)));
                  exit;
               end if;
            end loop;
         end if;
      end loop;
      Brett.Felder(Stein.Akt_Pos.Z,Stein.Akt_Pos.S).Figur := Stein;
      return Koord_Liste;

   end MglSpzKaefer;



   ---------------
   -- Spielende --
   ---------------


   function Spielende (Brett : in Spielbrett; Farbe : in FARBEN_T) return Boolean is

      Umliegende_Felder : NACHBARN_TA;
      Spiel_Beendet		: BOOLEAN 			:= True;
      Counter 			: NATURAL			:= 0;

   begin

      for Zeile in SPIELFELD_INDEX_T loop
         for Spalte in SPIELFELD_INDEX_T loop
            if Brett.Felder(Zeile, Spalte).Figur /= null then
               if Brett.Felder(Zeile, Spalte).Figur.Art = Bienenkoenigin and then Brett.Felder(Zeile, Spalte).Figur.Farbe = Farbe then
                  Umliegende_Felder := Gebe_Nachbarn(Brett.Felder(Zeile, Spalte));
                  for Index in Umliegende_Felder'Range loop
                     if Brett.Felder(Umliegende_Felder(Index).Z, Umliegende_Felder(Index).S).Figur /= null then
                        Counter := Counter + 1;
                     end if;
                  end loop;
               end if;
            end if;
         end loop;
      end loop;


      if Counter = 6 then
         Spiel_Beendet := True;
      else
         Spiel_Beendet := False;
      end if;

      return Spiel_Beendet;
   end Spielende;


   function Spielergebnis (Brett : in Spielbrett) return String is

      Rueckgabe : String(1..15);

   begin

      if Spielende(Brett, Weiss) and Spielende(Brett, Schwarz) then
         Rueckgabe := "Unentschieden  ";

      elsif Spielende(Brett, Weiss) then
         Rueckgabe := "Schwarz gewinnt";
         Hat_Gewonnen := Schwarz;

      elsif Spielende(Brett, Schwarz) then
         Rueckgabe := "Weiss gewinnt  ";
         Hat_Gewonnen := Weiss;
      end if;

      return Rueckgabe;

   end Spielergebnis;



   ----------------------------
   -- Spielzuege Grashuepfer --
   ----------------------------

   function MglSpzGrashuepfer ( Stein : in Spielstein; Brett : in Spielbrett) return KOORDINATEN_LIST_PTR is
      Koord_Liste : KOORDINATEN_LIST_PTR;
      Feld : Spielfeld := Brett.Felder(Stein.Akt_Pos.Z, Stein.Akt_Pos.S);
      Nachbarn : NACHBARN_TA := Gebe_Nachbarn(Feld);
      NachbarnTemp : NACHBARN_TA := Gebe_Nachbarn(Feld);
   begin
      for i in Nachbarn'range loop
         NachbarnTemp := Nachbarn;
         if Brett.Felder(Nachbarn(i).Z, Nachbarn(i).S).Figur /= null then
            while Brett.Felder(NachbarnTemp(i).Z, NachbarnTemp(i).S).Figur /= null loop
               NachbarnTemp := Gebe_Nachbarn(Feldpointer => Brett.Felder(NachbarnTemp(i).Z, NachbarnTemp(i).S));
            end loop;
            KoordListeErweitern(Liste       => Koord_Liste,
                                Koordinaten => (NachbarnTemp(i).Z, NachbarnTemp(i).S));
         end if;
      end loop;
      return Koord_Liste;
   end MglSpzGrashuepfer;



   -----------------------
   -- Spielzuege Ameise --
   -----------------------
   function MglSpzAmeise ( Stein : in Spielstein; Brett : in Spielbrett ) return KOORDINATEN_LIST_PTR is
      Koord_Liste : KOORDINATEN_LIST_PTR;
      Akt_Pos : KOORDINATEN_TR := (Stein.Akt_Pos.Z, Stein.Akt_Pos.S);
      Startpunkt : KOORDINATEN_TR := Akt_Pos;
      Nachbarn : NACHBARN_TA := Gebe_Nachbarn(Feldpointer => Brett.Felder(Stein.Akt_Pos.Z, Stein.Akt_Pos.S));
   begin
      Brett.Felder(Startpunkt.Z, Startpunkt.S).Figur := null;
      loop
         Put_Line(Integer'Image(Startpunkt.Z) & " | " & Integer'Image(Startpunkt.S));
         for i in Nachbarn'range loop
            if Brett.Felder(Nachbarn(i).Z, Nachbarn(i).S).Figur /= null
              -- Hier verwende ich den Modulo-Operator um auch eine Prügung über das Array hinaus zu ermöglichen.
              -- Sprich wenn Position 6 besetzt ist, dass Positionen 1 & 2 ueberprueft werden. Durch die Pruefung, dass immer
              -- eine Luecke von 2 Steinen eine bewegung ermöglicht, schließe ich den Gang in eine Physisch nicht passierbare
              -- Stelle aus. Sollte eine Stelle Physisch erreicht werden koennen, wird diese Position der Koor_Liste hinzugefuegt
              -- und die Aktuelle Position auf dieses Feld gesetzt.
              and then Brett.Felder(Nachbarn((i mod 6) + 1).Z, Nachbarn((i mod 6) + 1).S).Figur = null
              and then Brett.Felder(Nachbarn(((i + 1) mod 6) + 1).Z, Nachbarn(((i + 1) mod 6) + 1).s).Figur = null then
               Akt_Pos := (Nachbarn((i mod 6) + 1).Z, Nachbarn((i mod 6) + 1).S);
               if Akt_Pos /= Startpunkt then
                  Put_Line(Integer'Image(Akt_Pos.Z) & " | " & Integer'Image(Akt_Pos.S));
                  KoordListeErweitern(Liste => Koord_Liste,
                                      Koordinaten => (Akt_Pos.Z, Akt_Pos.S));
               end if;
            end if;
         end loop;
         Put_Line(Integer'Image(Akt_Pos.Z) & " | " & Integer'Image(Akt_Pos.S));
         Put_Line("____________________");
         Nachbarn := Gebe_Nachbarn(Feldpointer => Brett.Felder(Akt_Pos.Z, Akt_Pos.S));
         exit when Akt_Pos = Startpunkt;
      end loop;
      Brett.Felder(Stein.Akt_Pos.Z, Stein.Akt_Pos.S).Figur := Stein;
      return Koord_Liste;
   end MglSpzAmeise;

   -------------------
   -- MglSpz Spinne --
   -------------------

   function MglSpzSpinne ( Stein : in Spielstein; Brett : in Spielbrett ) return KOORDINATEN_LIST_PTR is
      Koord_Liste : KOORDINATEN_LIST_PTR;
      Akt_Pos : KOORDINATEN_TR := (Stein.Akt_Pos.Z, Stein.Akt_Pos.S);
      Startpunkt : KOORDINATEN_TR := Akt_Pos;
      Nachbarn : NACHBARN_TA := Gebe_Nachbarn(Feldpointer => Brett.Felder(Stein.Akt_Pos.Z, Stein.Akt_Pos.S));
      Schritte : Natural := 0;
   begin
      Brett.Felder(Startpunkt.Z, Startpunkt.S).Figur := null;
      loop
         Put_Line(Integer'Image(Startpunkt.Z) & " | " & Integer'Image(Startpunkt.S));
         for i in Nachbarn'range loop
            if Brett.Felder(Nachbarn(i).Z, Nachbarn(i).S).Figur /= null
              and then Brett.Felder(Nachbarn((i mod 6) + 1).Z, Nachbarn((i mod 6) + 1).S).Figur = null
              and then Brett.Felder(Nachbarn(((i + 1) mod 6) + 1).Z, Nachbarn(((i + 1) mod 6) + 1).s).Figur = null then
               Akt_Pos := (Nachbarn((i mod 6) + 1).Z, Nachbarn((i mod 6) + 1).S);
               Schritte := Schritte + 1;
               if Schritte = 3 then
                  KoordListeErweitern(Liste => Koord_Liste,
                                      Koordinaten => (Akt_Pos.Z, Akt_Pos.S));
               end if;
            end if;
         end loop;
         Put_Line(Integer'Image(Akt_Pos.Z) & " | " & Integer'Image(Akt_Pos.S));
         Put_Line("____________________");
         Nachbarn := Gebe_Nachbarn(Feldpointer => Brett.Felder(Akt_Pos.Z, Akt_Pos.S));
         exit when Akt_Pos = Startpunkt or Schritte = 3;
      end loop;
      Schritte := 0;
      Nachbarn := Gebe_Nachbarn(Feldpointer => Brett.Felder(Stein.Akt_Pos.Z, Stein.Akt_Pos.S));
      Akt_Pos := Startpunkt;
      loop
         for i in Nachbarn'range loop
            if Brett.Felder(Nachbarn(i).Z, Nachbarn(i).S).Figur = null
              and then Brett.Felder(Nachbarn((i mod 6) + 1).Z, Nachbarn((i mod 6) + 1).S).Figur = null
              and then Brett.Felder(Nachbarn(((i + 1) mod 6) + 1).Z, Nachbarn(((i + 1) mod 6) + 1).s).Figur /= null then
               Akt_Pos := (Nachbarn((i mod 6) + 1).Z, Nachbarn((i mod 6) + 1).S);
               Schritte := Schritte + 1;
               if Schritte = 3 then
                  KoordListeErweitern(Liste => Koord_Liste,
                                      Koordinaten => (Akt_Pos.Z, Akt_Pos.S));
               end if;
            end if;
         end loop;
         Put_Line(Integer'Image(Akt_Pos.Z) & " | " & Integer'Image(Akt_Pos.S));
         Put_Line("____________________");
         Nachbarn := Gebe_Nachbarn(Feldpointer => Brett.Felder(Akt_Pos.Z, Akt_Pos.S));
         exit when Akt_Pos = Startpunkt or Schritte = 3;
      end loop;
      Brett.Felder(Stein.Akt_Pos.Z, Stein.Akt_Pos.S).Figur := Stein;
      return Koord_Liste;
   end MglSpzSpinne;




   ----------------------
   -- HIVEunterbrochen --
   ----------------------

   function HIVEunterbrochen (Stein : in Spielstein; Brett : in out Spielbrett) return BOOLEAN is
      GroesseHIVE : Natural := 0;
   begin



      Brett.Felder(Stein.Akt_Pos.Z, Stein.Akt_Pos.S).Figur := null;
      GroesseHIVE := ZaehleHIVE(Koordinaten => findeHIVE(Brett),
                                Brett => Brett);
      loescheMarkierungen(Brett);
      if GroesseHIVE = 0 then
         GroesseHIVE := 1;
      end if;


      Brett.Felder(Stein.Akt_Pos.Z, Stein.Akt_Pos.S).Figur := Stein;





      return GroesseHIVE = Brett.SteineGespielt - 1;

   end HIVEunterbrochen;

   -----------------
   -- HIVE finden --
   -----------------

   function findeHIVE (Brett : in Spielbrett) return KOORDINATEN_PTR is
      Zeile, Spalte : SPIELFELD_INDEX_T := SPIELFELD_INDEX_T'First ;
      Koordinaten : KOORDINATEN_PTR;
      KoordinateGefunden : Boolean := False;
   begin
      if Brett.Felder(Mittelpunkt.S, Mittelpunkt.Z).Figur /= null then
         Koordinaten := Mittelpunkt;
      else

         for Zeile in Brett.Felder'Range(1) loop
            for Spalte in Brett.Felder'Range(2) loop
               if Brett.Felder(Zeile,Spalte).Figur /= null and not KoordinateGefunden then
                  Koordinaten := new KOORDINATEN_TR'(S => Spalte,
                                                     Z => Zeile);
                  KoordinateGefunden := True;
               end if;


            end loop;

         end loop;
      end if;


      return Koordinaten;

   end findeHIVE;

   -------------------------
   -- Markierung loeschen --
   -------------------------

   procedure loescheMarkierungen (Brett : in Spielbrett) is
      Zaehler : Natural := 0;
   begin

      for Zeile in Brett.Felder'Range(1) loop
         for Spalte in Brett.Felder'Range(2) loop
            if Brett.Felder(Zeile, Spalte).Markierung /= 0 then
               Brett.Felder(Zeile, Spalte).Markierung := 0;
            end if;
         end loop;
      end loop;

   end loescheMarkierungen;

   ----------------
   -- ZaehleHIVE --
   ----------------
   -- Ruft vorhandene Nachbarn auf, Setzt die Markierung von diesen auf 0
   function ZaehleHIVE (Koordinaten : in KOORDINATEN_PTR; Brett : in Spielbrett) return Natural is
      Zaehler : Natural := 0;
      Nachbarn : NACHBARN_TA;

   begin
      if Koordinaten /= null then
         Nachbarn := Gebe_Nachbarn(Brett.Felder(Koordinaten.Z,Koordinaten.S));
         for i in Nachbarn'range loop

            if Brett.Felder(Nachbarn(i).Z,Nachbarn(i).S).Figur /= null then
               if Brett.Felder(Nachbarn(i).Z,Nachbarn(i).S).Markierung = 0 then
                  Zaehler := Zaehler + 1;
                  Brett.Felder(Nachbarn(i).Z,Nachbarn(i).S).Markierung := 1;
                  Zaehler := Zaehler + ZaehleHIVE(Brett.Felder(Nachbarn(i).Z,Nachbarn(i).S).Koordinaten,Brett);
               end if;
            end if;
         end loop;
      end if;


      return Zaehler;
   end ZaehleHIVE;

end Grundtypen;

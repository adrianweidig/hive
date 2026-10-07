with Grundtypen;

package Spieler is

   -----------------------------------------------------------------------------
   -- Paket enthaelt die Klasse Spieler mit allen notwendigen Attributen und
   -- Methoden zur Darstellung der Spieler in der Spiellogik
   -----------------------------------------------------------------------------
   -- Autor: 					OLt Dominik Wente
   -- Erstellt:				02.12.2021
   -- Letzte Aenderung:		02.12.2021
   -- Abhaengigkeiten:		Grundtypen
   -- Inhalt:					-
   -----------------------------------------------------------------------------

   Aktueller_Spieler : Grundtypen.FARBEN_T := Grundtypen.Weiss;

   Biene_Weiss	: Boolean := False;

   Biene_Schwarz : Boolean := False;

   type Spieler is tagged record
     -- Name 	: String := " ";
      Farbe	: Grundtypen.FARBEN_T; 	--
      Vorrat	: Grundtypen.STEINE_TA; 				-- Siehe Grundtypen
      Am_Zug	: Boolean;
   end record;

end Spieler;

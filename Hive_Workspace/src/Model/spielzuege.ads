with Grundtypen;

package Spielzuege is
   use type Grundtypen.Spielstein;
   use type Grundtypen.FARBEN_T;
   use type Grundtypen.KOORDINATEN_LIST_PTR;

   
   function Spielstein_Setzen_Moeglichkeiten (Brett : in out Grundtypen.Spielbrett ; Spieler : in Grundtypen.FARBEN_T) return Grundtypen.KOORDINATEN_LIST_PTR;
   

end Spielzuege;

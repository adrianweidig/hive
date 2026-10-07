with Gtkada.Canvas_View; use Gtkada.Canvas_View;


package Grundtypen is

   Anzahl_Zuege : Natural := 0;
   
   --------------------------
   -- Spielfeld Datentypen --
   --------------------------
   
   subtype SPIELFELD_INDEX_T is Natural range 0 .. 44;
   subtype ANZAHL_SPIELSTEINE_T is Natural range 0 .. 3;
   type INSEKTEN_T is (Bienenkoenigin, Kaefer, Grashuepfer, Spinne, Ameise);
   type FARBEN_T is (Schwarz, Weiss);
   
   Kantenlaenge : constant Float := 50.0;

   ----------------------------
   -- Koordinaten Datentypen --
   ----------------------------
   
   type KOORDINATEN_TR is record
      Z : SPIELFELD_INDEX_T;
      S : SPIELFELD_INDEX_T;
   end record;
   
   type KOORDINATEN_PTR is access KOORDINATEN_TR;
  
   
   
   
   type KOORDINATEN_LIST_TR;
   
   type KOORDINATEN_LIST_PTR is access KOORDINATEN_LIST_TR;

   type KOORDINATEN_LIST_TR is record
      Koordinaten : KOORDINATEN_TR;
      Next_Ptr : KOORDINATEN_LIST_PTR;
   end record;

   
   
   Mittelpunkt : KOORDINATEN_PTR := new KOORDINATEN_TR'(22,22);
   
   -------------------
   -- Vorrat Steine --
   -------------------
   
   type STEINE_TA is array (INSEKTEN_T) of Natural;
   
   ----------------
   -- SPIELSTEIN --
   ----------------

   type SPIELSTEIN_C is new Gtkada.Canvas_View.Image_Item_Record with record
      Art		 : INSEKTEN_T;
      Farbe	 : FARBEN_T;
      Akt_Pos	 : KOORDINATEN_PTR;
      --Halbe Kantenlaenge fuer Jonas
   end record;

   type Spielstein is access all SPIELSTEIN_C'Class;
   
   -- Globales Auswahlobjekt
   Ausgewaehlter_Stein : Spielstein;
   
   ---------------
   -- Spielfeld --
   ---------------
   
   type SPIELFELD_TR is new Gtkada.Canvas_View.Image_Item_Record with Record
      Figur			:	Spielstein;
      Koordinaten		:	KOORDINATEN_PTR;
      Markierung		: 	Natural			:=		0;
      Highlight		: 	Image_Item 		:=	 	null;
   end record;
   
   type Spielfeld is access all SPIELFELD_TR'Class;
   
   ----------------------------
   -- Canvas-Liste erstellen --
   ----------------------------
   
   -- Elemente fuer Vorrat1 
   Vorrat1 : Canvas_View := new Canvas_View_Record;
   Vorrat1_Model_List : List_Canvas_Model;
      
   -- Elemente fuer Vorrat2
   Vorrat2 : Canvas_View := new Canvas_View_Record;
   Vorrat2_Model_List : List_Canvas_Model;
   
   Canvas_Model_List : List_Canvas_Model;
   
   ----------------
   -- Spielbrett --
   ----------------
   
   type FELDER_TA is array (SPIELFELD_INDEX_T, SPIELFELD_INDEX_T) of Spielfeld;
   
   type SPIELBRETT_TR is new Canvas_View_Record with record
      Felder 			: FELDER_TA;
      SteineGespielt	: Natural := 0;
   end record;
   
   type Spielbrett is access all SPIELBRETT_TR'Class;
   
   Brett : Spielbrett;
   
   SpielBeendet : Boolean := False;
   Hat_Gewonnen : FARBEN_T;

   ---------------------------
   -- Benachbarte Spielsteine
   --------------------------- 
   type NACHBARN_TA is array (Positive range 1..6) of KOORDINATEN_TR;
   function Gebe_Nachbarn (Feldpointer : in Spielfeld) return NACHBARN_TA;
   
   
   -----------------------------
   -- Funktionen & Proceduren --
   -----------------------------
   
   procedure loescheMarkierungen (Brett : in Spielbrett);
   function ZaehleHIVE (Koordinaten : in KOORDINATEN_PTR; Brett : in Spielbrett) return Natural;
   function findeHIVE (Brett : in Spielbrett) return KOORDINATEN_PTR;
   function HIVEunterbrochen (Stein : in Spielstein; Brett : in out Spielbrett) return BOOLEAN;
   function Spielende (Brett : in Spielbrett; Farbe : in FARBEN_T) return Boolean;
   function Spielergebnis (Brett : in Spielbrett) return String;
   
   procedure KoordListeErweitern (Liste : in out KOORDINATEN_LIST_PTR; Koordinaten : KOORDINATEN_TR);
   
   function MglSpzAmeise ( Stein : in Spielstein; Brett : in Spielbrett ) return KOORDINATEN_LIST_PTR;
   --  
   function MglSpzBienenkoenigin ( Stein : in Spielstein; Brett : in Spielbrett ) return KOORDINATEN_LIST_PTR;
   --  
   function MglSpzKaefer ( Stein : in Spielstein; Brett : in Spielbrett ) return KOORDINATEN_LIST_PTR;
   --  
   function MglSpzGrashuepfer ( Stein : in Spielstein; Brett : in Spielbrett) return KOORDINATEN_LIST_PTR;
   --  
     function MglSpzSpinne ( Stein : in Spielstein; Brett : in Spielbrett ) return KOORDINATEN_LIST_PTR;
   
   function MglSpz (Stein : in Spielstein; Brett : in out Spielbrett) return KOORDINATEN_LIST_PTR;

end Grundtypen;

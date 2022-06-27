# Deklaracje zbiorow i parametrow zawartych w pliku danycg

set PRODUKTY;
set CZYNNOSCI;
set MIESIACE;



# PARAMETRY

# czasy potrzebne do wykonania danych produktow [godz/szt.]
param czasy {CZYNNOSCI, PRODUKTY} >= 0;

# marze kazdego produktu [zl/szt.]
param marze {PRODUKTY} >= 0;

# Ograniczenia rynkowe na liczbe sprzedawanych produktow [szt.]
param ogr_rynkowe {MIESIACE, PRODUKTY} >= 0;

# Liczba dostepnych maszyn [szt.]
param maszyny {CZYNNOSCI} >= 0;



# Maksymalny czas produkcji w jednym miesiacu 24 dni po 16 godzin [godz]
param T = 384;

param T_maszyn {c in CZYNNOSCI} = maszyny[c]*T;
# Maksymalny liczba skladowanych produktow [szt.]
param S = 100;

# Wymagany zapas na koniec marca [szt.]
param Z = 50;

# Koszt skladowania [zl/szt.]
param KS = 0.5;
#param KS = 0;

# Indeks ostatniego miesiaca produkcji
param OstMiesiac = 3;


# ZMIENNE
#var bin {MIESIACE,PRODUKTY} binary;

var prod {PRODUKTY, MIESIACE} integer >= 0;

var czasy_calk {m in MIESIACE, c in CZYNNOSCI} = sum {p in PRODUKTY} prod[p,m]*czasy[c,p];


var magazyn {m in MIESIACE, p in PRODUKTY} >= 0;

var zyskCzasu {m in MIESIACE} >= 0;

var kosztMagazyn = sum {m in MIESIACE, p in PRODUKTY} magazyn[m,p]*KS;

var zysk = sum {p in PRODUKTY, m in MIESIACE} (prod[p,m] - magazyn[m,p])*marze[p];


var zyskCzasuSum = sum {m in MIESIACE} zyskCzasu[m];



# FUNKCJA CELU
maximize z: 1*(zysk - kosztMagazyn) + 2*(zyskCzasuSum);




# OGRANICZENIA

# ograniczenie czasu uzycia sprzetu do produkcji
s.t. OgrCzasUzycia {c in CZYNNOSCI, m in MIESIACE}: czasy_calk[m,c] <= T_maszyn[c];
#s.t. OgrCzasUzycia {c in CZYNNOSCI, m in MIESIACE}: czasy_calk[m,c] <= T;


s.t. OgrMagazyn {m in MIESIACE, p in PRODUKTY}: magazyn[m,p] <= S;

s.t. MagazynMaxStyczen {p in PRODUKTY}: magazyn[1,p] >= prod[p,1] - ogr_rynkowe[1,p];
s.t. MagazynMaxMiesiace {m in 2..OstMiesiac, p in PRODUKTY}: magazyn [m,p] >= prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p];

s.t. OgrOstMiesiac {p in PRODUKTY}: magazyn[OstMiesiac,p] >= 50;
#s.t. OgrOstMiesiac2 {p in PRODUKTY}: magazyn[OstMiesiac,p] <= prod[p,OstMiesiac] - ogr_rynkowe[OstMiesiac,p] + magazyn[OstMiesiac-1,p];
#s.t. OgrOstMiesiacProd {p in PRODUKTY}: prod[p,OstMiesiac] >= magazyn[OstMiesiac,p] - magazyn[OstMiesiac-1,p] + ogr_rynkowe[OstMiesiac,p];
#s.t. OgrOstMiesiac {p in PRODUKTY}: magazyn[OstMiesiac,p] >= prod[p,OstMiesiac] - ogr_rynkowe[OstMiesiac,p] + magazyn[OstMiesiac-1,p] + Z;
#s.t. OgrOstMiesiac1 {p in PRODUKTY}: prod[p,OstMiesiac] >=  ogr_rynkowe[OstMiesiac,p] - magazyn[OstMiesiac-1,p] + Z;


s.t. OgryZyskCzasu1 {c in CZYNNOSCI}: zyskCzasu[1] <= min((T_maszyn[c] - czasy_calk[1,c])/maszyny[c]);
s.t. OgryZyskCzasu2 {c in CZYNNOSCI}: zyskCzasu[2] <= min((T_maszyn[c] - czasy_calk[2,c])/maszyny[c]);
s.t. OgryZyskCzasu3 {c in CZYNNOSCI}: zyskCzasu[3] <= min((T_maszyn[c] - czasy_calk[3,c])/maszyny[c]);























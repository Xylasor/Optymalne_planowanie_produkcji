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

# Maksymalny liczba skladowanych produktow [szt.]
param S = 100;

# Wymagany zapas na koniec marca [szt.]
param Z = 50;

# Koszt skladowania [zl/szt.]
param KS = 0;

# Indeks ostatniego miesiaca produkcji
param OstMiesiac = 3;


# ZMIENNE
var bin {MIESIACE,PRODUKTY} binary;

var prod {PRODUKTY, MIESIACE} integer >= 0;

var czasy_calk {m in MIESIACE, c in CZYNNOSCI} = sum {p in PRODUKTY} prod[p,m]*czasy[c,p];



# Liczba sztuk przechowywana w magazynie [szt.]
#var magazyn {m in MIESIACE, p in PRODUKTY} = if m==1 then (if 0 >= (prod[p,m] - ogr_rynkowe[m,p]) then 0 else prod[p,m] - ogr_rynkowe[m,p]) else (if 0>=(prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p]) then 0 else prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p]);

#var magazyn {m in MIESIACE, p in PRODUKTY} = if m==1 then
# (if (prod[p,m] - ogr_rynkowe[m,p]) >= 0 then prod[p,m] - ogr_rynkowe[m,p] else 0)  else 10;


#var magazyn {m in MIESIACE, p in PRODUKTY} = if m==1 then max(0,prod[p,m] - ogr_rynkowe[m,p]) else max(0,prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p]);

#var magazyn {m in MIESIACE, p in PRODUKTY} = 0 + bin[m,p]*(prod[p,m] - ogr_rynkowe[m,p]) ;

#var magazyn {m in MIESIACE, p in PRODUKTY} >= 0;

var magazyn {m in MIESIACE, p in PRODUKTY} = if m==1 then prod[p,m] - ogr_rynkowe[m,p] else prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p];

#var magazyn {m in MIESIACE, p in PRODUKTY} = if m==1 then bin[m,p]*(prod[p,m] - ogr_rynkowe[m,p]) else 60;#bin[m,p]*(prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p]);

var kosztMagazyn = sum {m in MIESIACE, p in PRODUKTY} magazyn[m,p]*KS;

var zysk = sum {p in PRODUKTY, m in MIESIACE} (prod[p,m] - magazyn[m,p])*marze[p];

# FUNKCJA CELU
maximize z: zysk - kosztMagazyn;




# OGRANICZENIA

# ograniczenie czasu uzycia sprzetu do produkcji
s.t.	OgrCzasUzycia {c in CZYNNOSCI, m in MIESIACE}: czasy_calk[m,c] <= T;



s.t. OgrMagazyn {m in MIESIACE, p in PRODUKTY}: magazyn[m,p] <= S;



#s.t. MagazynMaxStyczen {p in PRODUKTY}: magazyn[1,p] >= prod[p,1] - ogr_rynkowe[1,p];# else magazyn[m,p] >= prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p];


#s.t. MagazynMaxPozostale {m in 2..OstMiesiac, p in PRODUKTY}: magazyn[m,p] >= prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p];
#s.t. MagazynNaKoniec {p in PRODUKTY}: magazyn[OstMiesiac, p] >= Z;

























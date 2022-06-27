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
param KS = 0.5;


# ZMIENNE


var prod {PRODUKTY, MIESIACE} integer >= 0;

var czasy_calk {m in MIESIACE, c in CZYNNOSCI} = sum {p in PRODUKTY} prod[p,m]*czasy[c,p];

var zysk = sum {i in PRODUKTY, j in MIESIACE} prod[i,j]*marze[i];

# Liczba sztuk przechowywana w magazynie [szt.]
#var magazyn {m in MIESIACE, p in PRODUKTY} = if m==1 then (if 0 >= (prod[p,m] - ogr_rynkowe[m,p]) then 0 else prod[p,m] - ogr_rynkowe[m,p]) else (if 0>=(prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p]) then 0 else prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p]);

#var magazyn {m in MIESIACE, p in PRODUKTY} = if m==1 then
# (if (prod[p,m] - ogr_rynkowe[m,p]) >= 0 then prod[p,m] - ogr_rynkowe[m,p] else 0)  else 10;


var magazyn {m in MIESIACE, p in PRODUKTY} = if m==1 then max(0,prod[p,m] - ogr_rynkowe[m,p]) else max(0,prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p]);



# FUNKCJA CELU
maximize z: zysk;




# OGRANICZENIA

# ograniczenie czasu uzycia sprzetu do produkcji
s.t.	OgrCzasUzycia {c in CZYNNOSCI, m in MIESIACE}: czasy_calk[m,c] <= T;

# ograniczenie na produkcje w pierwszym miesiacu
#s.t.	ProdStyczen {p in PRODUKTY}: prod[p,1] <= ogr_rynkowe[1,p] + S;
#s.t.	ProdLuty {p in PRODUKTY}: prod[p,2] <= ogr_rynkowe[2,p] + S;
#s.t.	ProdMarzec {p in PRODUKTY}: prod[p,3] <= ogr_rynkowe[3,p] + S;
#s.t.	MagazynKoniec {p in PRODUKTY}: magazyn[3,p] >= 50;
#s.t. 	ProdNastepne {p in PRODUKTY, m in MIESIACE}: if m==1prod[p,1] <= ogr_rynkowe[m,p] - magazyn[m-1,p] + S else  ;
#s.t.	ProdLuty {p in PRODUKTY}: prod[p,2] <= ogr_rynkowe[2,p]  + S - magazyn[1,p];

#s.t. 	ProdLuty1 {p in PRODUKTY}: prod[p,2] <= magazyn[1,p];
#s.t. 	OgrMagazyn {m in MIESIACE, p in PRODUKTY}: magazyn[m,p] <= 100;
#s.t. 	OgrMagazyn {m in MIESIACE, p in PRODUKTY}: magazyn[1,p] <= 100;
#s.t. 	OgrMagazyn1 {m in MIESIACE, p in PRODUKTY}: magazyn[1,p] >= 0;
























# OPTYMALIZACJA WE WSPOMAGANIU DECYZJI
# PROJEKT - ZADANIE OPTYMALNEGO PLANOWANIA PRODUKCJI
# METODA WAZENIA OCEN 
# AUTOR: MATEUSZ HRYCIOW 283365


# Deklaracje zbiorow i parametrow zawartych w pliku danych

set PRODUKTY;
set CZYNNOSCI;
set MIESIACE;



### PARAMETRY ###

# Czasy potrzebne do wykonania danych produktow [godz/szt.]
param czasy {CZYNNOSCI, PRODUKTY} >= 0;

# Marze kazdego produktu [zl/szt.]
param marze {PRODUKTY} >= 0;

# Ograniczenia rynkowe na liczbe sprzedawanych produktow [szt.]
param ogr_rynkowe {MIESIACE, PRODUKTY} >= 0;

# Liczba dostepnych maszyn [szt.]
param maszyny {CZYNNOSCI} >= 0;

# Maksymalny czas produkcji w jednym miesiacu 24 dni po 16 godzin [godz]
param T = 384;

# Maksymalny czas produkcji w jednym miesiacu przez urzadzenia jednego typu [godz]
param T_maszyn {c in CZYNNOSCI} = maszyny[c]*T;

# Maksymalny liczba skladowanych produktow [szt.]
param S = 100;

# Wymagany zapas na koniec marca [szt.]
param Z = 50;

# Koszt skladowania [zl/szt.]
param KS = 0.5;

# Indeks ostatniego miesiaca produkcji
param OstMiesiac = 3;

# Wagi dla metody wazenie ocen
param w1 = 1;
param w2 = 1;




### ZMIENNE ###

# Liczba wyprodukowanych produktow kazdego typu w kazdym z miesiecy [szt.]
var prod {PRODUKTY, MIESIACE} integer >= 0;

# Czas calkowite produkcji na kazdej z maszyn w kazdym z miesiecy [godz]
var czasy_calk {m in MIESIACE, c in CZYNNOSCI} = sum {p in PRODUKTY} prod[p,m]*czasy[c,p];

# Liczba sztuk produktow przechowywanych w magazynie [szt.]
var magazyn {m in MIESIACE, p in PRODUKTY} integer >= 0;

# Sumaryczny koszt przechowywania produktow w magazynie [zl]
var kosztMagazyn = sum {m in MIESIACE, p in PRODUKTY} magazyn[m,p]*KS;

# Zysk czasu otrzymany w kazdym z miesiecy [godz]
var zyskCzasu {m in MIESIACE} >= 0;

# Sumaryczny zysk czasu [godz]
var zyskCzasuSum = sum {m in MIESIACE} zyskCzasu[m];

# Sumaryczny zysk pieniedzy [zl]
var zyskPieniedzy = (sum {p in PRODUKTY, m in MIESIACE} (prod[p,m] - magazyn[m,p])*marze[p]) - kosztMagazyn;




### FUNKCJA CELU ###

# Maksymalizacja zysku pieniedzy oraz zysku czasu
maximize z: w1*(zyskPieniedzy) + w2*(zyskCzasuSum);




### OGRANICZENIA ###

# Ograniczenie czasu uzycia sprzetu do produkcji
s.t. OgrCzasUzycia {c in CZYNNOSCI, m in MIESIACE}: czasy_calk[m,c] <= T_maszyn[c];

# Ograniczenie na maksymalna liczbe produktow przechowywanych w magazynie
s.t. OgrMagazyn {m in MIESIACE, p in PRODUKTY}: magazyn[m,p] <= S;

# Ograniczenie na wymagana liczbe produktow w ostanim miesiacu
s.t. OgrOstMiesiac {p in PRODUKTY}: magazyn[OstMiesiac,p] >= 50;

# Ograniczenia zwiazane z produkcja 
s.t. MagazynMaxStyczen {p in PRODUKTY}: magazyn[1,p] >= prod[p,1] - ogr_rynkowe[1,p];
s.t. MagazynMaxMiesiace {m in 2..OstMiesiac, p in PRODUKTY}: magazyn [m,p] >= prod[p,m] - ogr_rynkowe[m,p] + magazyn[m-1,p];

# Obliczanie zysku czasu w kazdym z miesiecy
s.t. OgryZyskCzasu1 {c in CZYNNOSCI}: zyskCzasu[1] <= min((T_maszyn[c] - czasy_calk[1,c])/maszyny[c]);
s.t. OgryZyskCzasu2 {c in CZYNNOSCI}: zyskCzasu[2] <= min((T_maszyn[c] - czasy_calk[2,c])/maszyny[c]);
s.t. OgryZyskCzasu3 {c in CZYNNOSCI}: zyskCzasu[3] <= min((T_maszyn[c] - czasy_calk[3,c])/maszyny[c]);























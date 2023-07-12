
/* -- DDL -- */

DROP DATABASE IF EXISTS trgovina;
CREATE DATABASE trgovina;
USE trgovina;

CREATE TABLE kupac (
	id INTEGER NOT NULL,
	ime VARCHAR(10) NOT NULL,
	prezime VARCHAR(15) NOT NULL
);

CREATE TABLE zaposlenik (
	id INTEGER NOT NULL,
	ime VARCHAR(10) NOT NULL,
	prezime VARCHAR(15) NOT NULL,
	oib CHAR(11) NOT NULL,
	datum_zaposlenja DATETIME NOT NULL,
    CHECK(prezime!=ime)
);

CREATE TABLE artikl (
	id INTEGER NOT NULL,
	naziv VARCHAR(20) NOT NULL,
	cijena NUMERIC(10,2) NOT NULL,
    UNIQUE(naziv)
);

CREATE TABLE racun (
	id INTEGER PRIMARY KEY NOT NULL,
	id_zaposlenik INTEGER NOT NULL,
	id_kupac INTEGER NOT NULL,
	broj VARCHAR(100) NOT NULL,
	datum_izdavanja DATETIME NOT NULL
);

CREATE TABLE stavka_racun (
	id INTEGER NOT NULL,
	id_racun INTEGER NULL,
	id_artikl INTEGER NOT NULL,
	kolicina INTEGER NOT NULL,
    FOREIGN KEY (id_racun) REFERENCES racun(id)
    ON DELETE SET NULL
);


/* == Unos podataka == */
INSERT INTO kupac VALUES (1, 'Lea', 'Fabris'),
                         (2, 'David', 'Sirotić'),
                         (3, 'Tea', 'Bibić');

INSERT INTO zaposlenik VALUES 
	(11, 'Marko', 'Marić', '123451', STR_TO_DATE('01.10.2020.', '%d.%m.%Y.')),
	(12, 'Toni', 'Milovan', '123452', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.')),
	(13, 'Tea', 'Marić', '123453', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.'));

INSERT INTO artikl VALUES (21, 'Puding', 5.99),
                          (22, 'Milka čokolada', 30.00),
                          (23, 'Čips', 9);

INSERT INTO racun VALUES 
	(31, 11, 1, '00001', STR_TO_DATE('05.10.2020.', '%d.%m.%Y.')),
	(32, 12, 2, '00002', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.')),
	(33, 12, 1, '00003', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.'));

INSERT INTO stavka_racun VALUES (41, 31, 21, 2),
                                (42, 31, 22, 5),
                                (43, 32, 22, 1),
                                (44, 32, 22, 1);
                                
/* -- ZADACA 2: Ogranicenja -- */

/*
   Dodaj ograničenje koje će osigurati da je naziv artikla jedinstven

   Dodaj ograničenje koje će zabranit unos zaposlenika kojemu je ime isto kao i prezime
   (npr. unos zaposlenika sa imenom i prezimenom 'Teo Teo' će rezultirati greškom)

   Doradi skriptu tako da se prilikom brisanja računa, na sve povezane stavke kao referentna
   vrijednost stranog ključa postavi vrijednost NULL
*/

/*  Napravi pogled (View) koji prikazuje sve kupce koji imaju ime jednako prezimenu, pritom je
    omogućen unos kupaca kroz pogled samo ukoliko je navedeni uvjet zadovoljen */

Create view kupci_imeprezime as select ime,prezime
from kupac
where ime like prezime
with check option;




 /* Napravi pogled (View) koji prikazuje sve račune i njihov ukupan iznos. Nakon toga napiši upit
    koji koristi prethodno napravljeni pogled kako bi se pronašao račun sa najvećim iznosom */

create view racun_sum_iznos as select r.id, sum(kolicina*cijena)
as ukupna_cijena_racun
from artikl a, racun r, stavka_racun sr
where a.id=sr.id_artikl and r.id=sr.id_racun
group by r.id;

select*
from racun_sum_iznos
order by ukupna_cijena_racun
desc
limit 1;

Select max(ukupna_cijena_racun)
From racun_sum_iznos;

Select *
From racun_sum_iznos
where ukupna_cijena_racun =(Select max(ukupna_cijena_racun)
From racun_sum_iznos);

drop view racun_sum_iznos;




/* -- ZADACA 1: Upiti -- */

-- 1. Prikaži sve zaposlenike čije ime sadrži barem 4 slova

SELECT    *
FROM      zaposlenik
WHERE     LENGTH (zaposlenik.ime) > 3;







-- 2. Prikaži sva imena zaposlenika koja se pojavljuju kao imena kupaca

SELECT     ime 
FROM       zaposlenik 
WHERE      ime 
IN         (SELECT ime FROM kupac);







-- 3. Ažuriraj artikle tako da im se cijena spusti za 10%

UPDATE   artikl
SET      cijena=cijena-3.00;

SELECT MAX(cijena) FROM artikl;







-- 4. Prikaži artikle koji imaju iznadprosječnu cijenu

SELECT    * 
FROM      artikl
WHERE     cijena > (SELECT AVG(cijena) AS iznadprosjecna_cijena FROM artikl);








/* 5. Prikaži sve artikle i račune na kojima su izdani, pritom prikazati i artikle koji nisu niti jednom
      kupljeni (niti jednom dodani na stavke računa) */
      
 SELECT           *
 FROM             kupac
 LEFT OUTER JOIN  racun ON racun.id_kupac = kupac.id;      
      
      
      
      
      
      
      
      
-- 6. Prikaži najučestalijeg kupca (kupac koji ima najviše računa)

SELECT *, COUNT(*) Najucestaliji FROM kupac INNER JOIN racun ON racun.id_kupac=kupac.id
GROUP BY kupac.id
HAVING COUNT(*);



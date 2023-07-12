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
	datum_zaposlenja DATETIME NOT NULL
);

CREATE TABLE artikl (
	id INTEGER NOT NULL,
	naziv VARCHAR(20) NOT NULL,
	cijena NUMERIC(10,2) NOT NULL
);

CREATE TABLE racun (
	id INTEGER NOT NULL,
	id_zaposlenik INTEGER NOT NULL,
	id_kupac INTEGER NOT NULL,
	broj VARCHAR(100) NOT NULL,
	datum_izdavanja DATETIME NOT NULL
);

CREATE TABLE stavka_racun (
	id INTEGER NOT NULL,
	id_racun INTEGER NOT NULL,
	id_artikl INTEGER NOT NULL,
	kolicina INTEGER NOT NULL
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
                                
                 
                 
  /* -- VJEZBA -- */               

-- 1. Prikaži sve kupce sa imenom 'Lea' ili 'David'

SELECT   * 
FROM     kupac 
WHERE    ime='Lea' OR ime='David';





-- 2. Prikaži id-eve i puno ime (spojeno ime i prezime) svih kupaca

SELECT   id, CONCAT(ime,prezime) AS puno_ime
FROM     kupac;






/* 3. Prikaži sve artikle koji imaju cijenu između 6 i 100 (tj. [6, 100]) 
      i sortiraj rezultat silazno prema cijeni */

SELECT     * 
FROM       artikl
WHERE      cijena>=6 AND cijena <=100
ORDER BY   cijena DESC;






/* 4. Prikaži imena sa velikim slovima i dužinu imena (broj slova u imenu) 
      svih kupaca čije prezime završava na 'ić' */

SELECT   UPPER(ime) AS Veliko_ime, 
         COUNT(ime) AS Broj_slova, 
		 prezime LIKE '%ić' AS Odredeno
FROM     kupac;






-- 5. Prikaži sva jedinstvena prezimena zaposlenika

SELECT DISTINCT   prezime
FROM              kupac;






-- 6. Prikaži sva imena zaposlenika i kupaca u jednom stupcu

SELECT ime FROM zaposlenik 
UNION
SELECT ime FROM kupac;






/* 7. Prikaži prezimena i imena svih zaposlenika tako da su 
      sortirani silazno prvo po prezimenu pa po imenu */

SELECT    ime, prezime 
FROM      zaposlenik 
ORDER BY  prezime DESC, ime ASC;







-- 8. Prilaži sve kupce i njihove pripadne račune

SELECT * FROM kupac, racun
WHERE kupac.id=racun.id_kupac;







/* 9. Prikaži sve kupce i njihove pripadne račune, 
      a pritom prikazati i kupce koji nemaju niti jedan račun */

SELECT            * 
FROM              kupac 
LEFT OUTER JOIN   racun ON racun.id_kupac=kupac.id;









/* 10. Prikaži sve kupce i zaposlenike koji su "surađivali" (navedeni na istim računima),
       pritom prikazati kupce i zaposlenike koji nisu navedeni na niti jednom računu */

SELECT kupac.*, zaposlenik.* FROM racun
INNER JOIN kupac ON racun.id_kupac=kupac.id
RIGHT OUTER JOIN zaposlenik ON racun.id_zaposlenik=zaposlenik.id;








-- 11. Prikaži sve zaposlenike koji se zovu 'Lea', 'David' ili 'Tea'

SELECT * FROM     zaposlenik 
WHERE             ime='Lea' OR ime='David' OR ime='Tea';









-- 12. Prikaži najveću, najmanju i srednju cijenu artikala

SELECT     MAX(cijena) AS Najveca_cijena, 
           MIN(cijena) AS Najmanja_cijena, 
           AVG(cijena) AS Srednja_cijena 
FROM       artikl;






-- 13. Prikaži artikl sa najvećom cijenom

SELECT    MAX(cijena) AS Najveca_cijena 
FROM      artikl;








-- 14. Prikaži sve kupce i broj njihovih računa

SELECT k.*, COUNT(r.id) AS broj_racuna
 FROM kupac k
 INNER JOIN racun r ON k.id = r.id_kupac
 GROUP BY k.id;









-- 15. Prikaži sve kupce i broj njihovih računa, pritom prikazati samo one kupce koji imaju barem dva računa

SELECT     kupac.*, broj 
FROM       kupac,racun
WHERE      kupac.id=racun.id_kupac
GROUP BY   kupac.id
HAVING     COUNT(racun.id)>1;







-- 16. Prikaži sve račune i njihov ukupan iznos

SELECT r.*, SUM(cijena * kolicina)
 FROM racun r
 INNER JOIN stavka_racun s ON s.id_racun = r.id
 INNER JOIN artikl a ON s.id_artikl = a.id
 GROUP BY r.id;






-- 17. Prikaži sve artikle koji su izdani u ukupnoj količini većoj od 5

SELECT a.*
 FROM artikl a
 WHERE a.id IN (SELECT id_artikl
 FROM stavka_racun
 GROUP BY id_artikl
 HAVING SUM(kolicina) > 5);







-- 18. Napravi pogled koji prikazuje sve račune i njihov ukupan iznos

CREATE VIEW racun_sa_iznosom AS
SELECT r.*,
 SUM(cijena * kolicina) AS iznos
 FROM racun r
 INNER JOIN stavka_racun s ON s.id_racun = r.id
 INNER JOIN artikl a ON s.id_artikl = a.id
 GROUP BY r.id;







-- 19. Napravi pogled koji prikazuje skupe artikle (cijena > 10), pritom se kroz pogled mogu unositi podaci

CREATE VIEW skup_artikl AS
SELECT *
 FROM artikl
 WHERE cijena > 10;
 
/* dohvaćanje podataka pogleda */

SELECT *
 FROM skup_artikl;






/* 20. Napravi pogled koji prikazuje skupe artikle (cijena > 10), pritom se kroz pogled mogu
       unositi samo podaci koji zadovoljavaju uvjet (cijena > 10) */
       
DROP VIEW skup_artikl;
CREATE VIEW skup_artikl AS
SELECT *
 FROM artikl
 WHERE cijena > 10
WITH CHECK OPTION;



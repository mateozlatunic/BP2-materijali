DROP DATABASE trgovina;
CREATE DATABASE trgovina;
USE trgovina;


CREATE TABLE kupac (
	id INTEGER PRIMARY KEY NOT NULL,
	ime VARCHAR(10) UNIQUE NOT NULL,
	prezime VARCHAR(15) UNIQUE NOT NULL,
    CHECK(LENGTH(prezime)>LENGTH(ime))
);
CREATE TABLE zaposlenik (
	id INTEGER PRIMARY KEY NOT NULL,
	ime VARCHAR(10) NOT NULL,
	prezime VARCHAR(15) NOT NULL,
	oib CHAR(11) UNIQUE NOT NULL,
	datum_zaposlenja DATETIME NOT NULL
);
CREATE TABLE artikl (
	id INTEGER PRIMARY KEY NOT NULL,
	naziv VARCHAR(20) NOT NULL,
	cijena NUMERIC(10,2) NOT NULL,
    CHECK(cijena>-1)
);
CREATE TABLE racun (
	id INTEGER PRIMARY KEY NOT NULL,
	id_zaposlenik INTEGER NOT NULL,
	id_kupac INTEGER NOT NULL,
	broj VARCHAR(100) NOT NULL,
	datum_izdavanja DATETIME NOT NULL,
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik (id),
    FOREIGN KEY (id_kupac) REFERENCES kupac (id)
);
CREATE TABLE stavka_racun (
	id INTEGER PRIMARY KEY NOT NULL,
	id_racun INTEGER NOT NULL,
	id_artikl INTEGER NOT NULL,
	kolicina INTEGER NOT NULL,
	FOREIGN KEY (id_racun) REFERENCES racun(id),
    FOREIGN KEY (id_racun) REFERENCES racun(id) ON DELETE CASCADE,
	FOREIGN KEY (id_artikl) REFERENCES artikl(id),
    UNIQUE (id_racun,id_artikl)
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
                                (44, 32, 23, 1);



# - Dodaj primarne i strane ključeve na sve tablice  /* ==> DONE <== */


# - Dodaj ograničenje tako da smije postojati samo jedan kupac sa određenim imenom i prezimenom 
# - (npr. ime i prezime 'Tea Ivić' se ne smije dva puta ponoviti) /* ==> DONE <== */


# - Dodaj ograničenje tako da se određeni artikl može samo jednom dodati na račun /* ==> DONE <== */


# - Dodaj ograničenje da cijena artikla mora biti pozitivna /* ==> DONE <== */


# - Dodaj ograničenje da prezime kupca mora biti duže nego ime (prezime mora imati veći broj slova od imena) /* ==> DONE <== */


# - Stavke računa nemaju smisla postojati bez računa. 
#   Dodaj ograničenje koje će prilikom brisanja računa, automatski brisati i stavke računa /* ==> DONE <== */



# Schemas: 
# - Napravi novu bazu podataka sa istom skriptom sa nazivom 'trgovina_2' i prikaži sve korisnike
# - iz baza podataka 'trgovina' i 'trgovina_2' /* ==> DONE <== */
 
 CREATE DATABASE trgovina_2;
 USE trgovina;
 
 SELECT * FROM trgovina.kupac
 UNION ALL
 SELECT * FROM trgovina_2.kupac;

 
 

 
 

 
 
 
# Pogled (View)
#  - Napravi pogled koji prikazuje sve račune i njihov ukupan iznos


SELECT * FROM racun;



 
 
 
 
 



# Pogled (View) & Unos podataka
# - Napravi pogled koji prikazuje skupe artikle (cijena > 10), pritom se kroz pogled mogu unositi podaci






 
 
 
 

 
# Pogled (View) WITH CHECK OPTION 
# - Napravi pogled koji prikazuje skupe artikle (cijena > 10), pritom se kroz pogled mogu unositi samo podaci koji zadovoljavaju uvjet (cijena > 10)
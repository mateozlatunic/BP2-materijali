DROP DATABASE trgovina;
CREATE DATABASE trgovina;
USE trgovina;

CREATE TABLE kupac (
	id INTEGER NOT NULL,
	ime VARCHAR(10) NOT NULL,
	prezime VARCHAR(15) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE zaposlenik (
	id INTEGER NOT NULL,
	ime VARCHAR(10) NOT NULL,
	prezime VARCHAR(15) NOT NULL,
	oib CHAR(11) NOT NULL,
	datum_zaposlenja DATETIME NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE artikl (
	id INTEGER NOT NULL,
	naziv VARCHAR(20) NOT NULL,
	cijena NUMERIC(10,2) NOT NULL,
    CHECK (cijena > 0),
	PRIMARY KEY (id)
);

CREATE TABLE racun (
	id INTEGER NOT NULL,
	id_zaposlenik INTEGER NOT NULL,
	id_kupac INTEGER NOT NULL,
	broj VARCHAR(100) NOT NULL,
	datum_izdavanja DATETIME NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik (id),
	FOREIGN KEY (id_kupac) REFERENCES kupac (id)
);

CREATE TABLE stavka_racun (
	id INTEGER NOT NULL,
	id_racun INTEGER NOT NULL,
	id_artikl INTEGER NOT NULL,
	kolicina INTEGER NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id_racun) REFERENCES racun (id) ON DELETE CASCADE,
	FOREIGN KEY (id_artikl) REFERENCES artikl (id),
	UNIQUE (id_racun, id_artikl)
);



INSERT INTO kupac VALUES (1, 'Lea', 'Fabris'),
                         (2, 'David', 'Sirotić'),
                         (3, 'Tea', 'Bibić');

INSERT INTO zaposlenik VALUES (11, 'Marko', 'Marić', '123451', STR_TO_DATE('01.10.2020.', '%d.%m.%Y.')),
							  (12, 'Toni', 'Milovan', '123452', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.')),
							  (13, 'Tea', 'Marić', '123453', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.'));

INSERT INTO artikl VALUES (21, 'Puding', 5.99),
                          (22, 'Milka čokolada', 30.00),
                          (23, 'Čips', 9);

INSERT INTO racun VALUES (31, 11, 1, '00001', STR_TO_DATE('05.10.2020.', '%d.%m.%Y.')),
						 (32, 12, 2, '00002', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.')),
						 (33, 12, 1, '00003', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.'));

INSERT INTO stavka_racun VALUES (41, 31, 21, 2),
                                (42, 31, 22, 5),
                                (43, 32, 22, 1),
                                (44, 32, 23, 1);



# Imenovanje ograničenja: imenuj sva ograničenja u tablici 'artikl' i isprobaj sljedeći insert prije i poslije imenovanog ograničenja
# Zašto je korisno imenovati ograničenja?
INSERT INTO artikl VALUES(25, "Fanta", -1);











# Naknadno mijenjanje tablica: Dodaj ograničenje na tablicu 'stavka_racun' koje osigurava pozitivnu 'kolicinu' (bez brisanja i kreiranja tablice)














# Datumski i vremenski tipovi podataka: Unesi nove podatke u tablicu i promatraj rezultate

CREATE TABLE test_datum_vrijeme (
	datum DATE,
	vrijeme TIME,
	vrijeme_p TIME(5)
);











# Tipovi podatka koji sadrže istodobno vrijeme i datum: Unesi nove podatke u tablicu i promatraj rezultate

CREATE TABLE datum_vrijeme (
	datum_datetime DATETIME,
    datum_timestamp TIMESTAMP
);













# Napiši upit koji rezultira stupcima "Sat", "Minute", "Godina" čije vrijednosti su izvučene iz stupca "datum_datetime" (tablica 'datum_vrijeme')













    
    
# Napiši upit koji će prikazati stupac 'datum_datetime' (tablica 'datum_vrijeme') 
# u formatu sljedećeg primjera: "Dan: 21, Mjesec: 10, Godina 2021, Vrijeme 14:01:33" 














# Intervali: 

# Zadatak: Prikaži sve račune koji su izdani u posljednjih godinu dana (unatrag godinu dana od današnjeg dana)














# Privremene tablice
# Koja je razlika između "privremene" tablice i "obične" tablice? 
# Što je to sesija i koliko ona traje?
# Zašto bismo uopće koristili privremene tablice

# Kreiraj privremenu tablicu "prihod_na_dan" i u nju spremi prihode po datumima ostvarene kroz račune

















# Koja je razlika između View-a (pogleda) i Temporary (privremene) tablice?











# Kreiraj (običnu) tablicu "proizvod" koja će biti kopija tablice "artikl"






# Ako sada mijenjamo podatke u tablici "proizvod", mijenjaju li se ti podaci odmah u tablici "artikl"? Zašto da/ne?









# Zadatak: kreiraj tablicu "jeftini_artikli" koja će biti iste strukture kao tablica "artikl" 
# i sadržavati samo artikle koji imaju ispodprosječnu cijenu
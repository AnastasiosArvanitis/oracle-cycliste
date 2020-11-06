select c.dossard, c.nom, c.prenom, e.nom as "Nom equipe"
from coureurs c
join equipes e on c.equipe = e.code
order by 4;

select nom ||' '|| prenom as "Coureur full name"
from coureurs
where nationalite like 'FRA'
order by 1;

select c.nom ||' '|| c.prenom as "Coureur full name",
    c.nationalite as "Nationalite coureur",
    e.nom as "Equipe name", e.nationalite as "Nationalite equipe"
from coureurs c
    join equipes e on c.equipe = e.code
where c.nationalite like 'FRA'
and e.nationalite like 'FRA'
order by 1;

select * from etapes;

--Déterminez la distance totale parcourue sur le tour.

select sum(distance) as "Total distance"
from etapes;

--Comptez combien d’étapes se sont déroulées un dimanche.
select count(*) as "total etapes"
from etapes
where lower(to_char(jour, 'day')) like 'dimanche';

--Établissez le classement individuel 
--à l’issue du prologue (première étape).
select c.dossard, c.prenom ||' ' ||c.nom as "Coureur full name", 
e.jour
from etapes e
join resultats r on e.code = r.etape
join coureurs c on r.coureur = c.dossard
where e.jour = (select min(jour) from etapes)
order by r.temps asc;


select * from resultats;

--coureurs par equipe 
select count(c.dossard) as "Count courreurs", 
    e.code as "Equipe code"
from coureurs c
right join equipes e on c.equipe = e.code
group by e.code
order by 1 desc;













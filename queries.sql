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

--D�terminez la distance totale parcourue sur le tour.

select sum(distance) as "Total distance"
from etapes;

--Comptez combien d��tapes se sont d�roul�es un dimanche.
select count(*) as "total etapes"
from etapes
where lower(to_char(jour, 'day')) like 'dimanche';

--�tablissez le classement individuel 
--� l�issue du prologue (premi�re �tape).
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

SELECT MIN(TO_CHAR(temps,'HH:MI:SS')) ,etape 
FROM resultats 
WHERE etape IN  (
    SELECT code FROM etapes WHERE distance BETWEEN 5 and 50) 
GROUP BY etape;

-- quels sont les coureurs qui n�ont pas de r�sultats ? 
select c.nom ||' '||c.prenom as "Coureur full name"
from coureurs c
left join resultats r on c.dossard = r.coureur
where r.etape is null;

-- nombre de nationalit�s par �quipe

------ PROCEDURE---------------------
--Le nombre de coureurs la composant ainsi que le d�tail de ces 
    --coureurs (dossard, nom et pr�nom).
--Sa nationalit�. Est-ce la seule �quipe de cette nationalit� ?
--Le nombre de nationalit�s diff�rentes parmi les coureurs de cette �quipe.
--La derni�re �tape � laquelle au moins un de ses membres a particip�.

create or replace procedure infoEquipe(pcode varchar) is

vnb integer;
cursor CurCoureurs is 
        select dossard, nom, prenom
        from coureurs
        where equipe = pcode;
vnat varchar2(3);
vetape varchar2(8);
vjour date;
vvilles varchar2(200);

begin
    select count(*) into vnb 
    from equipes
    where code = pcode;
        if vnb = 0 then
            raise_application_error(-20052, 'Cette equipe n''existe pas');
        end if;
    select count(*) into vnb 
    from coureurs
    where equipe = pcode;
        if vnb = 0 then
            dbms_output.put_line('Cette equipe ne dispose d''aucun coureur');
        else
            dbms_output.put_line('Cette equipe est compos�e de '|| vnb 
            ||' coureurs : ');
        
        for vcour in CurCoureurs 
        loop
        dbms_output.put_line('     '|| vcour.nom ||'     '|| vcour.prenom||
        '      dossard numero '|| vcour.dossard);
        end loop;
        
        dbms_output.new_line;
        
    select nationalite into vnat
    from equipes
    where code = pcode;
    select count(*) -1 into vnb
    from equipes
    where nationalite = vnat;
        if vnb = 0 then
            dbms_output.put_line('Cette equipe est de nationalit� '|| vnat || 
            '. c''est la seule equipe de cette nationalite');
        else 
            dbms_output.put_line('Cette �quipe est de nationalit� ' || vnat ||
            '. Il y a  '|| vnb || ' autre(s) �quipe(s) de cette nationalit�'); 
        end if;
        
    select count(distinct nationalite) into vnb
    from coureurs
    where equipe = pcode;
        dbms_output.put_line('On trouve '|| vnb || 'nationalite differentes au sein de l''equipe');
        
        dbms_output.new_line;
        
    select count(*) into vnb from resultats
    inner join coureurs on coureurs.dossard = resultats.coureur
    where coureurs.equipe = pcode;
        if vnb = 0 then
            dbms_output.put_line('Cette equipe ne dispose d''aucun resultat');
        else 
            select distinct etape, jour, villedepart || ' � ' || villearrivee 
            into vetape, vjour, vvilles
            from resultats
            inner join coureurs on coureurs.dossard = resultats.coureur
            inner join etapes on etapes.code = resultats.etape
            where coureurs.equipe = pcode
            order by jour desc fetch first 1 rows only;
            dbms_output.put_line('Les derniers r�sultats pour cette �quipe 
            concernent  l''�tape ' || vetape || ' qui part de '|| vvilles ||
            ' et s''est d�roul�e le '|| vjour);
        end if;
    end if;
end;
/
            
begin 
   infoEquipe('A2R');
end; 
/ 
select * from equipes;

---------------------------------------------------------------------------------

















//Using Neo4J-empty project, build a representation of the relationship between the following fighters (fighter is a Node{name,weight}, beat is a relationship). 
Create(p:Fighter {name:'Khabib Nurmagomedov',weight:'155'}),(pp:Fighter {name:'Rafael Dos Anjos', weight:'155'}), (p)-[:beats]->(pp)
Create(nm:Fighter{name:'Neil Magny', weight:'170'}), (pp)-[:beats]->(nm)
Create(jj:Fighter{name:'Jon Jones',weight:'205'}),(dc:Fighter{name:'Daniel Cormier', weight:'205'}), (jj)-[:beats]->(dc)
Create(mb:Fighter{name:'Michael Bisping',weight:'185'}),(mh:Fighter{name:'Matt Hamill', weight:'185'}), (mb)-[:beats]->(mh)
Create(bv:Fighter{name:'Brandon Vera', weight:'205'}), (jj)-[:beats]->(bv)
Create(fm:Fighter{name:'Frank Mir', weight:'230'}), (bv)-[:beats]->(fm)
Create(bl:Fighter{name:'Brock Lesnar', weight:'230'}), (fm)-[:beats]->(bl)
Create(kg:Fighter{name:'Kelvin Gastelum', weight:'185'}), (nm)-[:beats]->(kg)
Create(kg)-[:beats]->(mb), (mb)-[:beats]->(mh), (mb)-[:beats]->(kg), (mh)-[:beats]->(jj)


//Part2:
//Return all middle/Walter/light weight fighters (155,170,185) who at least have one win. 
Match(p:Fighter)-[:beats]->(pp:Fighter) where p.weight = '155' or p.weight = '170' or p.weight = '185' return p
//Return fighters who had 1-1 record with each other. 
Match (p: Fighter), (pp:Fighter) where size((p)-[:beats]->(pp)) = 1 and size((pp)-[:beats]->(p)) = 1 return p, pp
//Return all fighter that can “Khabib Nurmagomedov” beat them and he didn’t have a fight with them yet
Match(p:Fighter{name:'Khabib Nurmagomedov'})-[:beats *2..10]->(pp:Fighter) return distinct pp
//Return undefeated Fighters(0 loss), defeated fighter (0 wins). 
Match (defeated:Fighter)  where not exists ((defeated) -[:beats]-> ()) return defeated
Match (undefeated:Fighter)  where not exists (() -[:beats]-> (undefeated)) return undefeated
//Return all fighters MMA records and create query to enter the record as a property for a fighter {name, weight, record}
Match (p: Fighter) Set p.record = [size(()-[:beats]->(p)), size((p)-[:beats]->())] return p
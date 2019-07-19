### Pokemon ###
**Class vs YAML**
1. YAML makes sense because all of the Pokemon will be pre-loaded and the ability to add more will not be allowed.
2. Class makes sense if I want to extend the possibility of adding new Pokemon in the future.
3. YAML is much simpler than writing a new class and separate file to contain and then create all of the objects of the Pokemon class.
**YAML**
1. Store all attributes in a hash.
- key:value => stats: { atk: 45, def: 54, ... }
2. Store the Pokemon's stats and types similarly to the users in the original project for RB175 that required a yml file.
3. Create method that can select a Pokemon by an input type. 
- select_Poke(type_to_beat: "Grass") => all Pokemon that are: Fire, Flying, or Bug.
4. Create method that can select a Pokemon by a specific stat.
- If user is looking for a wall for a certain Pokemon, it will look at the stronger of the two (atk or sp.atk) and find a Pokemon that has a correspondingly higher or equal def/sp.def.
- select_Wall(stat_to_beat: atk, 95, types) => Pinsir (def: 100)
- select_Attacker(weak_stat: sp_def, types) => Pinsir (atk: 125)
- select_Attacker will work by attacking the weaker stat.
5. If 5 Pokemon are not found, search all types EXCEPT the types that are weak to the Pokemon's type selected.
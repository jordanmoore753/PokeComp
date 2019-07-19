### Pokemon App ###

**Features**
1. Counters
- select by Wall
- select by Attacker
2. Pokemon Descriptions
- only including final evolutions and single-stage
- include icon pictures for use in lists
- only including types and stats, no moves
3. Mini-Forum 
- discuss movesets, teambuilding, counters
- submit thread
- submit replies
4. Users
- saved teams
  - max 3
- record (W/L)
- register
- submit tournament
- guild

**Implementation**
1. Create poke.rb
- this file will contain the classes for storing Pokemon information (stats, name, type(s))
- this file will contain the methods for retrieving and comparing Pokemon data (finding counter)
2. Create users
- Create yaml file.
- Store users like the Pokemon.
- Hashes necessary: Teams, Tournaments, W/L, Messages, Posts
- Separate classes for: Tournaments, Messages, Post
- Tournament:
  - has a name, signed-up users, date, requirements, details. stored in tournaments.yaml
- Messages:
  - have a title, from user, addressed user, date, paragraphs. stored in users.yaml
- Post:
  - have a title, date, paragraphs, from user. stored in posts.yaml.
3. Fix Navbar for mobile styles (not media query). Need to put 
inline styles for it.
4. Make route for creating teams. 
- Need a form with 6 dropdown lists.
- The dropdown list uses the pokemon list to populate it. Use select tag and iterate through the hash.
- new option tag for each element.
- Then, in the profile, have one of the boxes have three teams possible. From left to right (1-6) show
the pokemon just by icon.

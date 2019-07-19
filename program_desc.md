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
5. Allow users to submit more mons for checks/counters.
- Third grid item on check and counter pages.
- Height should take up whatever isn't taken up by the 2nd container in comparison to the first large one.
- Update counter page to have the correct paragraphs and picture explanation.
- Separate form that takes user to the post/submit_check or submit_counter, which then redirects to forum/profile.
- Uploads as a forum post instead of a separate file.
- Use password generator as unique key and then have the instance variables of the object assigned to it as array
elements.
- Title of post is the two pokemon and the relationship. Paragraphs is the textarea. Date is assigned. User is from session.
- Iterate through forum posts by index so the key is irrelevant.
6. Create forum for regular posts.
- Post object already created.
- Create a grid layout. One column 
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
- Create a grid layout. One column.
- Articles will be created and uploaded from a folder called articles in data directory.
- Articles must be written in markdown format. All scripts will be escaped.
- The main content div will display the data.
- Articles will have a title, date, user, and content (markdown).
- Store user, date, and title who submitted in the file name at the end:
  - file_name_admin_07192019 (admin = user, 07192019 = date, title = File Name)
  - if name already exists, error
  - if name contains inappropriate symbols, error
7. Create tournament forum.
- Similar format as articles.
- The tournament now will be YAML file that stores a Tournament object.
- I can edit this object through its instance methods.
- The creation process won't need admin approval. I don't see it as necessary. People will sign up if they want to, no need to moderate it.
- Must be logged in to create a tournament.
- Tournaments are displayed by most immediate closest date.
- Display data includes: tier, generation, style, date, and title. Users are visible once you click on the actual tournament link.
- Tiers, generation, and style are dropdown. Title can't contain any invalid chars like scripts.
- Details has a 300 character limit and is provided by a textarea.
- Display the tournaments in the same manner as articles, by index. Sort them by date. Load each of the files then with map and create through the title through the getter methods.
- MAKE CHECK TO ENSURE THAT TOURNAMENT DOESNT EXIST ALREADY
- Add tournaments and articles to a user's respective instance variables for display on profile.
- A couple of methods would do this just fine.
- We need to find the certain user (find_user method) and then pass in the new article or tournament object.
- Then, we just invoke the method on the object that adds it to the correct instance variable.
8. Refactor all of the methods. The program is a complete mess right now. Look at register and login for an idea of what to do.
9. Profile View
- List of first three tournaments
- Pokemon Team
- List of articles written by user
- Biography / description
- Message send
-- Change the param in :user to :idx and sort the users
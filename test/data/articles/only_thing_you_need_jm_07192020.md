### Why PEDAC is like Chocolate Cake
This article does involve chocolate cake, I promse. But first, I need some answers from you.

Which method do you think is best for problem solving? 

1. Hack and Slash
2. Planning a Strategy

Hopefully, you think that #**2** is the best option. I think it is, even though I need to get much better at it.

Taking one's time in reading the problem, understanding the problem, and generating pseudocode to craft a solution is essential to being an efficient programmer.

There are **5** steps in the **PEDAC** process of problem-solving. It's not an easy formula to follow, as it requires patience, discipline, and ample time to think, but I think it's well worth embracing the grind for.
#### What is PEDAC?
By now you've probably realized that PEDAC is an acronym.

**PEDAC** stands for:
1. Process the problem.
2. Examples and Test Cases
3. Data Structure(s)
4. Algorithm
5. Code with Intent

If you're in RB101, you probably think you're already doing this; however, there is a big difference between the following:

`input = string`
`output = integer`
`rules = convert a string to its integer equivalent`,

and actually adhering to each step of the PEDAC process. Obviously, the example above is simple and doesn't require much pseudocode or thought. It also is an example of my recent code!

In the spirit of Launch School, let's engage in a **thorough** breakdown of each step in the **PEDAC** process to reach one step closer towards mastery.

#### Process the Problem

First, let's identify a problem to use PEDAC with.

`As a data engineer your first task is to make vowel recognition dataset. In this task you have to find the presence of vowels in all possible substrings of the given string. For each given string you have to print the total number of vowels.`

Overall, this is a very straight-forward problem. It is also a **6 kyu** question on CodeWars, created by **DarkD1** and is on par with what would be asked for in the RB109 Interview Assessment. I recommend searching for this problem on CodeWars **after** we've followed every step of the **PEDAC** process for it. Don't worry-- I won't solve the problem in this article, so you won't be spoiled. Earn that *kyu*!

The problem is titled: *Vowel Recognition*.

Okay, now back to processing the problem. The most important part of processing the problem, in my opinion, is abstaining from any real coding. In fact, you don't even need to be in your text editor for this. You can use **Boostnote**, like I'm using right now, or Notepad, a real notebook, or a scrap of toilet paper. All that matters is that you do not rush into coding. The goal here is to break the problem down thoroughly in your native language **before** you even touch it with your programming language.

I cannot stress this enough: read the problem carefully. Treat it like a snake-charmer handles a King Cobra. 

Some of the problems you will encounter are tricky, purposefully or accidentally, and it's your job to avoid the pitfall of creating a solution to a problem that was never even actually asked. 

To illustrate with an example: a couple of days ago I spent two hours "solving" a problem on CodeWars. I put solving in quotes because I wasn't even actually solving what the user had asked for. I was off on some wild goose chase in my text editor, without a clue of where I'm going, while moving at a break-neck pace of hack and slash coding. I'm not going to post which problem it was here because if I did, you'd be disgusted with my lack of processing the problem and close out of this tab immediately.

So, you've been thoroughly scared into reading the problem. What do we do from here? We can't code, right?

##### Input and Output 
Let's identify the `input`, `output`, and `rules` of the problem. If we can do these steps confidently, then we can be confident that our understanding of the problem is adequate for the time being.

So, the `input` for our problem is a `string`, since it says:

`...of the given string...`

and that means that the string is being passed in as an `argument` to the method invocation. And yes, it pays to be this precise with your vocabulary and syntax.

For this question and many others on CodeWars, the user has spent a huge amount of time creating and testing cases for the solution and sometimes will leave out information in the problem details because of sheer exhaustion. So, you may need to do some sleuthing to figure out what's being asked for. 

In this example, the output is clear. The output is `an integer`. It's up to you how specific you want to be with **what** the integer represents in this part. All we need to know right now is what type of objects represent the input and object, so our answers are fine.

##### Rules are Good!
Next we will define our rules. If the problem description isn't descriptive enough to give you a good idea of the hard limits and rules of the question, then look for the examples that most authors provide. The author in this question has graciously given us a great description **and** an example. Thanks, DarkD1! 

Here's the example: `In given sample test case, first string is "baceb" so the substrings are b, ba, bac, bace, baceb, a, ac, ace, aceb, c, ce, ceb, e, eb, b and the number of vowels in each substring are 0, 1, 1, 2, 2, 1, 1, 2, 2, 0, 1, 1, 1, 1, 0 and the total number is sum of all presence which is 16.`

###### Clarifying Questions
What rules can we identify from this and the problem description? Well, there are a few definitions we need to clarify for ourselves to ensure we understand the problem completely. In this question, our clarifying questions might be:

1. What is a substring?
2. What is a vowel?
3. What is a sum?

If there are some terms in the question that you do not know, then you'll need to understand them before proceeding. I know from first-hand experience with some of the questions in RB101 how frustrating it can be to go back to what seems like 8th Grade Mathematics in order to understand what the question is asking for; however, the problem can **never** be solved without the required knowledge. So, the question changes from:

`How do I solve this problem?`

to: 

`How badly do I want to solve this problem?`

My advice is to embrace the feeling of inadequacy, simply for the fact that it will never go away. There is **always** going to be something that you do not know, especially in programming, where there are hundreds of languages, methods, self-defined methods, gems, libraries; there's just too much for one mind to keep track of. 

Remember when SpongeBob finally embraced his ugliness? Remember how beautiful that moment was, all the green odor proudly seeping from his pores? 

Channel your inner Sponge, pull up your black boots, grab your spatula, and get to work learning what you need to know.

##### Pep-talk over, Back to Rules
In this question there aren't many rules to keep track of. 

Before scrolling down further, create the list of rules that **you** see in this problem. Then, check your list against mine below. I'm not an expert yet, so I may have missed some things, so feel free to give me some feedback on this in the comments. 

###### Rules I Found
1. Each substring must have its own vowel count.
2. Each letter in the `input string` must be used for generating substrings.
3. The `output` must be the sum of **all** substring vowel counts.
4. Lower and upper case should be checked for.

Are our rule lists different? The same? Post yours in the comments!

##### Mental Model
This is an optional step, but I think it's an important part of the PEDAC process and deserves its own letter in the acronym. 

However, **PMEDAC** sounds terrible. 

The **M** in PMEDAC stands for *Mental Model*. This definition can be a little confusing, so I'll illuminate its meaning with an example, too.

A mental model is an explanation of someone's thought process about how something in the **real world** works. 

That's a very simple, yet abstract definition. Let's break it down with an example.

Remember the concept of **Checks and Balances** in US History? Essentially, it means that the US Government is split into different sections with their own powers. This splitting of power between three branches ensures that no one branch of government can ever overpower another one, making them permanently dependent on one another.

**Checks and Balances** is a mental model used by historians to explain the concept of separation of powers. It was also a mental model used by the Founding Fathers in **processing the problem**; the problem, was:

`How do we create and maintain a government run by the populace?`

See? Mental models have been used all throughout history. Even the term *Mental Model* is a mental model, as it describes and summarizes the externalization of one's understanding of a problem or concept outside of themself. 

Our goal with creating a mental model for a problem is to describe and summarize the steps required to solve the problem. This is not something **overly** detailed; rather, this is one to three sentences, whatever it takes for you to understand the problem at a level that you can articulate it to someone else.

Take this time to write a mental model for this problem, and scroll down when you're ready to compare with mine.

###### My Mental Model

`Determine a list of all the substrings for each letter in a given string. Then, count the total number of vowels in each substring. Finally, sum the total number of vowels for all substrings.`

Things to check before moving on: 
1. Does your mental model explain each step of solving the problem?
2. Is it using the same language as used in the problem description?
3. Are you being specific enough with your language?
4. Can you articulate your mental model to someone else who will ask questions about it?

#### Examples and Test Cases

If the author hasn't given you examples to test with it's imperative that you brainstorm some test cases before coding. Even if the author has given you examples to test, it's still a good idea to create a couple test cases of your own, especially ones that you may think are **edge cases** that will throw up exceptions or errors in your program. Creating your own examples also furthers  your own understanding of the problem.

Here's one example:

`Input: 'abce': 'a,' 'ab', 'abc', 'abce', 'b', 'bc', 'be', 'c', 'ce', 'e'`
`Output: 8`

Word to the wise: on a question like this that requires long lists, use short examples to test your solution and understanding. 

In my example, I did the following:
1. Wrote input and output.
2. Wrote out all expected substrings.

This example gives me two things to check:
1. Is the list of substrings accurate?
2. Is the output accurate?

If my code runs false on either of the questions above, I know I've got some sort of logical error in my code.

We're one step closer to mastery!

#### Data Structures
Personally, this is my favorite part of the **PEDAC** process. There's so much variation in which data structures people select for the same problem. This is especially true in *Ruby* where there's an endless amount of ways that one can go about structuring and solving a problem.

In this step we're **brainstorming** for the next step, Algorithm. We're going to select which data structures we think will work most efficiently for each step of our mental model, and then in the next step we will write out our code in pseudocode.

Write out which data structures you want to use for the following:
1. How and where will you store the substrings?
2. How and where will you store the vowel counts?
3. How will you store the total vowel count?

Scroll down when you're ready to see my answers.

###### My Data Structures
1. Store the substrings in a an array titled: `substrings`
2. Store the vowel count in a local variable titled: `vowel_count`
3. The vowel count total is contained in the `vowel_count` local variable.

#### Algorithm
I think that the *Algorithm* step is where most students falter, myself included. When I'm live coding in front of other people I tend to rush this step.

This is the last step that anyone should be rushing. It is arguably the most crucial part of the **PEDAC** process. Not having an algorithm for your code is like not having a map for your journey. For the fellow Fantasy genre-nerds out there, think of Frodo and Sam's journey to Mordor. 

Would they have gotten there faster if they'd had a map? 

Would they have needed to befriend Gollum in order to get directions?

Would they have suffered far less if they could've avoided certain areas?

Umm...**YES** to all the above!

Do not be like Mr. Frodo; take a map with you when you go coding.

In the algorithm step, we're going to write out our program from start to finish in our native language. The goals in creating an algorithm are the following:
1. Create a solution that can be readily converted to code.
2. Maintain flexibility in the potential code in case something does not work as expected.
3. Create a linear solution that logically progresses like the actual program will.
4. Use specific language, relevant to the problem, that accurately describes and places data structures wisely in the program

I'm going to put my algorithm for this problem below, so if you want to try it on your own first, go ahead. The algorithm can be tricky to create, so there's no shame in simply scrolling down to see what I have to offer.

###### My Algorithm
1. Create an empty array named `substrings` that will contain the substrings.
2. Create a local variable named `counter` that will be used to create a range of characters within the given `string`.
3. Create a local variable named `vowel_count` that will be used for counting vowels in the elements of `substring`.
4. For every `character` in the input `string`:
* Check for `counter` being equal to the length of `string`. If true, append only `character` to `substrings` and exit the loop or iteration.
* Otherwise, append the result of `character` up to and including `counter` to `substrings`.
* Increment `1` to `counter`
5. For each `element` in `substring`:
* Count the amount of vowels `aeiouAEIOU` and add the amount to `vowel_count`
6. Return `vowel_count`.

###### How Long It Took Me
This algorithm took me about **20 minutes** to create. For more complex problems it will take even longer. An algorithm isn't something that can be or should be rushed. 

An algorithm is like a slice of chocolate cake, with whip cream on top, its frosting melting down the sides, practically begging to be eaten. 

It's beautiful, and tempting to eat in one bite; however, it should be savored. You should take your time enjoying each delicious spoonful of chocolate heaven as it embraces your mouth in a warm hug.

See, I kept my promise. This article **is** about chocolate cake.

#### Finally, Coding with Intent!
The long awaited moment is finally here: we can start coding!

With your map in hand, attempt to translate your algorithm into your programming language as well as you possibly can. Most likely there will be some logical or method restraints that will require some flexibility on your part. Do you best to take your time, stay cool in the face of the storm, and preserve hope.

PARTY WILLY (C) BROADSOFT 2004
===========

For the Sinclair ZX Spectrum

Written by Andrew Broad
http://www.geocities.com/andrewbroad/


Party Willy is released as a box-set containing:
* two 48K parts (PART1.TAP and PART2.TAP);
* a JSW128 version which combines the two parts (PW128.TAP);
* the old Jet Set Willy: Manic Miner (JSWMM_OLD.TAP);
* the new Jet Set Willy: Manic Miner (JSWMM_NEW.TAP);
* Manic Miner: Jet Set Willy (MMJSW_1.TAP, MMJSW_2.TAP, MMJSW_3.TAP);
* reniM cinaM (MIRRORMM.TAP);
* ylliW teS teJ (MIRRORJSW.TAP).

It's called Party Willy because it's in several parts! ;-)

-----------
Party Willy
-----------

When I was at school, someone made a fictitious claim about a new Jet Set Willy game that rather excited me. The alleged game was called _Party Willy_, in which Willy had been to a party and had to make his way home to his mansion. I remember something being said about walking along railway lines...

Although I now realise they were most probably talking about the VIC-20 game _The Perils Of Willy_, I still wanted to make Party Willy a reality, so, in the year of Jet Set Willy's china anniversary, here it is!

Party Willy is a redefinition of the rooms, items, guardians and graphics in Matthew Smith's classic Jet Set Willy, which I acknowledge as being the copyright of Software Projects (1984) - owned by Jester Interactive since 2001.

I developed the game using my own Jet Set Willy Construction Kit (also released on the Internet) under the RealSpectrum emulator between April 2003 and April 2004. In fact I started my first attempt at writing Party Willy on my real Spectrum +2, which sadly I had to lay to rest on 13th April 2003 when the motor in the datacorder burned out. I lost about a week's work on Party Willy that I had done in December 1999 before putting the project on hold for more than three years.

Originally, Party Willy was going to be a standard 64-room JSW game. But when I analysed all the rooms I wanted to include, the total came to 68. Blissfully ignorant of J.G. Harston's extension of the 48K JSW game-engine to allow up to 72 rooms, I therefore decided to do a double 128-room game (two 48K parts, merged together to produce the JSW128 version, PW128).

Half of the rooms are reinterpretations of the original JSW rooms - laterally inverted because Willy goes through a time-warp. The rest are revamped versions of rooms that I wrote for a game I abandoned in 1993 called _Jet Set Willy: Manic Miner_, plus a few rare rooms from other sources, and many brand new rooms that I wrote in 2003 and 2004.

Although easier to explore than my previous JSW games, Party Willy is written for advanced JSW players, and the rooms are intended to be difficult, as a challenge to the experts. It presupposes that you can play Jet Set Willy - the controls are exactly the same, but the gameplay is much tougher, requiring both manual dexterity (a need for pixel-perfect and time-frame-perfect accuracy of movement) and lateral thinking. Party Willy liberally exploits all the quirky features in the game-engine - you need to know all the tricks if you want to get far!

I have tried to be fair, though, by keeping infinite-death scenarios to a minimum. You shouldn't encounter infinite death unless you do something really stupid, such as jumping into an unfamiliar room when you should be walking into it, falling off the bottom of a screen from a height of more than four characters, or doing any of the following:

Infinite-death scenarios in Part 1:
* falling into "The Gaping Pit of Infinite Death" [16];
* going back down from "Skyhooks" [24];
* walking back from "The Magic Faraway Tree" [38] to "The Forest" [30] where it's obvious you need to jump;
* taking the top-right exit of "Disintegrator Rising" [10] holding all 128 items from Part 1.

Infinite-death scenario in Part 2:
* jumping right from the rightmost column (column 31) of "Something for the Rag & Bone Man" [11] - you do need to jump out of this room when taking the bottom-right exit, but NOT from column 31.

The above lists are not exhaustive. Sometimes you /do/ need to jump into a room (often from the very edge with your legs apart to avoid infinite death) - if in doubt, look up tips for the room in ROOMS_PART1.TXT or ROOMS_PART2.TXT.

I have thoroughly play-tested the final versions (Part 1, Part 2 and PW128), and I certify that it /is/ possible to complete them without sacrificing a life. However, when playing Part 1 to completion, I strongly recommend that you leave the two items in "Attributes of Maria (Sharapova)" [35] until you have collected the other 126 items - otherwise you may be forced to enter that room at the top-left (i.e. from the top-right of "Disintegrator Rising" [10]) holding all 128 items, which would trigger running-mode and cause an infinite-death scenario.

You can consider yourself to have passed Party Willy if you finish the game using infinite lives (POKE 35899,0) on a real Spectrum, or saving and loading snapshots on an emulator. If you cheat by using any other POKEs, or by using WRITETYPER, you should consider yourself disqualified. ;-)

Members of the Manic Miner and Jet Set Willy Yahoo! Group [http://groups.yahoo.com/group/manicminerandjetsetwilly/] can view exclusive screenshots in the Photos section.

Part 2 (and hence PW128) contains a sexual image which some may find offensive. This may be airbrushed out at the option of the user.


ROOMS_PART1.TXT and ROOMS_PART2.TXT contain a blow-by-blow description of each room in Party Willy. If you're stuck, it's most likely that your problem will be covered in the tips section for the room in question.

--------
The Plot
--------

WARNING: Some readers may find the following story sexually or religiously offensive.


Well we all know that woody was no good for Willy, far too absent and unreliable, and to be honest not as attractive as Willy's gorgeous, sexxxy housekeeper Maria. ;-)

"Oh Maria," sighed Willy. "You are the most voluptuously luscious woman I've ever known. You are one fat, buttery biscuit. Will you marry me?"

"Oh Willy," sighed Maria. "You make me feel like a man should a woman."

So Willy and Maria were engaged to be married. On the eve of their wedding, Willy received the following message from his email-pal Jet Set Dick:

"Congratulations on your engagement! It gives me great pleasure to invite you to a bucks party at my house tonight. Let's celebrate your last night of bachelorhood in style!"

So that night, Willy made his way to Dick's house on the other side of Surbiton. While not as large and impressive as Willy's mansion, it was a neat little house, with innocent-looking blocks and a non-swinging rope giving access to an upper room.

Dick greeted Willy at the doorway, and introduced him to his housekeeper Martha (Maria's sister). They embarked upon an orgy of disgusting alcoholic drinks, heavy-metal music and triple-decker sex.

At midnight they threw Willy out of the house. He was senselessly drunk, naked apart from his top hat, his anus was bleeding and he had a strange tingling sensation in his penis (like he wanted to urinate all the time even though his bladder was empty). His eyes welled with tears at the prospect of walking home in such a state, but off he set...


In Part 1 you must guide Willy home across a mining-site, along the railway-tracks, through a time-warp which laterally inverts him by turning him over in the fourth dimension (thus causing him to experience his reality as though it were laterally inverted), and so return with 128 items to Willy's mansion - which has undergone many changes - by midday.

In Part 2, Willy is suffering from post-traumatic stress disorder which makes him agoraphobic. Luckily for him, almost all of Part 2 is set indoors!

In Part 2 you must seek absolution for Willy's sins (wilful drunkenness, fornication, trespassing on private property, theft, cheating at computer-games, listening to `bad' music, and receiving Holy Communion in the state of mortal sin) so that he can marry Maria in The Chapel. You must complete Willy's collection with another 128 items by midnight so that Maria will let him consummate their marriage.

---------------------------------------------------------------------------
Jet Set Willy: Manic Miner (MMtoJSW) & Manic Miner: Jet Set Willy (JSWtoMM)
---------------------------------------------------------------------------

_Jet Set Willy: Manic Miner_ is a conversion of the original Manic Miner rooms to Jet Set Willy. I originally developed JSW:MM on a Spectrum +2 in 1992/1993, using my own Jet Set Willy Screen Editor (predecessor of Jet Set Willy Construction Kit). JSWSE had limited capabilities (it supported room-editing, but not items, guardian-classes, 16x16 graphics, &c.), which really show in this game! ;-)

Since Manic Miner has only 20 rooms whereas Jet Set Willy has 64, there were 44 rooms left over. I edited 27 of these into new rooms before I abandoned JSW:MM in 1993; these rooms have been revamped and included in Party Willy itself. The old JSW:MM is not possible to complete as it stands, because of items in unreachable rooms.


However, I have now written a new JSW:MM with just 21 rooms (the 20 MM rooms plus "Master Bedroom"), which /is/ completable. The new JSW:MM was generated semi-automatically by my Java program MMtoJSW, which will be released as part of SPECSAISIE 1.3 (possibly later in 2004). I post-edited the game by hand to set the exits, place the ramps (which generally substitute for crumbling floor), and various other tweaks to make a fair and completable JSW game.

MMtoJSW also performs the following conversions which are not room-specific:
* start-room and position (as Room 0);
* number of lives;
* special graphics (Willy, swordfish->toilet, plinth->barrel, boot->foot, Eugene->Maria);
* colour-attributes of toilet, barrel (on Game Over screen) and Maria;
* title-screen and score-area;
* the scrolly and "Game Over";
* the title-screen tune and in-game tune;
* winds back the clock to give you as many time-frames as the sum of the air across all 20 rooms!


_Manic Miner: Jet Set Willy_ is a conversion of the original Jet Set Willy rooms to Manic Miner. I developed MM:JSW on a Spectrum +2, using my own Manic Miner Screen Editor. I started MM:JSW in 1993 and finished it in May 1996 (following a complete break from MM/JSW-authoring since 1994).

MM:JSW is in three 20-room volumes, since MM has 20 rooms whereas JSW has 64. Volume I contains Rooms 0-19, Volume II contains Rooms 20-39, and Volume III contains Rooms 40-60 with the exception of Room 47 ("[" - because it's omitted from MM:JSW, an interpretation of this room appears as Room 7 in _Manic Miner: The Buddha of Suburbia_). I have thoroughly play-tested all three volumes, and I declare that it is possible to complete every one.


JSW:MM and MM:JSW are part of my MM<->JSW Conversion Project, which aims to produce methods for converting rooms from MM to JSW and vice versa. Future work is to write a program to do the JSW-to-MM conversion semi-automatically (i.e. with some human intervention). I have already knocked up a quick JSWtoMM to do the non-room-specific conversions:
* number of lives;
* special graphics (Willy, toilet->swordfish, barrel->plinth, foot->boot);
* title-screen and score-area;
* the scrolly and "Game Over";
* the title-screen tune (a notable first for MM-editing!) and in-game tune;
* the colour-attribute with which the red and cyan squares on the piano are erased;
* colour-attributes of swordfish (although the position has to be set during post-editing, as it derives from the portal).

--------------------------------------------------
reniM cinaM (MirrorMM) & ylliW teS teJ (MirrorJSW)
--------------------------------------------------

These are laterally inverted versions of the original Manic Miner and Jet Set Willy. It's most intriguing how mirroring affects the atmosphere of these games! :-)

_reniM cinaM_ and _ylliW teS teJ_ were generated fully automatically by my Java programs MirrorMM and MirrorJSW, which will be released as part of SPECSAISIE 1.3 (possibly later in 2004).

My goal for MirrorMM and MirrorJSW has been to produce an automatic transformation that is:
(a) fully automatic, requiring no post-editing (MirrorMM) or only slight post-editing (MirrorJSW);
(b) reversible, i.e. MirrorMM(MirrorMM(x)) = x, and MirrorJSW(MirrorJSW(x)) = x.

My goal is /not/ for these transformations to hack the game-engine to bits at the risk of losing generality and reversibility. MirrorMM and MirrorJSW mostly just edit `data' (including instruction-operands) and leave the `code' alone (although MirrorMM does NOP out the CPL instruction at 36259 - or reinstate it in the case of a reverse transformation - which is necessary to mirror solar power correctly). But I have resisted the temptation to plant code-extensions such as a custom font (for mirror-writing), or to fix the Block-Graphics Bug that sadly afflicts _reniM cinaM_.


MirrorMM simply works through the room-data, plus the Room-19 picture (if Room 19 is to be mirrored - both programs can mirror an entire game, or just one room or a contiguous subrange of rooms).

MirrorMM also performs the following mirroring operations which are not room-specific:
* Willy's sprites (even though they are symmetrical in the original Manic Miner);
* the middle third of the title-screen (pixels and colour-attributes, and Willy);
* the scrolly;
* the title-screen tune (a notable first for MM-editing!) and the in-game tune (not strictly mirroring, but fun!);
* the Game Over screen (the message and Willy's sprite);
* the behaviour of the switches in the Kong-Beast rooms (another notable first!);
* Skylabs now regenerate 8 (or n) columns to the /left/ after crashing;
* solar power (the start-column of the beam, which now deflects to the left);
* the position and appearance of the swordfish at the end of the game.


MirrorJSW uses mark-sweep algorithms to mirror the guardian-classes referred to in the rooms, and the sprite-pages referred to in the guardian-classes. Mark-sweep ensures that each guardian-class and each sprite-page will be mirrored at most once, since the mirroring is performed only after the marking is completed.

Whenever a guardian-class is referred to, it is marked `to mirror' (the program maintains an array of 127 Booleans for this purpose). Whenever a sprite-page is referred to, it is marked either to mirror as horizontal sprites, or as vertical sprites (the program maintains an array of 256 integers), with horizontal sprites taking precedence whenever a sprite-page is used for both horizontal and vertical guardians.

After initially trying separate routines to mirror bidirectional and unidirectional HG sprite-pages, I decided to use the bidirectional routine for all horizontal sprite-pages, toggling the start-sprite between 0 and 4 for unidirectional HGs. This handles almost all HGs properly, even the `disrespectful' monk in The Chapel!

A corollary of this decision is that I had to swap the two halves of not only horizontal sprite-pages, but also vertical sprite-pages, since some sprite-pages mix horizontal and vertical sprites. This handles almost all VGs correctly, a notable exception occurring in The Kitchen diptych (to fix this would involve fiddling with individual sprites and the animation-mask, which I /may/ still get around to in the future).

MirrorJSW also performs the following mirroring operations which are not room-specific:
* the item-table;
* Willy's sprites (even though they are symmetrical in the original Jet Set Willy);
* start-position;
* special graphics (Willy, toilet, barrel, foot, Maria);
* Maria's position and colour-attributes;
* the toilet's position and colour-attributes;
* the title-screen;
* the scrolly;
* the title-screen tune and the in-game tune (not strictly mirroring, but fun!);
* the Game Over screen (the message and Willy's sprite).

I mentioned that some slight post-editing was required to produce _ylliW teS teJ_ from the output of MirrorJSW:
* "tsaE moorllaB" [20] to make it possible to return from the high ledge, since JSW game-mechanics are asymmetrical;
* the ledges in "ralleC eniW ehT" [49], since JSW game-mechanics are asymmetrical;
* the cavity under the bed in "moordeB retsaM" [35] leading back to "moorhtaB ehT" [33] to make the game toilet-completable, since I couldn't figure out how to make Willy run left;
* the official Software Projects pokes (laterally inverted, of course);
* bypass the colour-code routine.
These pokes are applied by the BASIC loader. The game on the tape is the pure output of MirrorJSW.

reniM cinaM and ylliW teS teJ both come with the usual Broadsoft guarantee of completability.

--------------------
Loading Instructions
--------------------

To play these games, you need a Spectrum emulator that is capable of loading TAP files (I hope I'm right in thinking that the emulators you all use are capable of loading TAP files, as I don't want to complicate matters by also releasing snapshot files). To find an emulator for your particular computer, see the Emulators section of the comp.sys.sinclair FAQ [http://www.srcf.ucam.org/~pak21/cssfaq/emulator.html].

A TAP file is an encoding of the files on a Spectrum tape (as opposed to a snapshot file, which is an encoding of the complete state of a Spectrum at the moment it was created). To load from a TAP file, you have to issue a load-command to the emulated Spectrum (i.e. select Tape Loader or type LOAD "" (in 48K mode, press J for LOAD and SYMBOL-SHIFT+P for ")). You also have to open the TAP file in the emulator (either before or after issuing the loading instruction).

----------------
Acknowledgements
----------------

* Matthew Smith, for writing the original Jet Set Willy, and in particular for deciding on an unencrypted, perspicuous room-format! ;-)

* John Elliott for the 128K version of Jet Set Willy (JSW128), for his editor JSWED v2.0.3 (which I used at the end to help derive PW128 from the two 48K parts), and also for his invaluable disassembly of the JSW game-engine and his description of the JSW128 music-format.

* Derrick Rowson for _Jet Set Willy II: The Final Frontier_ (Software Projects, 1985). Party Willy has rooms which are reinterpretations of "Willy's Bird Bath" (Part 1, Room 59), "Garden" (Part 1, Room 60) and "Macaroni Ted" (Part 2, Room 2).

* Paul Rhodes, for the two rooms included with his _JetSet Editor_ (Spectrum Electronics, 1984), which appear in Part 1 of Party Willy (Rooms 47 and 61).

* Softricks, for the two rooms included with their JSW Editor MkII, which appear in Part 2 of Party Willy (Rooms 45 and 46).

* Dave Nichols for the "April Showers" room (Part 2, Room 47), which was published in _Your Spectrum_ magazine (Issue 18, April 1984).

* All my fellow MM/JSW authors, for general inspiration and some specific tricks (sometimes unintended on their part, but deliberately exploited by me! ;-) ).

* Party Willy was written on Ramsoft's RealSpectrum emulator, using my own Jet Set Willy Construction Kit.

* Many thanks to Richard Hallas for rescuing JSW:MM and MM:JSW from tape and converting them to emulator-format for me!

* Richard Hallas's document "A Miner Triad" was an invaluable aid to redefining the music.

* The title-screen tune of Party Willy (Part 1) is "Morning" from Edvard Grieg's Peer Gynt Suite - from which the original Manic Miner tune "In the Hall of the Mountain King" comes!

* The in-game tune of Party Willy (Part 1) and of PW128 is "Where bluebirds fly." from Radiohead's 2003 single "There there."

* The title-screen tune of Party Willy (Part 2) and of PW128 is "A Wolf at the Door." from Radiohead's 2003 album _Hail to the Thief._

* The in-game tune of Party Willy (Part 2) is "Insomnia" by Faithless (from their 1996 album _Reverence_).

---------------
Technical Notes
---------------

I have hacked the JSW game-engine in the following ways:

* To play as different characters in different rooms, each room specifies a sprite-page for the player in Offset 237, as documented in my 2000 game _Jet Set Willy: The Lord of the Rings_. The same effect is used in John Elliott's JSW128 and in Geoff Eddy's JSW-games.

* To implement a 24-hour clock, as documented in my 2002 game _Goodnite Luddite_. Part 1 ends the game at 12:00, Part 2 and PW128 at 24:00. These deadlines are *very* generous - I managed to complete both Part 1 and Part 2 in just over four JSW-hours each, and PW128 in just over six JSW-hours!

* For the JSW128 version (PW128), I have implemented a patch to have two Master Bedrooms (with a separate Maria in each) and two Bathrooms (with a separate toilet in each). When you have collected the 128 items from Part 1, the Part 1 toilet will teleport you to Part 2 - with a special effect that may be familiar from Manic Miner. Details of this "mid-game completion" patch are in TECHNICA.TXT (along with details of how I fixed sprite-selection for remaining lives in the JSW128 version).

--------
Internet
--------

I currently have a website at http://www.geocities.com/andrewbroad/. Some relevant pages within this website are:

* http://www.geocities.com/andrewbroad/spectrum/
Top-level index of my Spectrum pages.

* http://www.geocities.com/andrewbroad/spectrum/willy/
My Manic Miner/Jet Set Willy pages, including a list of Spectrum MM/JSW games (which I try to maintain as complete and up-to-date as possible - please inform me of any I have missed), various other MM/JSW documents, and links to other MM/JSW websites.

* http://www.geocities.com/andrewbroad/spectrum/download/
My download page. Currently contains my other games, my Manic Miner Screen Editor, my Jet Set Willy Construction Kit and my Java toolkit SPECSAISIE. Also has previews of forthcoming software (mostly MM/JSW games).

I founded a Yahoo! Group for Manic Miner and Jet Set Willy. Its URL is:-
http://groups.yahoo.com/group/manicminerandjetsetwilly/
It includes a message-board for discussing MM/JSW (with options for receiving and sending messages by email), Files and Photos (read screenshots) sections which members can upload to, Bookmarks and Calendar. Anyone can visit the Group and look around its public areas, but for full privileges you have to join the Group as a member. This prerequires signing up for a Yahoo! account, which you can do, free of charge, over the Web. I encourage all members of the MM/JSW community to join this Group.

I recommend the comp.sys.sinclair USENET newsgroup as a place for discussing MM/JSW and other Spectrum-related topics. It's worth at least browsing through the headers each week (says he who has long since lost touch with USENET, but is now trying to `get with' comp.sys.sinclair again). The newsgroup is archived at http://groups.google.com/ for those who don't have access to a news-server - in fact, it's worth surfing there even if you do, as not all news-servers receive all newsgroup postings!

The World Of Spectrum forums [http://www.worldofspectrum.org/forums/] are worth browsing through on a regular basis, particularly the Games forum (this is something I do on a weekly basis).

----------------
Copyright Notice
----------------

Party Willy is, of course, my copyright, but I don't mind you putting it on your own website or redistributing it otherwise, provided that no money is charged, and that you acknowledge that it is the copyright of Broadsoft (2004). This document must be included with all copies of the game. Modifications are discouraged but not forbidden, and you should state specifically what you have modified.

I don't mind you reusing some of the rooms, graphics, &c. in your own games, or converting the game to another computer (e.g. for JSW-PC). However, the accompanying documentation must state that the reused material is the copyright of Broadsoft - failure to do so may be construed as plagiarism. I would like the documentation to be quite specific about this, e.g. "Graphic X in Room Y was taken from Party Willy", or whatever.

Please let me know if you do rerelease Party Willy or reuse bits of it - it's not that I'd be likely to object, I'd just be very interested to know what follows from my releasing it!

---------------
Version History
---------------

1st April 2000: Public beta-versions of _Jet Set Willy: Manic Miner_ and _Manic Miner: Jet Set Willy_ released on the Internet.

12th April 2004 (Jelena Dokic's 21st birthday): Party Willy (Part 1) released on the Internet. This supersedes the beta-releases of JSW:MM and MM:JSW, which are included here for historical interest (I have made some changes to MM:JSW, such as the title-screen, the music, Willy's hat, and proper Room 19 pictures - the three volumes are now in separate TAP files, but the only rooms edited are the Room 19s). The old README.TXTs are superseded by this new README.TXT, ROOMS_PART1.TXT and ROOMS_PART2.TXT. This release also adds _reniM cinaM_, _ylliW teS teJ_, and a new JSW:MM with just 20 rooms.

23rd April 2004 (Daniela Hantuchová's 21st birthday): Party Willy (Part 2) released on the Internet. This adds PART2.TAP, PW128.TAP, TECHNICA.TXT and ROOMS_PART2.TXT to the 12th April 2004 release, and this file README.TXT has been edited and updated.

7th February 2005: Party Willy reissued with minor corrections to TECHNICA.TXT.

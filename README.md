Micro-Pac 64
============


About
-----

This is my attempt to create (yet another) Pac-Man game for the
Commodore 64. My aim is to re-create the experience of the Famicom/NES
port of Pac-Man, and enhance it somewhat. The design goals are:

- Single screen gameplay; no scrolling mazes!
- Arcade accurate ghost AI.
- All intermissions.
- Enhanced sound FX and music.
- High score saving to disk.


Status
------

Right now, the game is still very much a work in progress. In July
2024 I implemented a basic prototype which featured an animated,
joystick-controlled Pac-Man sprite moving through the maze. Since then
I haven't had much time to continue working on the code. The initial
prototype was created on a Commodore 64 using Profi-Ass 64, which was
an excellent assembler for its time. Unfortunately, with our hectic
lifestyles today, most of us simply don't have the kind of time
available anymore that we had back in the '80s and '90s. Waiting 10
minutes for your code to assemble before you can test a routine is
just no longer feasible. So I recently (December 2024) made the
decision to begin converting the code to vasm. This process is about
90% complete. I just need to iron out some bugs introduced during the
conversion and convert the table definitions, but I'll probably just
write a shell script to do that.


Todo
----

- ~~Complete code conversion to vasm format, incl. data tables.~~
- ~~Include assets when producing binary (they currently need to be
  loaded into memory individually)~~
- Create separate timers for sprite and power pellet animations (they
  currently share a timer)
- Much, much more, but I'll probably create issues for all remaining
  work.

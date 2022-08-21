# Gyakuten Radio

This is the code behind [Gyakuten Radio](https://youtube.com/c/UraYukimitsu/live).

## Dependencies

This radio uses ffmpeg and imagemagick.

## Initial setup

In `stream.sh`, edit the variables `STREAM_URL` and `KEY` near the top of the file according to what you need.

Grab the JF Dot K14 font from [here](http://jikasei.me/font/jf-dotfont/), and the Igiari font [here](https://www.dafont.com/igiari.font), and put them in a new folder named `fonts`.

If you don't appreciate my beautiful art, you're also going to want to replace `courtroom.png` with something else, but I'm sure you can figure out where to find it yourself.

Next, you'll want to add some character pictures of your liking in `characterPics`. I have included one of my own creations as an example.

Finally, add music in some subfolders. The album art should be named `Folder.jpg`. I have included an example of what a music subfolder looks like in `TurnaboutThrowback` (please come listen to it on [YouTube](https://www.youtube.com/watch?v=vNg4mgVixSk&t=1s) too if you want!)

Once all that is done, run `./init.sh` to generate the files `playlist.txt` and `imgList.txt`.

## Running the radio

After the initial setup is done, you can run the radio simply by running `./stream_playlist.sh`. Please note that it *will* run as a foreground task so run it inside tmux or something like that if you're doing it in a console-only environment.

If you want to force the radio to play a certain song, create a file named `overrideList.txt` and write the path to your music file inside it.

To skip a song, press Ctrl+C.

To stop the radio, hold Ctrl+C until it stops completely.

To add songs and/or new character pictures, just add them like you did in **Initial setup** and run `./init.sh` again. You can even do it while the radio is running.

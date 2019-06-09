# locfg.pl Dockerfile

## What this is for

Some older HP servers require SSLv3 to run, but newer Linux distributions have
removed SSLv3 support from openssl libraries.  This Dockerfile allows you to
run the script with a custom openssl with SSLv3 support.

There is also a modified version of the locfg.pl command here.  This is
because (In my experience) the ILO system isn't good at negotiating SSL
capabilities so you need to force it to use a specific version.

This copy of locfg.pl defaults to TLSv1 which will run on newer blades and
doesn't require the Dockerfile.

## Updates in 2019

cpasternack:
Since Robert Drake @rfdrake created this in 2016, Debian jessie has since shuffled off its mortal coil,
or at least the updates repo has. This is now a hack-on-a-hack to get the docker image to build. If you
are like me, and need to update a thoroughly ancient firmware version not by OS or web interface, this
is probably the only solution. I tried all the other management options, including the very good python-hpilo.

These all suffer from the retirement of SSLv3. (this is a good thing until it isn't)

The latest version of locfg.pl did not run on my machine due to a script error at line 196 in the supplied file.
I commented out the check for ilo2, because I will fix that for my ilo2 machines  

This docker image probably can be used as a basis for the java icedtea web start since NPAPI plugins were retired.
Sometimes you still need java to make a connection via SSLv3....

Probably worth investigating later too.

## Setting up

On the initial run you will need to execute this command:

    docker build -t cpasternack/locfg .

## running the script

    docker run cpasternack/locfg -u admin -p password -s 10.80.80.80 --sslproto=SSLv3 -f Update_Firmware.xml

Update_Firmware.xml can be found in the HPE package for locfg.pl along with other xml files to manage ilo3

# Copyright and things

The HP script is owned by HP.  It comes with the "HP Lights-Out XML PERL
Scripting Sample for Linux" and is generally freely available.  You can get a
new version here

    http://h20564.www2.hpe.com/hpsc/swd/public/detail?swItemId=MTX_11193baaa82348e993033ccc77

But HPE tends to move files around so I don't know how long that url will
last, you might be better off google searching for it.


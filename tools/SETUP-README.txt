OccultEyes Create Modpack - one setup step left
===============================================

The instance is installed, but it has no mods yet. They arrive automatically
once you turn on the auto-updater. This takes about 30 seconds, once.

In ATLauncher:

  1. Right-click this instance -> Edit Instance -> Settings -> Commands tab
  2. Set  "Enable commands?"  to  Yes
       (it defaults to "Use Launcher Default", which means off)
  3. Paste this into the "Pre-launch command" box, exactly as written:

"$INST_JAVA" -jar packwiz-installer-bootstrap.jar __PACK_URL__

  4. Save, then Play.

The first launch downloads ~230 MB of mods and will take a few minutes.
A progress window appears before Minecraft starts - let it finish.

After that, every launch checks for updates automatically. When the pack
changes you get the new version the next time you press Play. There is
nothing else to install, ever.

Troubleshooting
---------------
Game starts with no mods at all  -> step 2 was missed; "Enable commands?"
                                    is still on "Use Launcher Default".
No progress window on first launch -> the command text is wrong. It must
                                    include the quotes around $INST_JAVA.

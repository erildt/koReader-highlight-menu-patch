# koReader-highlight-menu-patch
Patch to make simple changes to the koReader highlighting menu

## How to use
Copy the **2-highlight-menu-modifications.lua** file into Patches.

Follow the instructions [here](https://koreader.rocks/user_guide/#L2-userpatches) on how to install patches.

## Purpose
Initially this was for me to be able to easily underline text as well as lighten, without having to go through a million menus. Then I also added in functionality that saves the full chapter path in the highlight. 
- I.e. instead of just "Chapter 1", it would save "Section 1 ▸ Part 1 ▸ Chapter 1", for as many depths as available.

This can also be used to simply remove menu buttons that are unwanted, to re-order menu buttons, or as a playground for anyone who wants to tinker with what the highlight menu buttons can do.

## Editing

Use a text editor like Notepad++ to view programming structures, or the basic notepad if you don't have it.

&nbsp;

The buttons are written in the function **ReaderHighlight:init()**, declared by **self._highlight_buttons = {...}** on line 20.

> - You can cut+paste each chunk of text to move buttons around, or delete a chunk to remove the button. Remember to renumber the buttons after doing so.
>
> - ["03_underline"] is my custom button - you can remove this if you don't want it.
> - I removed the original ["05_wikipedia] button, but I added it into this file as a comment. Uncomment it if you want it back.

&nbsp;

My custom highlighting function starts on line 139 

-> **function ReaderHighlight:saveHighlightFormatted(extend_to_sentence,hlStyle,hlColor)**

> - To only use the original highlighting function, comment out line 41 and uncomment line 42 in the block ["02_highlight"]
> - You can also remove my custom button ["03_underline"]
> - You can delete the saveHighlightFormatted function but you don't need to

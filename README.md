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

## Using it as highlight colors menu

You can increase column number in readerhighlight.lua to make it horizontal.

*koreader/frontend/apps/reader/modules/readerhighlight.lua, line 1511*
> - local columns = 2

*example*
![image](https://github.com/user-attachments/assets/5103aba1-0bf4-4bea-9b08-339adafe4700)

To use images instead of texts, put your images in 
```
resources/icons/mdlight
```
In the user patch, instead of 

```
text = "purple",
```
put 

```
icon = "grape",
```

*example2*
![image](https://github.com/erildt/koReader-highlight-menu-patch/blob/10f9c2e73a564f472de96530999b994735ca44d9/20250607_140339.jpg)

*example3*
![image](https://github.com/erildt/koReader-highlight-menu-patch/blob/6a637d68d345bd29c0e580b51bec3290eda7b413/20250607_124456.jpg)

- Two actions for one button(press and long-press)

You can also assign two actions to one button using callback(press) and hold_callback(long_press).
